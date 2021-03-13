import clingo as _clingo
import sys
from benchmarks.ltlf2dfa.ltlf2dfa.parser.ltlf import  LTLfParser

from benchmarks.ltlf2dfa.ltlf2dfa.ltlf import (
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


def set_next_aux(rep, rep2aux):
    aux_name = "aux_{}".format(len(rep2aux))
    # aux_atom = LTLfAtomic(aux_name)
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
    def from_term(cls, term):
        if (term.type ==  _clingo.TheoryTermType.Symbol):
            return LDLfProp.from_term(term)
        elif (term.type ==  _clingo.TheoryTermType.Function):
            if term.name in del_operators:
                class_name = "LDLf" + del_operators[term.name]
            else:
                class_name = "LDLfProp"
            return getattr(sys.modules[__name__], class_name).from_term(term)
        else:
            raise RuntimeError("Invalid term {}".format(term))
    
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
            formula = LDLfFormula.from_term(t.elements[0].terms[0])
            formulas.append(formula)
        return formulas

    @classmethod
    def to_ltlf(cls, ldlf_formula):
        eqs = []
        rep2t = {}
        l = ldlf_formula.to_ltlf(eqs,rep2t)
        ltl = l
        for eq in eqs[::-1]:
            ltl = LTLfAnd([ltl, LTLfEquivalence([eq[0],eq[1]])])
        return ltl


    def to_nfa(self):
        # self.to_ltlf()
        # call ltlf2dfa (include quantified auxiliary)
        # Get diagram
        # Parse diagram dotpy
        # Construct NFA
        pass


    @property
    def _rep(self):
        """
        Return the unique string representaiton of the formula.
        """
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
    def from_term(cls, term):
        arg = term.arguments[0]
        assert(arg.type == _clingo.TheoryTermType.Symbol)
        return cls(arg.name == "true")

    def to_ltlf(self, eqs, rep2t):
        if self.__value:
            return LTLfAtomic("true")
        else:
            return LTLfAtomic("false")



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
        self._arguments = arguments
        args = "" if len(arguments)==0 else "({})".format(",".join([str(a) for a in arguments]))
        rep = "({}{}{})".format("" if positive else "~",
                                  name, args)

        LDLfFormula.__init__(self, rep)
        self.positive = positive

    @classmethod
    def from_term(cls, term):
        positive = True
        if term.type == _clingo.TheoryTermType.Function and term.name=="~":
            positive == False
            term = term.arguments[0]
        arguments = [] if term.type == _clingo.TheoryTermType.Symbol else term.arguments
        return cls(term.name, arguments, positive)

    def to_ltlf(self, eqs, rep2t):
        args = "" if len(self._arguments)==0 else "__".join([""]+[str(a) for a in self._arguments])
        return LTLfAtomic("{}{}".format(self._name,args))

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
    def from_term(cls, term):
        path = Path.from_term(term.arguments[0])
        rhs = LDLfFormula.from_term(term.arguments[1])
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
            l = set_next_aux(self._rep,rep2t)
            step_ldl = LDLfDiamond(self._path._arg,self)
            step_ltl = step_ldl.to_ltlf(eqs,rep2t)
            eqs.append((l,LTLfOr([rhs_ltl,step_ltl])))
            return l


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
    def from_term(cls, term):
        assert term.type ==  _clingo.TheoryTermType.Function
        class_name = path_operators[term.name] + "Path"
        return getattr(sys.modules[__name__], class_name).from_term(term)   

class SkipPath(Path):
    def __init__(self):
        Path.__init__(self, "(&skip)")

    @classmethod
    def from_term(cls,term):
        assert term.arguments[0].name=="true"
        return cls()
    
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
    def from_term(cls,term):
        lhs = Path.from_term(term.arguments[0])
        rhs = Path.from_term(term.arguments[1])
        return cls(lhs,rhs)

class ChoicePath(BinaryPath):
    
    def __init__(self, lhs, rhs):
        BinaryPath.__init__(self, "({}+{})".format(lhs._rep, rhs._rep), lhs, rhs)

class SequencePath(BinaryPath):
    
    def __init__(self, lhs, rhs):
        BinaryPath.__init__(self, "({};;{})".format(lhs._rep, rhs._rep), lhs, rhs)

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
    def from_term(cls,term):

        arg =  LDLfFormula.from_term(term.arguments[0])
        return cls(arg)

class KleeneStarPath(UnaryPath):

    def __init__(self, arg):
        UnaryPath.__init__(self, "({}*)".format(arg._rep), arg)

    @classmethod
    def from_term(cls,term):

        arg =  Path.from_term(term.arguments[0])
        return cls(arg)

