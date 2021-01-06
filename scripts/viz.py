#!/usr/bin/python
# -*- coding: utf-8 -*- 
import copy
import os
import sys
import networkx as nx
import pygraphviz as pgv        
import clingo
import itertools
import pdb
class Context:
    def id(self, x):
        return x
    def seq(self, x, y):
        return [x, y]

def isint(value):
  try:
    int(value)
    return True
  except ValueError:
    return False

type_formula = sys.argv[1]
in_path = sys.argv[2]
env = [in_path.split(os.sep)[i+1] for i,d in enumerate(in_path.split(os.sep)) if d=='env']
base_path,file_name = os.path.split(in_path)




def construct_str_map(symbol):
    if str(symbol.type) == "Number":
        return str(symbol.number)
    if str(symbol.type) == "String":
        return str(symbol.string)
    args = symbol.arguments
    name=str(symbol.arguments[0]).replace('"','')
    start = 1

    if isint(name):
        start = 0
        name = ""
    args_str = []
    for e in symbol.arguments[start:]:
        args_str.append(construct_str_map(e))

    if name == "&" and len(args)==2:
        s = args_str[0]
    elif name == "~":
        s = "~"+args_str[0]
    elif name == ">":
        s = "○"+args_str[0]
    elif name == ">:":
        s = "⍥"+args_str[0]
    elif name == ">?" and len(args)==2:
        s = "⬦ {} ".format(args_str[0])
    elif name == ">*" and len(args)==2:
        s = " ⃞ {} ".format(args_str[0])
    elif name == "&" and len(args)==3:
        s = " {} & {} ".format(args_str[0],args_str[1])
    elif name == "|" and len(args)==3:
        s = " {} | {} ".format(args_str[0],args_str[1])
    elif name == ">?" and len(args)==3:
        s = " {} ⋃ {} ".format(args_str[0],args_str[1])
    elif name == ">*" and len(args)==3:
        s = " {} R {} ".format(args_str[0],args_str[1])
    else:
        s = name+"("+','.join(args_str)+')'
    return s

def str_formula(symbol,maps):
    #--------- TEL
    if type_formula == 'tel':
        return maps[str(symbol.number)]
    #--------- DEl
    if str(symbol.type) == "Number":
        return str(symbol.number)
    if str(symbol.type) == "String":
        return str(symbol.string)
    if str(symbol.type) == "Tuple":
        return str(symbol)
    
    args = symbol.arguments
    name= symbol.name

    if name == "top":
        s = "⟙"
    elif name == "bottom":
        s = "⟘"
    elif name == "prop":
        s = maps[str(args[0])]
    elif name == "neg":
        s = "~ " + maps[str(args[0].arguments[0])]
    elif name == "diamond":
        s = "< {} >{}".format(str_formula(args[0],maps),str_formula(args[1],maps))
    elif name == "box":
        s = "[ {} ]{}".format(str_formula(args[0],maps),str_formula(args[1],maps))
    elif name == "test":
        s = "({})?".format(str_formula(args[0],maps))
    elif name == "star":
        s = "({})*".format(str_formula(args[0],maps))
    elif name == "choice":
        s = " {} + {} ".format(str_formula(args[0],maps),str_formula(args[1],maps))
    elif name == "sequence":
        s = " {} ; {} ".format(str_formula(args[0],maps),str_formula(args[1],maps))
    else:
        raise RuntimeError("Invalid symbol {}".format(name))
    return s

def prop_set_to_str(prop_ids,maps):
    s = ""
    for p in prop_ids:
        if p<0:
            s+= "~"
            p=-1*p
        s+=maps[str(p)]
        s+="\n"
    return s
def add_node(g, d):
    #Define shape
    if d['type']=='state':    
        shape = 'ellipse'
    if d['type']=='trans':    
        shape = 'diamond'
    if d['type']=='test':    
        shape = 'circle'
    if d['type']=='bool':    
        shape = 'plain'
    #Define color an create node
    if d['val']=='true':
        g.add_node(d['id'],shape=shape,label=d['val'],fontcolor='#7BAA16',type=d['type'],fontsize=12)
    elif d['val']=='false':
        g.add_node(d['id'],shape=shape,label=d['val'],fontcolor='#AA1616',type=d['type'],fontsize=12)
    elif d['type']=='state':
        g.add_node(d['id'],shape=shape,label=d['val'],fillcolor='#00305E20',style='filled',type=d['type'])
    elif d['type']=='trans':
        g.add_node(d['id'],shape=shape,label=d['val'],type=d['type'],fillcolor='#FFFFFF',fontsize=10)
    elif d['type']=='test':
        g.add_node(d['id'],shape=shape,label="",type=d['type'],fillcolor='#FFFFFF',fontsize=1,width=.1)
    else:
        raise RuntimeError("Invalid type "+d['type'])
    return g.get_node(d['id'])

def remove_zero_in(g):
    to_remove= [n for n in g.nodes() if len(g.in_edges([n])) == 0 and n!='0']
    while len(to_remove)>0:
        # print([n.attr['id'] for n in to_remove])
        g.remove_nodes_from(to_remove)
        to_remove= [n for n in g.nodes() if len(g.in_edges([n])) == 0 and n!='0']

def remove_duplicated_labels(g):
    print("Removing duplicated")
    for n in g.nodes():
        if n.attr['type']!='state':
            continue
        labels = []
        for i_e, e in enumerate(g.out_edges(n)):
            label = e.attr['label']
            next_node = g.get_node(e[1])
            same_label_tuples = [l for l in labels if l[0]==label]
            if len(same_label_tuples)>0:
                t = same_label_tuples[0]
                if next_node.attr['label']==t[1].attr['label']:
                    g.delete_edge(e[0],e[1])
            else:
                labels.append((label,next_node))



def remove_test(g_old, g_new, n_from_id, n_to_rem, pi, prop_used, counters,l):
        # G_min.draw('{}/img_a_{}_min-{}.png'.format(base_path,i,n),prog='dot')
        # pdb.set_trace()
        if(n_to_rem.attr['type']=='bool'):
            node = add_node(g_new, {'type':'bool','val':n_to_rem.attr['label'],'next':[],'id':counters['next_id']})
            g_new.add_edge(n_from_id,counters['next_id'],label=l)
            counters['next_id']+=1
            return node
        elif(n_to_rem.attr['type']=='state'):
            g_new.add_edge(n_from_id,n_to_rem,label=l)
            return n_to_rem
        elif(n_to_rem.attr['type']=='trans'):
            current_id=counters['next_id']
            n_l = g_old.out_neighbors(n_to_rem)[0]
            n_r = g_old.out_neighbors(n_to_rem)[1]
            counters['next_id']+=1
            node_l = remove_test(g_old,g_new,current_id,n_l,pi,prop_used,counters,"")
            node_r = remove_test(g_old,g_new,current_id,n_r,pi,prop_used,counters,"")
            l_false, l_true = node_l.attr['label']=='false', node_l.attr['label']=='true'
            r_false, r_true = node_r.attr['label']=='false', node_r.attr['label']=='true'
            if n_to_rem.attr['label']=='AND':
                if(l_false):
                    node = node_l
                elif(r_false):
                    node = node_r
                elif(l_true):
                    node = node_r
                elif(r_true):
                    node = node_l
                else:
                    node = add_node(g_new, {'type':'trans','val':n_to_rem.attr['label'],'next':[],'id':current_id})
            if n_to_rem.attr['label']=='OR':
                if(l_false):
                    node = node_r
                elif(r_false):
                    node = node_l
                elif(l_true):
                    node = node_l
                elif(r_true):
                    node = node_r
                else:
                    node = add_node(g_new, {'type':'trans','val':n_to_rem.attr['label'],'next':[],'id':current_id})
            g_new.add_edge(n_from_id,node,label=l)
            
            return node
        elif(n_to_rem.attr['type']=='test'):
            e_l = g_old.out_edges(n_to_rem)[0]
            id_l = int(e_l.attr['prop_id'])
            e_r = g_old.out_edges(n_to_rem)[1]
            id_r = int(e_r.attr['prop_id'])
            id_prop = abs(id_l)
            not_edge = e_l if id_l<id_r else e_r
            in_edge = e_l if id_l>id_r else e_r
            not_path = id_prop in pi
            if not_path:
                chossen_e = in_edge
            else:
                chossen_e = not_edge
            prop_used.add(int(chossen_e.attr['prop_id']))
            return remove_test(g_old,g_new,n_from_id,chossen_e[1],pi,prop_used,counters,l)
        else:
            raise RuntimeError("Invalid type")

# Load automaton facts

ctl = clingo.Control("0")
ctl.add("base",[],"")
ctl.load(in_path)
ctl.ground([("base", [])], context=Context())
with ctl.solve(yield_=True) as handle:
    for model in handle:
        atoms = model.symbols(terms=True,shown=True)
        maps = {str(a.arguments[0].number):construct_str_map(a.arguments[1]) for a in atoms if a.name=='id_map'}
        delta = {str_formula(a.arguments[0],maps):a.arguments[1] for a in atoms if a.name=='delta'}
        initials = [str_formula(a.arguments[0],maps) for a in atoms if a.name=='initial_state']
        prop_ids = [a.arguments[0].number for a in atoms if a.name=='prop_id' or a.name=='last_id']
# Create automaton
for i,initial in enumerate(initials):
    G=pgv.AGraph(ranksep='0.5',directed=True)
    G.edge_attr.update(fontsize=10,splines=True,weight=1.,arrowsize=.4)
    G.node_attr.update(fontsize=20)
    pending_nodes = [{'type':'state','val':initial,'next':[(0,"",delta[initial])],'id':0}]
    counters = {'next_id': 0}
    idx = 0
    while idx< len(pending_nodes):
        d=pending_nodes[idx]
        add_node(G,d)
        for n,l,f in d['next']:
            counters['next_id']+=1
            if (f.name=='pbf_true'):
                next_node = {'type':'bool','val':'true','next':[],'id':counters['next_id']}
            elif (f.name=='pbf_false'):
                next_node = {'type':'bool','val':'false','next':[],'id':counters['next_id']}
            elif (f.name=='pbf_or'):
                next_node = {'type':'trans','val':'OR','next':[(0,"",f.arguments[0]),(0,"",f.arguments[1])],'id':counters['next_id']}
            elif (f.name=='pbf_and'):
                next_node = {'type':'trans','val':'AND','next':[(0,"",f.arguments[0]),(0,"",f.arguments[1])],'id':counters['next_id']}
            elif (f.name=='pbf_if'):
                next_node = {'type':'test','val':'?','next':[(int(f.arguments[0].number),maps[str(f.arguments[0])],f.arguments[1]),(-1*int(f.arguments[0].number),"~"+maps[str(f.arguments[0])],f.arguments[2])],'id':counters['next_id']}
                prop_id = str(f.arguments[0])
            elif (f.name=='pbf_state'):    
                id_state = str_formula(f.arguments[0],maps)
                next_node = {'type':'state','val':id_state,'next':[(0,"",delta[id_state])],'id':counters['next_id']}
            
            connect_id = counters['next_id']
            existent= False
            if next_node['type']=='state':
                found = [p['id'] for p in pending_nodes if p['val']==next_node['val']]
                if len(found)>0:
                    connect_id = found[0]
                    existent=True

            G.add_edge(d['id'],connect_id,label=l,splines='curved',prop_id=n)
            if not existent: pending_nodes.append(next_node)
        
        idx+=1            

    # Print automaton
    name = '{}/img_a_{}.png'.format(base_path,i)


    


    edges = G.edges()
    
    G_min=pgv.AGraph(ranksep='0.5',directed=True)
    G_min.edge_attr.update(fontsize=10,splines=True,weight=1.,arrowsize=.4)
    G_min.node_attr.update(fontsize=20)
    name_min = '{}/img_a_{}_min.png'.format(base_path,i)
    state_nodes = [n for n in G.nodes() if n.attr['type']=='state']
    pis = []
    for i in range(len(prop_ids)+1):
        pis+=([list(l) for l in itertools.combinations(prop_ids, i)])
    
    max_id = 0
    for n in state_nodes:
        max_id = max_id if int(n)<max_id else int(n)
        add_node(G_min,{'id':n,'val':n.attr['label'],'type':'state'})
    

    counters = {'next_id':max_id+1}
    for n in state_nodes:
        
        n_next = G.out_neighbors(n)[0]
        for p_idx, pi in enumerate(pis):
            prop_used = set()
            node = remove_test(G,G_min,n,n_next,pi,prop_used,counters,"{{{}}}".format(",".join([maps[str(p)] for p in pi])))
            G_min.get_edge(n,node).attr['label']=prop_set_to_str(prop_used,maps)
    remove_zero_in(G_min)
    remove_duplicated_labels(G_min)
    remove_zero_in(G_min)

    G_min.draw(name_min,prog='dot')  
    G.draw(name,prog='dot')  
    print("\nAutomaton {} saved in {}".format(i,name))
    print("\nAutomaton minimized {} saved in {}".format(i,name_min))