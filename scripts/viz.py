#!/usr/bin/python
# -*- coding: utf-8 -*- 
import copy
import os
import sys
import networkx as nx
import pygraphviz as pgv        
import clingo
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


# Create automaton
for i,initial in enumerate(initials):
    G=pgv.AGraph(ranksep='0.5',directed=True)
    pending_nodes = [{'type':'state','val':initial,'next':[("",delta[initial])],'id':0}]
    next_id = 0
    idx = 0
    while idx< len(pending_nodes):
        d=pending_nodes[idx]
        
        #Define shape
        if d['type']=='state':    
            shape = 'ellipse'
        if d['type']=='trans':    
            shape = 'square'
        if d['type']=='test':    
            shape = 'triangle'
        if d['type']=='bool':    
            shape = 'plain'
        # next_str = "*".join(["*".join([a[0],str(a[1].arguments[0])]) for a in d['next']])
        #Define color
        if d['val']=='true':
            G.add_node(d['id'],shape=shape,label=d['val'],fontcolor='#7BAA16',type=d['type'])
        elif d['val']=='false':
            G.add_node(d['id'],shape=shape,label=d['val'],fontcolor='#AA1616',type=d['type'])
        elif d['type']=='state':
            G.add_node(d['id'],shape=shape,label=d['val'],fillcolor='#00305E20',style='filled',type=d['type'])
        else:
            G.add_node(d['id'],shape=shape,label=d['val'],type=d['type'])



        for l,f in d['next']:
            next_id+=1
            if (f.name=='pbf_true'):
                next_node = {'type':'bool','val':'true','next':[],'id':next_id}
            elif (f.name=='pbf_false'):
                next_node = {'type':'bool','val':'false','next':[],'id':next_id}
            elif (f.name=='pbf_or'):
                next_node = {'type':'trans','val':'OR','next':[("",f.arguments[0]),("",f.arguments[1])],'id':next_id}
            elif (f.name=='pbf_and'):
                next_node = {'type':'trans','val':'AND','next':[("",f.arguments[0]),("",f.arguments[1])],'id':next_id}
            elif (f.name=='pbf_if'):
                next_node = {'type':'test','val':'?','next':[(maps[str(f.arguments[0])],f.arguments[1]),("~"+maps[str(f.arguments[0])],f.arguments[2])],'id':next_id}
            elif (f.name=='pbf_state'):    
                id_state = str_formula(f.arguments[0],maps)
                next_node = {'type':'state','val':id_state,'next':[("",delta[id_state])],'id':next_id}
            
            connect_id = next_id
            existent= False
            if next_node['type']=='state':
                found = [p['id'] for p in pending_nodes if p['val']==next_node['val']]
                if len(found)>0:
                    connect_id = found[0]
                    existent=True

            G.add_edge(d['id'],connect_id,label=l)
            if not existent: pending_nodes.append(next_node)
        idx+=1            

    # Print automaton
    name = '{}/img_a_{}.png'.format(base_path,i)
    # ['ghandle', 'attr', 'handle', 'encoding', '__module__', '__doc__', '__new__', 'get_handle', 'get_name', 'name', '__dict__', '__weakref__', '__repr__', '__hash__', '__str__', '__getattribute__', '__lt__', '__le__', '__eq__', '__ne__', '__gt__', '__ge__', '__iter__', '__mod__', '__rmod__', '__len__', '__getitem__', '__add__', '__mul__', '__rmul__', '__contains__', 'encode', 'replace', 'split', 'rsplit', 'join', 'capitalize', 'casefold', 'title', 'center', 'count', 'expandtabs', 'find', 'partition', 'index', 'ljust', 'lower', 'lstrip', 'rfind', 'rindex', 'rjust', 'rstrip', 'rpartition', 'splitlines', 'strip', 'swapcase', 'translate', 'upper', 'startswith', 'endswith', 'isascii', 'islower', 'isupper', 'istitle', 'isspace', 'isdecimal', 'isdigit', 'isnumeric', 'isalpha', 'isalnum', 'isidentifier', 'isprintable', 'zfill', 'format', 'format_map', '__format__', 'maketrans', '__sizeof__', '__getnewargs__', '__setattr__', '__delattr__', '__init__', '__reduce_ex__', '__reduce__', '__subclasshook__', '__init_subclass__', '__dir__', '__class__']
    edges = G.edges()
    
    G_min=pgv.AGraph(ranksep='0.5',directed=True)
    name_min = '{}/img_a_{}_min.png'.format(base_path,i)
    state_nodes = [n for n in G.nodes() if n.attr['type']=='state']
    for n in state_nodes:
        G_min.add_node(n,shape='ellipse',label=n.attr['label'],fillcolor='#00305E20',style='filled',type='state',val=n.attr['label'])
    for n in state_nodes:
        print("\n\nNode!!!!!")
        # labels, next{type:((state, bool, and), value:}
        
        next_node_id = G.out_neighbors(n)[0]
        next_node = G.get_node(next_node_id)
        initial_edge = {'labels':[],'next':{'type':None,'val':None}}
        # initial_edge['from']=n
        all_edges = [initial_edge]
        first_pending = {
            "edge": initial_edge,
            "next": initial_edge['next'],
            "next_node_id": next_node_id
        }
        pending = [first_pending]
        idx = 0
        while idx< len(pending):
            print("---- Pending ---- ")
            p=pending[idx]
            print(p)

            idx=idx+1
            next_node = G.get_node(p['next_node_id'])
            print("type:" + next_node.attr['type'])
            print("label:" + next_node.attr['label'])
            print("")
            out_edges=G.out_edges(next_node)
            out_neighbors=G.out_neighbors(next_node)
            if(next_node.attr['type']=='bool'):
                p['next']['type']='bool'
                p['next']['val']=next_node.attr['label']
            elif(next_node.attr['type']=='state'):
                p['next']['type']='state'
                p['next']['val']=next_node.attr['label']
            elif(next_node.attr['type']=='trans'):
                if(next_node.attr['label']=='OR'):
                    left = {"edge":copy.deepcopy(p['edge']),"next":p["next"]}
                    left['next_node_id']= out_neighbors[0]
                    all_edges.append(left['edge'])
                    pending.append(left)

                    right = {"edge":p['edge'],"next":p["next"]}
                    right['next_node_id']= out_neighbors[1]
                    pending.append(right)
                else:
                    p['next']['type']='and'
                    left_next = {'type':None,'val':None}
                    left_next_node = G.get_node(out_neighbors[0])
                    pending.append({'edge':p['edge'],'next':left_next,'next_node_id':out_neighbors[0]})

                    right_next = {'type':None,'val':None}
                    right_next_node = G.get_node(out_neighbors[1])
                    pending.append({'edge':p['edge'],'next':right_next,'next_node_id':out_neighbors[1]})

                    p['next']['val']=(left_next,right_next)

            elif(next_node.attr['type']=='test'):
                left = {"edge":copy.deepcopy(p['edge']),"next":p["next"]}
                left['next_node_id']= out_neighbors[0]
                all_edges.append(left['edge'])
                left['edge']['labels'].append(out_edges[0].attr['label'])
                pending.append(left)

                right = {"edge":p['edge'],"next":p["next"]}
                right['next_node_id']= out_neighbors[1]
                right['edge']['labels'].append(out_edges[1].attr['label'])
                pending.append(right)

            else:
                raise RuntimeError("Invalid type "+next_node.attr['type'])
            
            print("Pending visited")
            for e in pending[:idx]:
                print(e)
            print("Still pending:")
            for e in pending[idx:]:
                print(e)
            print("")

            print("all edges:")
            for e in all_edges:
                print(e)
            print("")
        for e in all_edges:
            print(e)
            # G.add_edge(n,connect_id,label=" ".(e.labels))
 
        # print(n.__dir__())
    # print(G.string())
    G_min.draw(name_min,prog='dot')  
    G.draw(name,prog='dot')  
    print("Automaton {} saved in {}".format(i,name))