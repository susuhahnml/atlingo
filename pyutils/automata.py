import json
import re
from dotpy.parser.parser import MyParser
from graphviz import Digraph, Source

class State():
    def __init__(self, s_id, label):
        self._label = label
        self._id = int(s_id)

    def __str__(self):
        return self._label

class Condition():
    def __init__(self, included, not_included):
        self._included = included
        self._not_included = not_included

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
        not_included = "" 
        if len(self._not_included)>0:
            not_included = " ~".join([""]+[names[i] for i in self._not_included])
        return " ".join([names[i] for i in self._included]) + not_included

    def is_taut(self):
        return len(self._included)+len(self._not_included)==0

    def __str__(self):
        not_included = "" 
        if len(self._not_included)>0:
            not_included = " ~".join([""]+[str(i) for i in self._not_included])
        return " ".join([str(i) for i in self._included]) + not_included

class PBF():
    def __init__(self, states={}, is_true=False, is_false=False):
        self._states=states
        self._is_true=is_true
        self._is_false=is_false

    def __str__(self):
        if self._is_true:
            return "⊤"
        elif self._is_false:
            return "⊥"        
        return ", ".join(self._states)

class Automata():

    def __init__(self, props, states, transitions, initial_state_id, final_states_ids, dot = None):
        self._props = props 
        self._states = states
        self._transitions = transitions
        self._initial_state_id = initial_state_id
        self._final_states_ids = final_states_ids

    def tikz(self):
        pass

    def to_dic(self):
        j = {
            'props': self._props,
            'states': {i:str(s) for i, s in self._states.items()},
            'initial_state': self._initial_state_id,
            'transition': {i : {str(c) : str(n) for c, n in v.items()} for i, v in self._transitions.items()},
            'final_states': list(self._final_states_ids),
        } 
        return j

    def save_png(self, file_name="outputs/automata_viz"):
        s = Source(self.dot, filename=file_name, format="png")
        s.view()

    @property
    def dot(self):
        dot = 'digraph ATLINGO {\n'
        dot += 'rankdir = LR;\n'
        dot += 'center = true;\n'
        dot += 'size = "7.5,10.5";\n'
        
        dot += 'edge [fontname = Courier];\n'
        dot += 'node [height = .5, width = .5];\n'
        for f in self._final_states_ids:
            dot += 'node [shape = doublecircle]; {};\n'.format(f)
        dot += 'node [shape = circle]; 1;\n'
        dot += 'init [shape = plaintext, label = ""];\n'
        dot += 'init -> 1;\n'
        for s_from, v in self._transitions.items():
            for c, s_to in v.items():
                dot += '{} -> {} [label="{}"];\n'.format(s_from, s_to, c.str_names(self._props))
        dot += '}'

        return dot

    def __str__(self):
        return json.dumps(self.to_dic(),indent=4)

def get_state(states, state_name):
    s_id = int(state_name)
    if s_id not in states:
        states[s_id] = State(s_id, state_name)
    return states[s_id]

class NFA(Automata):

    def __init__(self, *args):
        super(NFA,self).__init__(*args)

    @classmethod
    def from_mona(cls, mona):
        states = {}
        transitions = {}
        vrs = re.findall(r'(?<=DFA for formula with free variables:\s).*?(?=\s\n)',mona)
        vrs = vrs[0].split(" ") if len(vrs)>0 else []
        
        f_states = re.findall(r'(?<=Accepting states:\s).*?(?=\s\n)',mona)
        final = f_states[0].split(" ") if len(f_states)>0 else []
        
        trans = re.findall(r'(?<=State\s).*?(?=\n)',mona)
        t_reg = r'(\d+):\s([X01]+)\s\->\sstate\s(.+)'
        for t in trans[1:]:
            res = re.match(t_reg,t).groups()
            n_from = get_state(states, res[0])
            n_to = get_state(states, res[2])
            in_prop = [i for i,v in enumerate(res[1]) if v=='1']
            out_prop = [i for i,v in enumerate(res[1]) if v=='0']
            c = Condition(in_prop,out_prop)
            transitions.setdefault(n_from._id,{})[c]=n_to._id

        def str2pred(k):
            return k.replace("_1_","(").replace("_2_",")").replace("_3_",",").lower()
        id2prop = {v:str2pred(k) for v,k in enumerate(vrs)}

        return cls(id2prop,states,transitions,1,set(final),"")

    def to_lp(self, state_prefix = ""):
        def tos(s_id):
            return state_prefix+str(s_id) 
        p = ""
        for i, prop in self._props.items():
            p+=('prop({},"{}").\n').format(i,prop)
        p+=('prop({},"last").\n').format(len(self._props))

        for i, s in self._states.items():
            p+=('state({},"{}").\n').format(tos(s._id),s._label)
        p+=('initial_state({}).\n').format(tos(self._initial_state_id))
        
        for s_from, v in self._transitions.items():
            c_id = 0
            for c, s_to in v.items():
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

    def __init__(self, **args):
        Automata(**args)

    @classmethod
    def from_lp(cls, lp):
        pass

    def to_nfa(self):
        # With pseudo code
        pass


# Final options
# LDL_LP ->
#             1(atlingo). AFW_LP + AFW_CLINGO                                              
#             2(telingo). LTL_TELINGO -> LP  (PROP & TELINGO TSEITEN) + CLINGO
#             3(afw2nfa). AFW_LP -> AFW_PY -> NFA_PY (Vardi Pseudo) -> NFA_LP + NFA_CLINGO                 
#             4(ltl2dfa). LDL_PY (Thoery(API)) -> LTL_EBNF -> LTL_PY (ltl2dfa) -> DFA_MONA (LTL2DFA & MONA) -> NFA_PY (pydot) -> NFA_LP + NFA_CLINGO
            
#             Cuantificar existential variables.
#             # 4(ltl2dfa). LDL_PY (Thoery(API) or predicates) -> DFA_MONA (ldl2dfa) -> NFA_PY (pydot) -> NFA_LP + NFA_CLINGO
