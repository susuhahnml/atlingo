import unittest
import os
import sys
import clingo
# from subprocess import Popen, PIPE
import subprocess
import itertools
from pyutils.transformers import ldlf2ltlf, ltlf2dfa,ldlflp2dfalp,nfa2lp,ltlf2mona
from pyutils.ldlf import LDLfFormula
from pyutils.automata import AFW, NFA
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
from ltlf2dfa.ltlf2dfa import createMonafile, invoke_mona, output2dot
from ltlf2dfa.base import MonaProgram


logic = 'del'


# define the name of the directory to be created
paths = ["./outputs/test/afw/del/cons_tmp/instance_tmp",
        "./outputs/test/telingo/del/cons_tmp/instance_tmp",
        "./outputs/test/dfa/del/cons_tmp/instance_tmp",
        "./outputs/test/nfa/del/cons_tmp/instance_tmp"
        ]

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

def translate(constraint,extra=[],app='afw',horizon=3):
    cons_file = "env/test/temporal_constraints/{}/cons_tmp.lp".format(logic)
    with open(cons_file, 'w') as f:
        f.write(constraint)
    command = 'make translate APP={} LOGIC={} CONSTRAINT=cons_tmp ENV_APP=test INSTANCE=env/test/instances/instance_tmp.lp APP={} HORIZON={}'.format(app,logic,app,horizon) 
    # print(command)
    subprocess.check_output(command.split())


def run_check(constraint,trace="",horizon=3,app="afw",generate=False,extra_files=[]):
    translate(constraint,app=app,horizon=horizon)

    automata_path = "outputs/test/{}/{}/cons_tmp/instance_tmp/{}_automata.lp".format(app, logic,app)
    run_files = {
        "afw": ['./automata_run/run.lp',"./env/test/glue.lp"],
        "dfa": ['./automata_run/run.lp'],
        "nfa": ['./automata_run/run.lp'],
        "telingo": []
    }
    paths = [automata_path]+run_files[app]+extra_files
    if generate:
        paths.append("./automata_run/trace_generator.lp")
    return solve(["-c horizon={}".format(horizon)],paths,[trace])

def comapre_apps(constraint,horizon=3,apps=[],test_instance=None):
    models = []
    for app in apps:
        models.append(run_check(constraint,horizon=horizon,app=app,generate=True))
    for i in range(len(models)-2):
        test_instance.assertListEqual(models[i],models[i+1])

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
        
        result = run_check(":- not &del{ ?q(1) ;; ?p ;; &true .>? p}.",horizon=1,generate=True)
        base_model = [(0,'"q(1)"'),(0,'"p"'),(1,'"p"'),(1,'"last"')]
        expected_models = [base_model, base_model+[(1,'"q(1)"')]]
        self.assert_all(expected_models,result)
        self.assert_base(base_model,result)


        result = run_check(":- not &del{ ?p ;; &true .>? ~ p}.",horizon=1,generate=True)
        expected_models = [[(0,'"p"'),(1,'"last"')]]
        self.assert_all(expected_models,result)


        result = run_check(":- not &del{ ?q(1) ;; ?p ;; &true .>? p}.",horizon=3,generate=True)
        base_model = [(0,'"q(1)"'),(0,'"p"'),(1,'"p"'),(3,'"last"')]
        self.assert_base(base_model,result)

        result = run_check(":- not &del{ * ( ?p ;; &true ) .>? ?q .>? ~ p}.",horizon=1,generate=True)
        expected_models = [[(1,'"last"'),(0,'"q"')],
                          [(1,'"last"'),(0,'"q"'),(1,'"q"')],
                          [(1,'"last"'),(0,'"q"'),(1,'"q"'),(1,'"p"')],
                          [(1,'"last"'),(0,'"q"'),(1,'"p"')],
                          [(1,'"last"'),(0,'"p"'),(0,'"q"'),(1,'"q"')],
                          [(1,'"last"'),(0,'"p"'),(1,'"q"')]]
        self.assert_all(expected_models,result)                   

        # UNSAT because horizon has to be in in time point 0
        result = run_check(":- not &del{ &true .>* &false}.",horizon=3,generate=True)
        self.assert_unsat(result)

        # UNSAT because horizon has to be in in time point 0
        result = run_check(":- not &del{ &true .>* &false}.",horizon=2,generate=True)
        self.assert_unsat(result)

        result = run_check(":- not &del{ &true .>* &false}.",horizon=0,generate=True)
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
        
    
        result = run_check(":- not &del{ &true .>? move(robot(1),(1,0))}.",trace="move(robot(1),(1,0),1).",horizon=2,extra_files=["env/asprilo/glue.lp"])
        self.assert_sat(result)

        result = run_check(":- not &del{ &true .>? move(robot(1),(1,0))}.",trace="move(robot(1),(1,0),2).",horizon=2,extra_files=["env/asprilo/glue.lp"])
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
        self.assertEqual(formulas[0]._rep,"<(&skip)>b")
        formulas = LDLfFormula.from_lp(inline_data= ":- not &del{ ?a ;; * (? a + ?b ;; &true) .>? b}.")
        self.assertEqual(formulas[0]._rep,"<a?;;a?+b?;;(&skip)*>b")
        formulas = LDLfFormula.from_lp(inline_data= ":- not &del{ ?a(X) .>* &true}, p(X). p(1). p(2).")
        self.assertEqual(len(formulas),2)
        self.assertEqual(formulas[0]._rep,"[a(1)?] &true ")
        self.assertEqual(formulas[1]._rep,"[a(2)?] &true ")
          
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
            ":-not &del{ ?q .>? &true .>* &false}.",
            # Until
            ":- not &del{ *(? a;; &true) .>? b}."
        ]
        for cons in constraints:
            for h in range(1,4):
                print("Testing {} with h = {}".format(cons,h))
                comapre_apps(cons,h,apps=['afw','dfa'],test_instance=self)

    def test_closure(self):
        formula = LDLfFormula.from_lp(inline_data= ":-not &del{ * ((?p + ?q) ;; &true)  .>* ?r .>? &true}.")[0]
        # formula = LDLfFormula.from_lp(inline_data= ":-not &del{ * (?q) .>* ?p .>? &true .>? q}.")[0]
        closure = [c._rep.replace(" ","") for c in formula.closure(set([]))]
        assert "p" in closure
        assert "[(&skip)][p?+q?;;(&skip)*]<r?>&true" in closure
        assert "[p?+q?;;(&skip)][p?+q?;;(&skip)*]<r?>&true" in closure
        assert "[p?+q?][(&skip)][p?+q?;;(&skip)*]<r?>&true" in closure
        assert "[p?][(&skip)][p?+q?;;(&skip)*]<r?>&true" in closure
        assert "[q?][(&skip)][p?+q?;;(&skip)*]<r?>&true" in closure
        assert "r" in closure
        assert "<r?>&true" in closure
        assert "&true" in closure
        assert "q" in closure
        assert "[p?+q?;;(&skip)*]<r?>&true" in closure


    def test_ldlf2mona(self):
        # formula = LDLfFormula.from_lp(inline_data= ":- not &del{ ( ?a + ?c ) ;; &true .>? ?b .>? &true .>* &false }.")[0]
        formula = LDLfFormula.from_lp(inline_data= ":-not &del{  * (?q) .>? ?p .>? &true .>? q}.")[0]
        # formula = LDLfFormula.from_lp(inline_data= ":- not &del{ ?b .>? &true .>* &false }.")[0]
        # formula = LDLfFormula.from_lp(inline_data= ":- not &del{ &true .>* &false }.")[0]
        # formula = LDLfFormula.from_lp(inline_data= ":- not &del{ (?a ;; &true) .>? b  }.")[0]
        # mona_del_string = LDLfFormula.to_mona(formula)
        # formula = LDLfFormula.from_lp(inline_data= ":-not &del{ ?p .>? q}.")[0]
        
        print("----------- Vardi direct without closure --------------")
        mona_string = LDLfFormula.to_mona_vardi(formula)
        createMonafile(mona_string)
        print(mona_string)
        mona_dfa = invoke_mona("mona -q -w /tmp/automa.mona")
        nfa = NFA.from_mona(mona_dfa)
        nfa.save_png(file="outputs/automata_vardi_viz")

        print("----------- Vardi using closure --------------")
        mona_string = LDLfFormula.to_mso(formula)
        createMonafile(mona_string)
        print(mona_string)
        mona_dfa = invoke_mona("mona -q -w /tmp/automa.mona")
        nfa = NFA.from_mona(mona_dfa)
        nfa.save_png(file="outputs/automata_mso_viz")


        print("----------- Using LTL --------------")
        ltlf_formula = ldlf2ltlf(formula)
        mona_string = ltlf2mona(ltlf_formula)
        print(mona_string)
        createMonafile(mona_string)
        mona_dfa = invoke_mona("mona -q -w /tmp/automa.mona")
        nfa = NFA.from_mona(mona_dfa)
        nfa.save_png(file="outputs/automata_ltl_viz")


        print("----------- Blue book no star --------------")
        mona_string = LDLfFormula.to_mona(formula)
        createMonafile(mona_string)
        print(mona_string)
        mona_dfa = invoke_mona("mona -q -w /tmp/automa.mona")
        nfa = NFA.from_mona(mona_dfa)
        nfa.save_png(file="outputs/automata_blue_viz")
        
