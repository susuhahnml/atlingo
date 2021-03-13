import json
class State():
    def __init__(self, n_id, label):
        self._label = label
        self._id = n_id

    def __str__(self):
        return self._label

class Condition():
    def __init__(self, included, not_included):
        self._incuded = included
        self._not_included = not_included

    def __str__(self):
        not_included = "" 
        if len(self._not_included)>0:
            not_included = " ~".join([""]+self._not_included)
        return " ".join(self._incuded) + not_included

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

    def __init__(self, props, states, transitions, inital_state_id, final_states_ids):
        self._props = props 
        self._states = states
        self._transitions = transitions
        self._inital_state_id = inital_state_id
        self._final_states_ids = final_states_ids

    def to_tikz(self):
        pass

    def to_dot(self):
        pass

    def to_dic(self):
        j = {
            'states': {i:str(s) for i, s in self._states.items()},
            'initial_state': self._inital_state_id,
            'transition': {i:(str(c),str(n)) for i, (c,n) in self._transitions.items()},
            'final_states': self._final_states_ids,
        } 
        return j

    def save_png(self):
        #         #     import networkx as nx
#         # import pygraphviz as pgv 
        pass
    
    def __str__(self):
        j = json.loads(self.to_dic())
        return (json.dumps(j))
        
class NFA(Automata):

    def __init__(self, **args):
        Automata(**args)

    @classmethod
    def from_mona(cls, mona):
        pass
        # use dotpy
        # Parse Diagram to create structure

    def to_lp(self):
        pass
#         # Parse the Diagram to get clingo facts


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
            
#             Cuantificar existencial variables.
#             # 4(ltl2dfa). LDL_PY (Thoery(API) or predicates) -> DFA_MONA (ldl2dfa) -> NFA_PY (pydot) -> NFA_LP + NFA_CLINGO
