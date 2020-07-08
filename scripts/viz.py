#!/usr/bin/python

import sys
import networkx as nx
import pygraphviz as pgv        
import clingo
class Context:
    def id(self, x):
        return x
    def seq(self, x, y):
        return [x, y]



type_formula = sys.argv[1]
in_file = sys.argv[2]

print("Computing visualization for {} automaton in {}...".format(type_formula,in_file))





def construct_str_map(symbol):
    if str(symbol.type) == "Number":
        return str(symbol.number)
    if str(symbol.type) == "String":
        return str(symbol.string)
    args = symbol.arguments
    name=str(symbol.arguments[0]).replace('"','')
    start = 1
    if name == "":
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
    elif name == "check":
        s = "({})?".format(str_formula(args[0],maps))
    elif name == "star":
        s = "({})*".format(str_formula(args[0],maps))
    elif name == "choice":
        s = " {} + {} ".format(str_formula(args[0],maps),str_formula(args[1],maps))
    elif name == "sequence":
        s = " {} ; {} ".format(str_formula(args[0],maps),str_formula(args[1],maps))
    return s


# Load automaton facts

ctl = clingo.Control("0")
ctl.add("base",[],"")
ctl.load("./output_automata_facts/{}/{}.lp".format(type_formula,in_file))
ctl.ground([("base", [])], context=Context())
with ctl.solve(yield_=True) as handle:
    for model in handle:
        atoms = model.symbols(terms=True,shown=True)
        maps = {str(a.arguments[0].number):construct_str_map(a.arguments[1]) for a in atoms if a.name=='id_map'}
        delta = {str_formula(a.arguments[0],maps):a.arguments[1] for a in atoms if a.name=='delta'}
        initial = [str_formula(a.arguments[0],maps) for a in atoms if a.name=='initial_state'][0]


# Create automaton

G=pgv.AGraph(ranksep='0.5',directed=True)
pending_nodes = [{'type':'state','val':initial,'next':[("",delta[initial])],'id':0}]
next_id = 0
idx = 0
while idx< len(pending_nodes):
    d=pending_nodes[idx]
    if d['type']=='state':    
        shape = 'ellipse'
    if d['type']=='trans':    
        shape = 'square'
    if d['type']=='check':    
        shape = 'triangle'
    if d['type']=='bool':    
        shape = 'plain'
    
    
    if d['val']=='true':
        G.add_node(d['id'],shape=shape,label=d['val'],fontcolor='#7BAA16')
    elif d['val']=='false':
        G.add_node(d['id'],shape=shape,label=d['val'],fontcolor='#AA1616')
    elif d['type']=='state':
        G.add_node(d['id'],shape=shape,label=d['val'],fillcolor='#00305E20',style='filled')
    else:
        G.add_node(d['id'],shape=shape,label=d['val'])

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
        elif (f.name=='pbf_decide'):
            next_node = {'type':'check','val':'?','next':[(maps[str(f.arguments[0])],f.arguments[1]),("~"+maps[str(f.arguments[0])],f.arguments[2])],'id':next_id}
        elif (f.name=='pbf_id'):    
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

G.draw('./output_viz/{}/{}.png'.format(type_formula,in_file),prog='dot')  