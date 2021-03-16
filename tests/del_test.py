import unittest
import os
import sys
import clingo
# from subprocess import Popen, PIPE
import subprocess
import itertools
from pyutils.transformers import ldlf2ltlf, ltlf2nfa,ldlflp2nfalp,nfa2lp
from pyutils.ldlf import LDLfFormula
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


logic = 'del'


# define the name of the directory to be created
paths = ["./outputs/test/afw/del/formula_test/empty","./outputs/test/dfa/del/formula_test/empty"]

try:
    for p in paths:
        os.makedirs(p,exist_ok=True)
except OSError:
    print ("Creation of the directory %s failed" % p)


class Context:
    def id(self, x):
        return x
    def seq(self, x, y):
        return [x, y]

def sort_trace(trace):
    return list(sorted(trace))

def tuple2str(sym):
    if str(sym.type)=="Function" and sym.name=="":
        args = "({})".format(",".join([tuple2str(s) for s in sym.arguments[1:]]))
        return "{}{}".format(str(sym.arguments[0]).strip('"'),"" if args=="()" else args)
    else:
        return str(sym).strip('"')
def parse_model(m):
    ret = []
    for sym in m.symbols(shown=True):
        if sym.name=="holds_map":
            ret.append((sym.arguments[0].number, '"{}"'.format(tuple2str(sym.arguments[1])) ))
    return sort_trace(ret)

def solve(const=[], files=[],inline_data=[]):
    r = []
    imax  = 20
    ctl = clingo.Control(['0','--project']+const, message_limit=0)
    ctl.add("base", [], "")
    for f in files:
        ctl.load(f)
    for d in inline_data:
        ctl.add("base", [], d)
    ctl.add("base",[],"#show holds_map/2.")
    ctl.ground([("base", [])], context=Context())
    ctl.solve(on_model= lambda m: r.append(parse_model(m)))
    return sorted(r)

def translate(constraint,file,extra=[]):
    # f = open("env/test/temporal_constraints/{}/{}".format(logic,file), "w")
    with open("env/test/temporal_constraints/{}/{}".format(logic,file), 'w') as f:
        f.write(constraint)
    # f.close()
    command = 'make translate LOGIC={} CONSTRAINT={} ENV_APP=test INSTANCE=env/test/instances/empty.lp'.format(logic,file[:-3]) 
    subprocess.check_output(command.split())

def run_generate(constraint,mapping=None,horizon=3,file="formula_test.lp",app="afw"):
    translate(constraint,file)
    files = ["outputs/test/{}/{}/formula_test/empty/automaton.lp".format(app, logic),"./automata_run/run.lp","./automata_run/trace_generator.lp"]
    if not mapping is None:
        files.append(mapping)
    return solve(["-c horizon={}".format(horizon)],files)

def run_check(constraint,trace="",mapping="./env/test/glue.lp",encoding="",file="formula_test.lp",horizon=3,visualize=False,app="afw"):
    translate(constraint,file)
    if visualize:
        command = "python scripts/viz.py {} {}".format(logic,file[:-3]) 
        subprocess.check_output(command.split())

    return solve(["-c horizon={}".format(horizon)],["outputs/test/{}/{}/formula_test/empty/automaton.lp".format(app, logic),"./automata_run/run.lp",mapping],[trace,encoding])

def comapre_app(constraint,horizon=3):
    ldlflp2nfalp("outputs/test/dfa/del/formula_test/empty/automaton.lp",ldl_inline=constraint)
    files = ["outputs/test/dfa/del/formula_test/empty/automaton.lp","./automata_run/run.lp","./automata_run/trace_generator.lp"]
    m_nfa = solve(["-c horizon={}".format(horizon)],files)
    translate(constraint,"formula_test.lp")

    files = ["outputs/test/afw/del/formula_test/empty/automaton.lp","./automata_run/run.lp","./automata_run/trace_generator.lp"]
    m_afw = solve(["-c horizon={}".format(horizon)],files)
    return (m_nfa,m_afw)

class TestCase(unittest.TestCase):
    longMessage = True
    def assert_base(self,base_model,result):
        for r in result:
            for a in base_model:
                self.assertIn(a,r)

    def assert_all(self,expected_models,result):
        res = list(result for result,_ in itertools.groupby(result))
        expected_models = map(sort_trace, expected_models)
        self.assertCountEqual(expected_models,res)
    
    def assert_sat(self,result):
        self.assertGreater(len(result),0, "Is UNSAT")

    def assert_unsat(self,result):
        self.assertEqual(len(result),0, "Is NOT UNSAT. Found model: {}".format(result))

class TestMain(TestCase):


    def test_generation(self):
        self.maxDiff=None
        
        result = run_generate(":- not &del{ ?q(1) ;; ?p ;; &true .>? p}.",horizon=1)
        base_model = [(0,'"q(1)"'),(0,'"p"'),(1,'"p"'),(1,'"last"')]
        expected_models = [base_model, base_model+[(1,'"q(1)"')]]
        self.assert_all(expected_models,result)
        self.assert_base(base_model,result)


        result = run_generate(":- not &del{ ?p ;; &true .>? ~ p}.",horizon=1)
        expected_models = [[(0,'"p"'),(1,'"last"')]]
        self.assert_all(expected_models,result)


        result = run_generate(":- not &del{ ?q(1) ;; ?p ;; &true .>? p}.",horizon=3)
        base_model = [(0,'"q(1)"'),(0,'"p"'),(1,'"p"'),(3,'"last"')]
        self.assert_base(base_model,result)

        result = run_generate(":- not &del{ * ( ?p ;; &true ) .>? ?q .>? ~ p}.",horizon=1)
        expected_models = [[(1,'"last"'),(0,'"q"')],
                          [(1,'"last"'),(0,'"q"'),(1,'"q"')],
                          [(1,'"last"'),(0,'"q"'),(1,'"q"'),(1,'"p"')],
                          [(1,'"last"'),(0,'"q"'),(1,'"p"')],
                          [(1,'"last"'),(0,'"p"'),(0,'"q"'),(1,'"q"')],
                          [(1,'"last"'),(0,'"p"'),(1,'"q"')]]
        self.assert_all(expected_models,result)                   

        # UNSAT because horizon has to be in in time point 0
        result = run_generate(":- not &del{ &true .>* &false}.",horizon=3)
        self.assert_unsat(result)

        # UNSAT because horizon has to be in in time point 0
        result = run_generate(":- not &del{ &true .>* &false}.",horizon=2)
        self.assert_unsat(result)

        result = run_generate(":- not &del{ &true .>* &false}.",horizon=0)
        expected_models = [[(0,'"last"')]]
        self.assert_all(expected_models,result)
        

    def test_check(self):
        self.maxDiff=None

        ######### Examples using simple env starting actions in timepoint 0.

        # Boolean constats

        result = run_check(":- not &del{ &true }.",trace="p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &del{ &true }.",trace="",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &del{ &true }.",trace="",horizon=0)
        self.assert_sat(result)

        result = run_check(":- not &del{ &false }.",trace="p(1).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":- not &del{ &false }.",trace="",horizon=2)
        self.assert_unsat(result)

        result = run_check(":- not &del{ &false }.",trace="",horizon=0)
        self.assert_unsat(result)


        # Atoms

        result = run_check(":- not &del{ p }.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &del{ p }.",trace="p(1).",horizon=2)
        self.assert_unsat(result)

        # Step (Diamond)
        result = run_check(":- not &del{ &true .>? p}.",trace="p(1).",horizon=2)
        self.assert_sat(result)
        
        result = run_check(":-not &del{ &true .>? p}.",trace="",horizon=2)
        self.assert_unsat(result)   
        
        result = run_check(":-not &del{ &true .>? p}.",trace="",horizon=0)
        self.assert_unsat(result)   

        result = run_check(":-not &del{ &true .>? p}.",trace="p(1).",horizon=2)
        self.assert_sat(result)
        
        # Step (Box)
        result = run_check(":-not &del{ &true .>* p}.",trace="",horizon=2)
        self.assert_unsat(result)   
        
        result = run_check(":-not &del{ &true .>* p}.",trace="p(1).",horizon=2)
        self.assert_all([[(2,'"last"'),(1,'"p"')]],result)   
        
        result = run_check(":-not &del{ &true .>* p}.",trace="q(2).",horizon=2)
        self.assert_unsat(result)   

        result = run_check(":-not &del{ &true .>* p}.",trace="",horizon=0)
        self.assert_all([[(0,'"last"')]],result)
        self.assert_sat(result)   
        

        # Test construct (Diamond)
        
        result = run_check(":-not &del{ ?q .>? p}.",trace="q(0). p(0).",horizon=2)
        self.assert_all([[(2,'"last"'),(0,'"q"'),(0,'"p"')]],result)

        result = run_check(":-not &del{ ?q .>? p}.",trace="",horizon=2)
        self.assert_unsat(result)

        #TODO add tests for test on negation
        
        # Test construct (Box)

        result = run_check(":-not &del{ ?q .>* p}.",trace="",horizon=2)
        self.assert_all([[(2,'"last"')]],result)     

        result = run_check(":-not &del{ ?q .>* p}.",trace="q(2).",horizon=2)
        self.assert_all([[(2,'"last"'),(2,'"q"')]],result)     


        # Sequence (Diamond)

        result = run_check(":-not &del{ ?q ;; &true .>? p}.",trace="q(0). p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q ;; ?p .>? &true}.",trace="q(0). p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q ;; ?p .>? &true}.",trace="q(0).",horizon=2)
        self.assert_unsat(result)

        # Sequence (Box)

        result = run_check(":-not &del{ ?q ;; &true .>* p}.",trace="q(0). p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q ;; &true .>* p}.",trace="p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q ;; &true .>* p}.",trace="",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q ;; ?p .>* &true}.",trace="q(0). p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q ;; ?p .>* &true}.",trace="q(0).",horizon=2)
        self.assert_sat(result)

        # Choice (Diamond)

        result = run_check(":-not &del{ ?q + &true .>? p}.",trace="q(0). p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q + &true .>? p}.",trace="p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q + ?p .>? &true}.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q + ?p .>? &true}.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q + ?p .>? &true}.",trace="p(0).q(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q + ?p .>? &true}.",trace="",horizon=2)
        self.assert_unsat(result)


        # Choice (Box)

        result = run_check(":-not &del{ ?q + &true .>* p}.",trace="q(0). p(0).",horizon=0)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q + &true .>* p}.",trace="p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q + &true .>* p}.",trace="",horizon=0)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q + ?p .>* &true}.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q + ?p .>* &true}.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q + ?p .>* &true}.",trace="p(0).q(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ ?q + ?p .>* &true}.",trace="",horizon=2)
        self.assert_sat(result)

        # Star (Diamond)
        
        result = run_check(":-not &del{ * (?q ;; &true) .>? p}.",trace="p(0).",horizon=0)
        self.assert_sat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>? p}.",trace="",horizon=0)
        self.assert_unsat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>? p}.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>? p}.",trace="p(1).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>? p}.",trace="q(0).p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>? p}.",trace="q(0).q(1).p(2).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>? p}.",trace="q(0).q(1).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":-not &del{ * (?q) .>? p}.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        # Star (Box)

        result = run_check(":-not &del{ * (?q ;; &true) .>* p}.",trace="p(0).",horizon=0)
        self.assert_sat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>* p}.",trace="",horizon=0)
        self.assert_unsat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>* p}.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>* p}.",trace="p(1).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>* p}.",trace="q(0).p(1).p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>* p}.",trace="q(0).q(1).p(2).p(0).p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>* p}.",trace="q(0).q(1).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":-not &del{ * (?q ;; &true) .>* p}.",trace="q(0).q(1).p(1).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":-not &del{ * (?q) .>* p}.",trace="p(0).",horizon=2)
        self.assert_sat(result)

    def test_asprilo(self):

        ######### Examples using asprilo env starting actions in timepoint 1.
        
    
        result = run_check(":- not &del{ &true .>? move(robot(1),(1,0))}.",trace="move(robot(1),(1,0),1).",horizon=2,mapping="env/asprilo/glue.lp")
        self.assert_sat(result)

        result = run_check(":- not &del{ &true .>? move(robot(1),(1,0))}.",trace="move(robot(1),(1,0),2).",horizon=2,mapping="env/asprilo/glue.lp")
        self.assert_unsat(result)

    def test_multiple(self):
        self.maxDiff=None

        result = run_check(":- not &del{ &true .>? p }. :- not &del{ &true .>? q }.",trace="p(1).q(1).",horizon=2)
        self.assert_sat(result)


    def test_special(self):
        self.maxDiff=None

        # Star (Box) with need for nnf

        result = run_check(":-not &del{ (? ((* &true) .>* q)) .>* p}.",trace="",horizon=2)
        self.assert_sat(result)
        result = run_check(":-not &del{ (? ((* &true) .>* q)) .>* p}.",trace="q(0).q(1).",horizon=2)
        self.assert_sat(result)
        result = run_check(":-not &del{ (? ((* &true) .>* q)) .>* p}.",trace="q(0).q(1).q(2).",horizon=2)
        self.assert_unsat(result)
        result = run_check(":-not &del{ (? ((* &true) .>* q)) .>* p}.",trace="q(0).q(1).q(2).p(0).",horizon=2)
        self.assert_sat(result)


    def test_ldlf(self):
        formulas = LDLfFormula.from_lp(inline_data= ":- not &del{&true .>? b}.")
        self.assertEqual(formulas[0]._rep,"<(&skip)>(b)")

        formulas = LDLfFormula.from_lp(inline_data= ":- not &del{ ?a ;; * (? a + ?b ;; &true) .>? b}.")
        self.assertEqual(formulas[0]._rep,"<((a)?;;((((a)?+(b)?);;(&skip))*))>(b)")
        formulas = LDLfFormula.from_lp(inline_data= ":- not &del{ ?a(X) .>* &true}, p(X). p(1). p(2).")
        self.assertEqual(len(formulas),2)
        self.assertEqual(formulas[0]._rep,"[(a(1))?] &true ")
        self.assertEqual(formulas[1]._rep,"[(a(2))?] &true ")
        
    
    def test_transformer(self):


        formula = LDLfFormula.from_lp(inline_data= ":- not &del{&true .>? b}.")[0]
        ltlf_formula = ldlf2ltlf(formula)
        
        a_0 = LTLfAtomic('aux_0')
        b = LTLfAtomic('b')
        next_b = LTLfNext(b)
        # self.assertEqual(ltlf_formula,LTLfAnd([a_0,LTLfAlways(LTLfEquivalence([a_0,next_b]))]))
        self.assertEqual(ltlf_formula,next_b)

        formula = LDLfFormula.from_lp(inline_data= ":- not &del{ ? a ;; &true .>? b}.")[0]
        ltlf_formula = ldlf2ltlf(formula)
        # a = LTLfAtomic('a')
        # a_1 = LTLfAtomic('aux_1')

        self.assertEqual(str(ltlf_formula),"(aux_0 & G((aux_0 <-> (a & X(b)))))")


        formula = LDLfFormula.from_lp(inline_data= ":- not &del{ *(? a;; &true) .>? b}.")[0]
        ltlf_formula = ldlf2ltlf(formula)
        self.assertEqual(str(ltlf_formula),"((aux_0 & G((aux_0 <-> (b | aux_1)))) & G((aux_1 <-> (a & X(aux_0)))))")

        formula = LDLfFormula.from_lp(inline_data= ":- not &del{ &true }.")[0]
        ltlf_formula = ldlf2ltlf(formula)

    def test_translation(self):

        self.longMessage = True
        constraints = [
            ":- not &del{ &true }.",
            ":- not &del{ &false }.",
            # Atoms
            ":- not &del{ p }.",
            # Step (Diamond)
            ":-not &del{ &true .>? p}.",
            # Step (Box)
            ":-not &del{ &true .>* p}.",
            # Test construct (Diamond)
            ":-not &del{ ?q .>? p}.",
            # Test construct (Box)
            ":-not &del{ ?q .>* p}.",
            # Sequence (Diamond)
            ":-not &del{ ?q ;; &true .>? p}.",
            ":-not &del{ ?q ;; ?p .>? &true}.",
            # Sequence (Box)
            ":-not &del{ ?q ;; &true .>* p}.",
            ":-not &del{ ?q ;; ?p .>* &true}.",
            # Choice (Diamond)
            ":-not &del{ ?q + &true .>? p}.",
            ":-not &del{ ?q + ?p .>? &true}.",
            # Choice (Box)
            ":-not &del{ ?q + &true .>* p}.",
            ":-not &del{ ?q + ?p .>* &true}.",
            # Star (Diamond)
            ":-not &del{ * (?q ;; &true) .>? p}.",
            ":-not &del{  * (?q) .>? ?p .>? &true .>? q}.",
            # Star (Box)
            ":-not &del{ * (?q ;; &true) .>* p}.",
            ":-not &del{ * (?q) .>* ?p .>? &true .>? q}.",
            # Star (Box)
            ":-not &del{ ?q .>? &true .>* &false}."
        ]
        for cons in constraints:
            for h in range(1,4):
                print("Testing {} with h = {}".format(cons,h))
                m_nfa,m_afw = comapre_app(cons,h)
                self.assertListEqual(m_nfa,m_afw,cons)


    def test_until(self):
        formula = LDLfFormula.from_lp(inline_data= ":- not &del{ *(? a;; &true) .>? b}.")[0]
        ltlf_formula = ldlf2ltlf(formula)
        nfa = ltlf2nfa(ltlf_formula)
        nfa2lp(nfa,"outputs/test/dfa/del/formula_test/empty/automaton.lp")
        files = ["outputs/test/dfa/del/formula_test/empty/automaton.lp","./automata_run/run.lp","./automata_run/trace_generator.lp"]
        m_nfa = solve(["-c horizon={}".format(4)],files)

        ltlf_formula_until = LTLfUntil([LTLfAtomic("a"),LTLfAtomic("b")])
        nfa_until = ltlf2nfa(ltlf_formula_until)
        nfa2lp(nfa_until,"outputs/test/dfa/del/formula_test/empty/automaton.lp")
        files = ["outputs/test/dfa/del/formula_test/empty/automaton.lp","./automata_run/run.lp","./automata_run/trace_generator.lp"]
        m_nfa_until = solve(["-c horizon={}".format(4)],files)
        self.assertListEqual(m_nfa,m_nfa_until)
