import clingo as _clingo
import sys
from ltlf2dfa.parser.ltlf import  LTLfParser
from ltlf2dfa.ltlf import (
    LTLfAtomic,
    LTLfAnd,
    LTLfEquivalence,
    LTLfOr,
    LTLfNot,
    LTLfImplies,
    LTLfEventually,
    LTLfAlways,
    LTLfUntil,
    LTLfRelease,
    LTLfNext,
    LTLfWeakNext,
    LTLfTrue,
    LTLfFalse,
)

del_operators = {".>*":'Box', ".>?":'Diamond',"&": "Boolean","~": "Prop"}
path_unary_operators  = {"*":'KleeneStar', "?":'Check', "&": "Skip"}
path_binary_operators = {";;":'Sequence', "+":'Choice'}
path_operators = dict(path_unary_operators)
path_operators.update(path_binary_operators)

# Used in lp encodings
del_operators_names = {"box":'Box', "diamond":'Diamond',"top": "Boolean","bottom": "Boolean","neg": "Prop"}
path_unary_operators_names  = {"star":'KleeneStar', "test":'Check', "top": "Skip"}
path_binary_operators_names = {"sequence":'Sequence', "choice":'Choice'}
path_operators_names = dict(path_unary_operators_names)
path_operators_names.update(path_binary_operators_names)



def set_next_aux(rep, rep2aux):
    aux_name = "aux_{}".format(len(rep2aux))
    aux_atom = LTLfAtomic(aux_name)
    rep2aux[rep]=aux_atom
    return aux_atom
# ---------------------- Formulas

class LDLfFormula():
    def __init__(self, rep):
        """
        Initializes a formula with the given string representation.
        """
        self.__rep  = rep

    @classmethod
    def from_theory(cls, term):
        if (term.type ==  _clingo.TheoryTermType.Symbol):
            return LDLfProp.from_theory(term)
        elif (term.type ==  _clingo.TheoryTermType.Function):
            if term.name in del_operators:
                class_name = "LDLf" + del_operators[term.name]
            else:
                class_name = "LDLfProp"
            return getattr(sys.modules[__name__], class_name).from_theory(term)
        else:
            raise RuntimeError("Invalid term {}".format(term))
    
    @classmethod
    def from_symbol(cls, symbol, id2prop):
        if symbol.name in del_operators_names:
            class_name = "LDLf" + del_operators_names[symbol.name]
        else:
            class_name = "LDLfProp"
        return getattr(sys.modules[__name__], class_name).from_symbol(symbol,id2prop)
        

    @classmethod
    def from_lp(cls, files=[], inline_data=""):
        ctl = _clingo.Control([], message_limit=0)
        ctl.add("base", [], "")
        for f in files:
            ctl.load(f)
        ctl.load("./formula_to_automaton/del/theory.lp")
        ctl.add("base", [], inline_data)
        ctl.ground([("base", [])])
        formulas = []
        for t in ctl.theory_atoms:
            formula = LDLfFormula.from_theory(t.elements[0].terms[0])
            formulas.append(formula)
        return formulas

    @classmethod
    def to_mona(cls, formula):

        vars_prop = set()
        all_vars = set()
        
        mona_p_string = "\nm2l-str;\n"
        
        mona_formula = formula.to_mona(0,vars_prop,all_vars)
        if len(vars_prop)>0:
            mona_p_string += "var2 {};\n".format(", ".join(vars_prop))
        
        mona_p_string += "{};\n".format(mona_formula)
        return mona_p_string

    @classmethod
    def to_mona_vardi(cls, formula):

        vars_prop = set()
        all_vars = set()
        
        mona_p_string = "\nm2l-str;\n"
        
        mona_formula = formula.to_mona_vardi(0,vars_prop,all_vars)
        if len(vars_prop)>0:
            mona_p_string += "var2 {};\n".format(", ".join(vars_prop))
        
        mona_p_string += "{};\n".format(mona_formula)
        return mona_p_string

    @property
    def _rep(self):
        """
        Return the unique string representaiton of the formula.
        """
        return self.__rep

    def __str__(self):
        return self.__rep

class LDLfBoolean(LDLfFormula):
    """
    Formula capturing a Boolean constant.

    Members:
    __value -- Truth value of the formula.
    """

    def __init__(self, value):
        """
        Initializes the formula with the given value.

        Members:
        __value -- Boolean value of the formula.
        """
        LDLfFormula.__init__(self, " &true " if value else " &false ")
        self.__value = value

    @classmethod
    def from_theory(cls, term):
        arg = term.arguments[0]
        assert(arg.type == _clingo.TheoryTermType.Symbol)
        return cls(arg.name == "true")

    @classmethod
    def from_symbol(cls, symbol, id2prop):
        return cls(symbol.name == "top")

    def to_ltlf(self, eqs, rep2t):
        if self.__value:
            return LTLfTrue()
        else:
            return LTLfFalse()

    def to_mona(self, v_start, all_prop_vars, all_vars):
        return 'true ' if self.__value else 'false '

    def to_mona_vardi(self, v_start, all_prop_vars, all_vars):
        return 'true ' if self.__value else 'false '
        
class LDLfProp(LDLfFormula):
    """
    Formula capturing a proposition, including negation.

    Members:
    positive -- True if it is negated.
    """

    def __init__(self, name, arguments, positive):
        """
        Initializes the formula with the given negated.

        Members:
        positive -- Boolean negated of the formula.
        """
        self._name = name
        args = "" if len(arguments)==0 else "({})".format(",".join([str(a) for a in arguments]))
        self._arguments = args
        rep = "{}{}{}".format("" if positive else "~",
                                  name, args)

        LDLfFormula.__init__(self, rep)
        self.positive = positive

    @classmethod
    def from_theory(cls, term):
        positive = True
        if term.type == _clingo.TheoryTermType.Function and term.name=="~":
            positive == False
            term = term.arguments[0]
        arguments = [] if term.type == _clingo.TheoryTermType.Symbol else term.arguments
        return cls(term.name, arguments, positive)

    @classmethod
    def from_symbol(cls, symbol, id2prop):
        positive = True
        if symbol.name=="neg":
            positive == False
            symbol = symbol.arguments[0]
        prop_id = symbol.arguments[0].number
        return cls(id2prop[prop_id], [], positive)

    @property
    def mona_rep(self):
        s = self._rep.replace("(","_1_").replace(")","_2_").replace(",","_3_")
        return s

    def to_ltlf(self, eqs, rep2t):
        return LTLfAtomic(self.mona_rep)

    def to_mona(self, v_start, all_prop_vars, all_vars):
        all_prop_vars.add(self.mona_rep.upper())
        return "({} in {}) ".format(v_start, self.mona_rep.upper())

    def to_mona_vardi(self, v_start, all_prop_vars, all_vars):
        if self._rep[0]!="Q":
            all_prop_vars.add(self.mona_rep.upper())
        return "({} in {}) ".format(v_start, self.mona_rep.upper())

class LDLfMainOperator(LDLfFormula):
    """
    Members:
    _op   -- The id of the operator.
    _path -- The left-hand-side of the temporal operator.
    _rhs  -- The right-hand-side of the temporal operator.
    """

    def __init__(self, op, path, rhs):
        """
        Initializes the formula.

        Arguments:
        op -- The id of the operator.
        lhs -- The left-hand-side of the operator.
        rhs -- The right-hand-side of the operator.
        """
        self._op = op
        self._path = path
        self._rhs = rhs
        rep = "{}{}{}{}".format(op[0], path._rep, op[1], rhs._rep)
        LDLfFormula.__init__(self, rep)

    @classmethod
    def from_theory(cls, term):
        path = Path.from_theory(term.arguments[0])
        rhs = LDLfFormula.from_theory(term.arguments[1])
        return cls(path, rhs)

    @classmethod
    def from_symbol(cls, symbol, id2prop):
        path = Path.from_symbol(symbol.arguments[0], id2prop)
        rhs = LDLfFormula.from_symbol(symbol.arguments[1], id2prop)
        return cls(path, rhs)

class LDLfDiamond(LDLfMainOperator):
    """
    Members:
    _op   -- The id of the operator.
    _path -- The left-hand-side of the temporal operator.
    _rhs  -- The right-hand-side of the temporal operator.
    """

    def __init__(self, path, rhs):
        """
        Initializes the formula.

        Arguments:
        rep -- String representation of the formula.
        path -- The left-hand-side of the operator.
        rhs -- The right-hand-side of the operator.
        """
        LDLfMainOperator.__init__(self, "<>", path, rhs)
    
    def to_ltlf(self, eqs, rep2t):
        if self._rep in rep2t:
            return rep2t[self._rep]
        c = self._path.__class__
        if c == SkipPath:
            rhs_ltl = self._rhs.to_ltlf(eqs,rep2t)
            # l = set_next_aux(self._rep,rep2t)
            # eqs.append((l,LTLfNext(rhs_ltl)))
            # return l
            return LTLfNext(rhs_ltl)

        elif c == CheckPath:
            rhs_ltl = self._rhs.to_ltlf(eqs,rep2t)
            lhs_ltl = self._path._arg.to_ltlf( eqs,rep2t)
            l = set_next_aux(self._rep,rep2t)
            eqs.append((l,LTLfAnd([lhs_ltl,rhs_ltl])))
            return l
        elif c == ChoicePath:
            lhs_ltl = LDLfDiamond(self._path._lhs,self._rhs).to_ltlf(eqs,rep2t)
            rhs_ltl = LDLfDiamond(self._path._rhs,self._rhs).to_ltlf(eqs,rep2t)
            l = set_next_aux(self._rep,rep2t)
            eqs.append((l,LTLfOr([lhs_ltl,rhs_ltl])))
            return l
        elif c == SequencePath:
            eq_ldl = LDLfDiamond(self._path._lhs,LDLfDiamond(self._path._rhs,self._rhs))
            eq_ltl = eq_ldl.to_ltlf(eqs,rep2t)
            rhs_ltl = LDLfDiamond(self._path._rhs,self._rhs).to_ltlf(eqs,rep2t)
            return eq_ltl
        elif c == KleeneStarPath:
            rhs_ltl = self._rhs.to_ltlf(eqs,rep2t)
            if self._path._arg.__class__==CheckPath:
                l=rhs_ltl
            else:
                l = set_next_aux(self._rep,rep2t)
                step_ldl = LDLfDiamond(self._path._arg,self)
                step_ltl = step_ldl.to_ltlf(eqs,rep2t)
                eqs.append((l,LTLfOr([rhs_ltl,step_ltl])))
            return l

    def to_mona(self, v_start, all_prop_vars, all_vars):
        new_var = 'v_{}'.format(len(all_vars))
        all_vars.add(new_var)
        st_p = self._path.to_mona(v_start,new_var,all_prop_vars, all_vars)
        st_m = self._rhs.to_mona(new_var,all_prop_vars, all_vars)
        return "(ex1 {}: ( {}& {})) ".format(new_var,st_p,st_m)
    
    def to_mona_vardi(self, v_start, all_prop_vars, all_vars):
        
        c = self._path.__class__
        if c == SkipPath:
            new_var = 'v_{}'.format(len(all_vars))
            all_vars.add(new_var)
            st_m = self._rhs.to_mona_vardi(new_var,all_prop_vars, all_vars)
            return "(ex1 {}: ( {}={}+1 & {})) ".format(new_var,new_var,v_start,st_m)

        elif c == CheckPath:
            st_p = self._path._arg.to_mona_vardi(v_start,all_prop_vars, all_vars)
            st_rhs = self._rhs.to_mona_vardi(v_start,all_prop_vars, all_vars)
            return "({}& {}) ".format(st_p, st_rhs)

        elif c == ChoicePath:
            st_lhs = LDLfDiamond(self._path._lhs,self._rhs).to_mona_vardi(v_start,all_prop_vars, all_vars)
            st_rhs = LDLfDiamond(self._path._rhs,self._rhs).to_mona_vardi(v_start,all_prop_vars, all_vars)
            return "({}| {}) ".format(st_lhs, st_rhs)

        elif c == SequencePath:
            eq_ldl = LDLfDiamond(self._path._lhs,LDLfDiamond(self._path._rhs,self._rhs))
            return eq_ldl.to_mona_vardi(v_start,all_prop_vars, all_vars)

        elif c == KleeneStarPath:
            if self._path._arg.__class__==CheckPath:
                return self._rhs.to_mona_vardi(v_start,all_prop_vars,all_vars)
            new_2var = 'Q_{}'.format(len(all_vars))
            all_vars.add(new_2var)
            q_prop_q = LDLfProp(new_2var,[],True)
            new_var = 'v_{}'.format(len(all_vars))
            all_vars.add(new_var)
            st_q = q_prop_q.to_mona_vardi(v_start,all_prop_vars,all_vars)
            st_qv = q_prop_q.to_mona_vardi(new_var,all_prop_vars,all_vars)
            st_rhs_v = self._rhs.to_mona_vardi(new_var,all_prop_vars,all_vars)
            st_induc_v = LDLfDiamond(self._path._arg,q_prop_q).to_mona_vardi(new_var,all_prop_vars,all_vars)
            
            
            return "ex2 {}: ({}& all1 {}: ({}<=> ({}| {})))".format(new_2var,st_q,new_var,st_qv,st_rhs_v,st_induc_v)

class LDLfBox(LDLfMainOperator):
    """
    Members:
    _op   -- The id of the operator.
    _path -- The left-hand-side of the temporal operator.
    _rhs  -- The right-hand-side of the temporal operator.
    """

    def __init__(self, path, rhs):
        """
        Initializes the formula.

        Arguments:
        rep -- String representation of the formula.
        path -- The left-hand-side of the operator.
        rhs -- The right-hand-side of the operator.
        """
        LDLfMainOperator.__init__(self, "[]", path, rhs)

    def to_ltlf(self, eqs, rep2t):
        if self._rep in rep2t:
            return rep2t[self._rep]
        c = self._path.__class__
        if c == SkipPath:
            rhs_ltl = self._rhs.to_ltlf(eqs,rep2t)
            # l = set_next_aux(self._rep,rep2t)
            # eqs.append((l,LTLfWeakNext(rhs_ltl)))
            # return l
            return LTLfWeakNext(rhs_ltl)
        elif c == CheckPath:
            rhs_ltl = self._rhs.to_ltlf(eqs,rep2t)
            lhs_ltl = self._path._arg.to_ltlf( eqs,rep2t)
            l = set_next_aux(self._rep,rep2t)
            eqs.append((l,LTLfImplies([lhs_ltl,rhs_ltl])))
            return l
        elif c == ChoicePath:
            lhs_ltl = LDLfBox(self._path._lhs,self._rhs).to_ltlf(eqs,rep2t)
            rhs_ltl = LDLfBox(self._path._rhs,self._rhs).to_ltlf(eqs,rep2t)
            l = set_next_aux(self._rep,rep2t)
            eqs.append((l,LTLfAnd([lhs_ltl,rhs_ltl])))
            return l
        elif c == SequencePath:
            eq_ldl = LDLfBox(self._path._lhs,LDLfBox(self._path._rhs,self._rhs))
            eq_ltl = eq_ldl.to_ltlf(eqs,rep2t)
            rhs_ltl = LDLfBox(self._path._rhs,self._rhs).to_ltlf(eqs,rep2t)
            return eq_ltl
        elif c == KleeneStarPath:
            rhs_ltl = self._rhs.to_ltlf(eqs,rep2t)
            if self._path._arg.__class__==CheckPath:
                l=rhs_ltl
            else:
                l = set_next_aux(self._rep,rep2t)
                step_ldl = LDLfBox(self._path._arg,self)
                step_ltl = step_ldl.to_ltlf(eqs,rep2t)
                eqs.append((l,LTLfAnd([rhs_ltl,step_ltl])))
            return l

    def to_mona(self, v_start, all_prop_vars, all_vars):
        new_var = 'v_{}'.format(len(all_vars))
        all_vars.add(new_var)
        st_p = self._path.to_mona(v_start,new_var,all_prop_vars, all_vars)
        st_m = self._rhs.to_mona(new_var,all_prop_vars, all_vars)
        return "(all1 {}: ( {}=> {})) ".format(new_var,st_p,st_m)

    def to_mona_vardi(self, v_start, all_prop_vars, all_vars):
        
        c = self._path.__class__
        if c == SkipPath:
            new_var = 'v_{}'.format(len(all_vars))
            all_vars.add(new_var)
            st_m = self._rhs.to_mona_vardi(new_var,all_prop_vars, all_vars)
            return "(({} = max($)) | (ex1 {}: ( {}={}+1 & {}))) ".format(v_start,new_var,new_var,v_start,st_m)

        elif c == CheckPath:
            st_p = self._path._arg.to_mona_vardi(v_start,all_prop_vars, all_vars)
            st_rhs = self._rhs.to_mona_vardi(v_start,all_prop_vars, all_vars)
            return "({}=> {}) ".format(st_p, st_rhs)

        elif c == ChoicePath:
            st_lhs = LDLfBox(self._path._lhs,self._rhs).to_mona_vardi(v_start,all_prop_vars, all_vars)
            st_rhs = LDLfBox(self._path._rhs,self._rhs).to_mona_vardi(v_start,all_prop_vars, all_vars)
            return "({}& {}) ".format(st_lhs, st_rhs)

        elif c == SequencePath:
            eq_ldl = LDLfBox(self._path._lhs,LDLfBox(self._path._rhs,self._rhs))
            return eq_ldl.to_mona_vardi(v_start,all_prop_vars, all_vars)

        elif c == KleeneStarPath:
            if self._path._arg.__class__==CheckPath:
                return self._rhs.to_mona_vardi(v_start,all_prop_vars,all_vars)
            new_2var = 'Q_{}'.format(len(all_vars))
            all_vars.add(new_2var)
            q_prop_q = LDLfProp(new_2var,[],True)
            new_var = 'v_{}'.format(len(all_vars))
            all_vars.add(new_var)
            st_q = q_prop_q.to_mona_vardi(v_start,all_prop_vars,all_vars)
            st_qv = q_prop_q.to_mona_vardi(new_var,all_prop_vars,all_vars)
            st_rhs_v = self._rhs.to_mona_vardi(new_var,all_prop_vars,all_vars)
            st_induc_v = LDLfBox(self._path._arg,q_prop_q).to_mona_vardi(new_var,all_prop_vars,all_vars)
            
            
            return "ex2 {}: ({}& all1 {}: ({}<=> ({}& {})))".format(new_2var,st_q,new_var,st_qv,st_rhs_v,st_induc_v)
# ---------------------- Paths
class Path(object):

    """
    Base class of all path

    Members:
    __rep  -- unique string representation of the path
    """
    def __init__(self, rep):
        """
        Initializes a formula with the given string representation.
        """
        self.__rep  = rep

    @property
    def _rep(self):
        """
        Return the unique string representaiton of the formula.
        """
        return self.__rep

    
    @classmethod
    def from_theory(cls, term):
        assert term.type ==  _clingo.TheoryTermType.Function
        class_name = path_operators[term.name] + "Path"
        return getattr(sys.modules[__name__], class_name).from_theory(term)   

    @classmethod
    def from_symbol(cls, symbol, id2prop):
        class_name = path_operators_names[symbol.name] + "Path"
        return getattr(sys.modules[__name__], class_name).from_symbol(symbol, id2prop)   

class SkipPath(Path):
    def __init__(self):
        Path.__init__(self, "(&skip)")

    @classmethod
    def from_theory(cls,term):
        assert term.arguments[0].name=="true"
        return cls()
    
    @classmethod
    def from_symbol(cls,symbol, id2prop):
        assert symbol.name=="top"
        return cls()
    
    def to_mona(self, v_start, v_end, all_prop_vars, all_vars):
        return "( {} = {}+1) ".format(v_end,v_start)

class BinaryPath(Path):
    """
    Members:
    _lhs
    _rhs

    """
    def __init__(self, rep, lhs, rhs):
        self._lhs = lhs
        self._rhs = rhs
        Path.__init__(self, rep)

    @classmethod
    def from_theory(cls,term):
        lhs = Path.from_theory(term.arguments[0])
        rhs = Path.from_theory(term.arguments[1])
        return cls(lhs,rhs)

    @classmethod
    def from_symbol(cls,symbol, id2prop):
        lhs = Path.from_symbol(symbol.arguments[0], id2prop)
        rhs = Path.from_symbol(symbol.arguments[1], id2prop)
        return cls(lhs,rhs)


        
class ChoicePath(BinaryPath):
    
    def __init__(self, lhs, rhs):
        BinaryPath.__init__(self, "{}+{}".format(lhs._rep, rhs._rep), lhs, rhs)

    def to_mona(self, v_start, v_end, all_prop_vars, all_vars):
        st_p_l = self._lhs.to_mona(v_start,v_end, all_prop_vars, all_vars)
        st_p_r = self._rhs.to_mona(v_start,v_end, all_prop_vars, all_vars)
        return "({} | {}) ".format(st_p_l,st_p_r)

class SequencePath(BinaryPath):
    
    def __init__(self, lhs, rhs):
        BinaryPath.__init__(self, "{};;{}".format(lhs._rep, rhs._rep), lhs, rhs)

    def to_mona(self, v_start, v_end, all_prop_vars, all_vars):
        new_var = 'v_{}'.format(len(all_vars))
        all_vars.add(new_var)
        st_p_l = self._lhs.to_mona(v_start,new_var, all_prop_vars, all_vars)
        st_p_r = self._rhs.to_mona(new_var,v_end, all_prop_vars, all_vars)
        return "(ex1 {}: ({}& {}))".format(new_var, st_p_l,st_p_r)

class UnaryPath(Path):
    """
    Members:
    __arg
    """
    def __init__(self, rep, arg):
        self.__arg = arg 
        Path.__init__(self, rep)

    @property
    def _arg(self):
        """
        Return the unique string representaiton of the formula.
        """
        return self.__arg

class CheckPath(UnaryPath):
    
    def __init__(self, arg):
        UnaryPath.__init__(self, "{}?".format(arg._rep), arg)

    @classmethod
    def from_theory(cls,term):
        arg =  LDLfFormula.from_theory(term.arguments[0])
        return cls(arg)

    @classmethod
    def from_symbol(cls,symbol, id2prop):
        arg =  LDLfFormula.from_symbol(symbol.arguments[0], id2prop)
        return cls(arg)

    def to_mona(self, v_start, v_end, all_prop_vars, all_vars):
        st_m = self._arg.to_mona(v_start, all_prop_vars, all_vars)
        return "({}& {}={})".format(st_m,v_end,v_start) #ONLY test in prop

class KleeneStarPath(UnaryPath):

    def __init__(self, arg):
        UnaryPath.__init__(self, "{}*".format(arg._rep), arg)

    @classmethod
    def from_theory(cls,term):
        arg =  Path.from_theory(term.arguments[0])
        return cls(arg)

    @classmethod
    def from_symbol(cls,symbol, id2prop):
        arg =  Path.from_symbol(symbol.arguments[0], id2prop)
        return cls(arg)

    def to_mona(self, v_start, v_end, all_prop_vars, all_vars):
        raise NotImplemented