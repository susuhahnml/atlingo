import json
import re
from graphviz import Digraph, Source
import clingo as _clingo
import itertools
import dot2tex
from pyutils.ldlf import LDLfFormula

def reduce_and(a,keep_true=True):
    if len(a)>0 and type(a[0])==list:
        return [reduce_and(e) for e in a]
    a = set(a)
    a.discard('true')
    a = list(a)
    if keep_true and len(a)==0:
        a.append('true')
    return a

class State():
    def __init__(self, s_id, label):
        self._label = label
        self._id = int(s_id)

    def __str__(self):
        return str(self._label)

class Condition():
    def __init__(self, included, not_included):
        
        self._included = reduce_and(included,False)
        self._not_included = reduce_and(not_included,False)

    @classmethod
    def from_str(cls, s, prop2id):
        s = s.strip('"')
        included = []
        not_included = []
        s = s.split(" & ") 
        for c in s:
            next_id = len(prop2id)
            if c[0]=="~":
                p_name=c[1:]
                prop2id.setdefault(p_name,next_id)
                not_included.append(prop2id[p_name])
            else:
                p_name=c
                prop2id.setdefault(p_name,next_id)
                included.append(prop2id[p_name])
        return cls(included, not_included)

    def get_props(self):
        return set(self._included+self._not_included)

    def str_names(self,names):
        elems = []
        if len(self._included)>0:
            elems.append("& ".join([names[i] for i in self._included]))
        if len(self._not_included)>0:
            elems.append("& ".join(["~ "+ names[i] for i in self._not_included]))
        
        return "& ".join(elems)

    def is_taut(self):
        return len(self._included)+len(self._not_included)==0

    def __str__(self):
        not_included = "" 
        if len(self._not_included)>0:
            not_included = "& ~".join([""]+[str(i) for i in self._not_included])
        return "& ".join([str(i) for i in self._included]) + not_included

class Automata():

    def __init__(self, props, states, transitions, initial_state_id, final_states_ids, dot = None):
        self._props = props 
        self._states = states
        self._transitions = transitions
        self._initial_state_id = initial_state_id
        self._final_states_ids = final_states_ids

    @property
    def initial_state(self):
        return self._states[self._initial_state_id]

    def tikz(self):
        pass

    def to_dic(self):
        j = {
            'props': self._props,
            'states': {i:str(s) for i, s in self._states.items()},
            'initial_state': self._initial_state_id,
            'transition': {i : {str(c) : n for c, n in v.items()} for i, v in self._transitions.items()},
            'final_states': list(self._final_states_ids),
        } 
        return j

    def dot(self, latex = False, labels =True):
        dot = 'digraph ATLINGO {\n'
        dot += 'rankdir = LR;\n'
        dot += 'center = true;\n'
        dot += 'size = "15,15";\n'
        # General def
        dot += 'edge [fontname = Courier arrowhead=vee arrowsize=0.5 penwidth= .8 lblstyle="font=\\small"];\n'
        dot += 'node [height = .5, width = .5];\n'
        # Nodes
        for i, s in self._states.items():
            label = s._label if labels else s._id
            if labels and latex:
                label = label.replace("<","\\deventually{").replace("[","\\dalways{")
                label = label.replace("&skip","\\top")
                label = label.replace(";;",";").replace("*","^*")
                label = label.replace("]","}").replace(">","}")
                label = "s_{{{}}}".format(label)
            shape= 'circle'
            if str(s._id) in self._final_states_ids:
                shape = 'doublecircle'
            dot += 'node [shape = {} label= "{}"] {};\n'.format(shape, label,s._id)
        dot += 'init [shape = plaintext, label = " "];\n'
        
        branch_format = 'shape = point width = .05 height = .05 label=" "'
        # True transition for AFW
        if isinstance(self,AFW):
            if latex:
                branch_format = 'color=white shape = circle width = .3 height = .3 label="\\forall"'
            dot += 'true [{}];\n'.format(branch_format)
        # Initial Node
        dot += 'init -> {};\n'.format(self._initial_state_id)
        # Transitions
        and_id=0
        for s_from, v in self._transitions.items():
            for c, s_tos in v.items():
                label = c.str_names(self._props)
                if latex:
                    label = label.replace("&","\\wedge")
                for s_to in s_tos:
                    if isinstance(s_to,int) or len(s_to)==1:
                        s_to_int = s_to if isinstance(s_to,int) else s_to[0]
                        dot += '{} -> {} [label="{}"];\n'.format(s_from, s_to_int, label)
                        continue
                    dot += 'and{} [{}];\n'.format(and_id,branch_format)
                    dot += '{} -> and{} [label="{}" arrowhead=none];\n'.format(s_from, and_id, label)
                    for s in s_to:
                        dot += 'and{} -> {};\n'.format(and_id, s)
                    and_id+=1

        dot += '}'
        return dot

    def to_tex(self, file="./outputs/automata.tex", labels=False):
        testgraph = self.dot(latex=True,labels=labels)
        texcode = dot2tex.dot2tex(testgraph, format='tikz', texmode='math',crop=True,margin="20pt")
        with open(file,'w') as f:
            macros = """
            \\newcommand{\\dalways}[1]{\\ensuremath{[#1]\\,}}                    
            \\newcommand{\\deventually}[1]{\\ensuremath{\\langle#1\\rangle\\,}} 
            """
            f.write(macros)
            f.write(texcode.replace("wedge","\\wedge").replace("join=bevel,","join=bevel,scale=0.4"))

    def save_png(self, file="outputs/automata_viz",labels =True):
        s = Source(self.dot(labels=labels))
        s.render(file, format="png")

    def __str__(self):
        return json.dumps(self.to_dic(),indent=4)


class NFA(Automata):

    def __init__(self, *args):
        super(NFA,self).__init__(*args)

    @classmethod
    def from_mona(cls, mona):
        if "Execution aborted" in mona:
            raise Exception("Error in mona: \n{}".format(mona))

        def get_state(states, state_name):
            s_id = int(state_name)
            if s_id not in states:
                states[s_id] = State(s_id, state_name)
            return states[s_id]

        states = {}
        transitions = {}
        vrs = re.findall(r'(?<=DFA for formula with free variables:\s).*?(?=\s\n)',mona)
        vrs = vrs[0].split(" ") if len(vrs)>0 else []
        
        f_states = re.findall(r'(?<=Accepting states:\s).*?(?=\s\n)',mona)
        final = f_states[0].split(" ") if len(f_states)>0 else []
        
        trans = re.findall(r'(?<=State\s).*?(?=\n)',mona)
        t_reg = r'(\d+):\s([X01]*)\s\->\sstate\s(.+)'
        for t in trans[1:]:
            res = re.match(t_reg,t).groups()
            n_from = get_state(states, res[0])
            n_to = get_state(states, res[2])
            in_prop = [i for i,v in enumerate(res[1]) if v=='1']
            out_prop = [i for i,v in enumerate(res[1]) if v=='0']
            c = Condition(in_prop,out_prop)
            transitions.setdefault(n_from._id,{})[c]=[n_to._id]

        def str2pred(k):
            return k.replace("_1_","(").replace("_2_",")").replace("_3_",",").lower()
        id2prop = {v:str2pred(k) for v,k in enumerate(vrs)}
        id2prop[len(id2prop)]="last"
        # (id2prop)
        return cls(id2prop,states,transitions,1,set(final),"")

    def to_lp(self, state_prefix = ""):
        def tos(s_id):
            return state_prefix+str(s_id) 
        p = ""
        for i, prop in self._props.items():
            p+=('prop({},"{}").\n').format(i,prop)
        # p+=('prop({},"last").\n').format(len(self._props))

        for i, s in self._states.items():
            p+=('state({},"{}").\n').format(tos(s._id),s._label)
        p+=('initial_state({}).\n').format(tos(self._initial_state_id))
        
        for s_from, v in self._transitions.items():
            c_id = 0
            for c, s_tos in v.items():
                for s_to in s_tos:
                    for prop_in in c._included:
                        p+=('delta({},({},in,{}),{}).\n').format(tos(s_from),c_id,prop_in,tos(s_to))
                    for prop_in in c._not_included:
                        p+=('delta({},({},out,{}),{}).\n').format(tos(s_from),c_id,prop_in,tos(s_to))
                    if c.is_taut():
                        p+=('delta({},({},in,true),{}).\n').format(tos(s_from),c_id,tos(s_to))
                    c_id=c_id+1
        for s in self._final_states_ids:
            p+=('final_state({}).\n').format(tos(s))
    
        p+=('%------- Definition of trace --------.\n')
        for i, prop in self._props.items():
            if prop == "true":
                continue
            if prop[-1]==")":
                p_with_t = prop[:-1]+",T)"
            else:
                p_with_t = prop+"(T)"
            p+=('in_trace_at({},T):- {}.\n').format(i,p_with_t)

        return p


class AFW(Automata):

    def __init__(self, *args):
        super(AFW,self).__init__(*args)

    @classmethod
    def from_lp(cls, files=[], inline_data=""):
        ctl = _clingo.Control([], message_limit=0)
        ctl.add("base", [], "")
        for f in files:
            ctl.load(f)
        ctl.add("base", [], inline_data)
        ctl.ground([("base", [])])
        states = {}
        trans = {}
        initial_state = None
        id2prop = {}
        cases = {}
        for sa in ctl.symbolic_atoms:
            s = sa.symbol
            i = s.arguments[0].number
            if s.name == 'initial_state':
                initial_state = s.arguments[0].number
            elif s.name == 'prop':
                id2prop[i] = str(s.arguments[1]).strip('\\"')
            elif s.name == 'state':
                formula = LDLfFormula.from_symbol(s.arguments[1],id2prop)
                states[i] = State(i,str(formula))
            elif s.name == 'delta':
                # print(s)
                n_to = "true"  if s.arguments[2].number is None  else s.arguments[2].number
                case = str(s.arguments[1].arguments[0])
                cases.setdefault(i,{}).setdefault(case,([],[]))
                pos = 0 if s.arguments[1].arguments[1].name == "in" else 1
                # print("from lp")
                # print(s.arguments[1].arguments[2])
                # print(s.arguments[1].arguments[2].number)
                prop = s.arguments[1].arguments[2].number if s.arguments[1].arguments[2].number else "true"
                cases[i][case][pos].append(prop)
                trans.setdefault(i,{}).setdefault(case,[]).append(n_to)
                # print(trans)

        cases_classes = {}
        for s_from, dic_c in cases.items():
            cases_classes[s_from] = {}
            for c_id, tup in dic_c.items():
                # print("here")
                cases_classes[s_from][c_id]=Condition(tup[0],tup[1])

        transitions = {}
        # print(trans)
        for s_from, dic_c in trans.items():
            transitions[s_from]={}
            for c_id,s2 in dic_c.items():
                con = cases_classes[s_from][c_id]
                transitions[s_from].setdefault(con,[]).append(reduce_and(s2,True))


        return cls(id2prop,states,transitions,initial_state,set(),"")
    

    def to_nfa(self):
        id2state = {}
        tuple2state = {}
        new_states = set([])
        
        def get_state(l):
            l = reduce_and(l,False)
            l.sort()
            t = tuple(l)
            if not t in tuple2state:
                s =  State(len(tuple2state),t)
                new_states.add(s)
                tuple2state[t]=s
            return tuple2state[t]

        final = get_state([])._id
        initial_state = get_state([self._initial_state_id])
        transitions = {}
        while not len(new_states)==0:

            s=new_states.pop()

            options_per_state = [[] for i in s._label]
            for i, s_afw in enumerate(s._label):
                if s_afw == "true" or not s_afw in self._transitions:
                    continue
                options_per_state[i]=[]
                for c,s_nexts in  self._transitions[s_afw].items():
                    for s_next in s_nexts:
                        options_per_state[i].append((c,s_next))
            combinations = list(itertools.product(*options_per_state))
            
            for comb_t in combinations:
                in_p = []
                out_p = []
                next_l = []
                for c, s_next in comb_t:
                    in_p=in_p+c._included
                    out_p=out_p+c._not_included
                    next_l = next_l + s_next

                contradict = any(p in out_p for p in in_p)
                if contradict:
                    continue
                s_to = get_state(next_l)
                case = Condition(in_p,out_p)
                transitions.setdefault(s._id,{}).setdefault(case,[]).append(s_to._id)

        for i, state in tuple2state.items():
            state._label = "{{ {} }}".format(", ".join([str(x) for x in state._label]))

        id2state = {s._id:s for s in tuple2state.values()}
        return NFA({i:p for i,p in self._props.items()},id2state,transitions,initial_state._id,set([final]),"")

