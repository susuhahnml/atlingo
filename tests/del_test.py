import unittest
import sys
import clingo
# from subprocess import Popen, PIPE
import subprocess
import itertools


class Context:
    def id(self, x):
        return x
    def seq(self, x, y):
        return [x, y]

def sort_trace(trace):
    return list(sorted(trace))

def parse_model(m):
    ret = []
    for sym in m.symbols(shown=True):
        if sym.name=="holds_map":
            ret.append((sym.arguments[0].number, str(sym.arguments[1]) ))
    return sort_trace(ret)

def solve(const=[], files=[],inline_data=[]):
    r = []
    imax  = 20
    ctl = clingo.Control(['0']+const, message_limit=0)
    ctl.add("base", [], "")
    for f in files:
        ctl.load(f)
    for d in inline_data:
        ctl.add("base", [], d)
    ctl.ground([("base", [])], context=Context())
    ctl.solve(on_model= lambda m: r.append(parse_model(m)))
    return sorted(r)

def translate(constraint,file):
    f = open("examples/temporal_constraints/{}".format(file), "w")
    f.write(constraint)
    f.close()
    command = "./scripts/translate.sh del {}".format(file) 
    subprocess.check_output(command.split())

def run_generate(constraint,file="formula_test.lp",horizon=3):
    translate(constraint,file)
    return solve(["-c horizon={}".format(horizon)],["./output_automata_facts/del/formula_test.lp","./automata_run/run.lp","./automata_run/trace_generator.lp"])

def run_check(constraint,trace="",mapping="./examples/traces/test_trace_mapping.lp",encoding="",file="formula_test.lp",horizon=3):
    translate(constraint,file)
    return solve(["-c horizon={}".format(horizon)],["./output_automata_facts/del/formula_test.lp","./automata_run/run.lp",mapping],[trace,encoding])



class TestCase(unittest.TestCase):
    def assert_base(self,base_model,result):
        for r in result:
            for a in base_model:
                self.assertIn(a,r)

    def assert_all(self,expected_models,result):
        res = list(result for result,_ in itertools.groupby(result))
        expected_models = map(sort_trace, expected_models)
        self.assertCountEqual(expected_models,res)
    
    def assert_sat(self,result):
        self.assertGreater(len(result),0)

    def assert_unsat(self,result):
        self.assertEqual(len(result),0)

class TestMain(TestCase):


    def test_generation(self):
        self.maxDiff=None
        
        result = run_generate(":- not &del{ ?q(1) ;; ?p ;; &true .>? p}.",horizon=2)
        base_model = [(1,'("q",1)'),(1,'"p"'),(2,'"p"'),(2,'"last"')]
        expected_models = [base_model, base_model+[(2,'("q",1)')]]
        self.assert_all(expected_models,result)
        self.assert_base(base_model,result)

        result = run_generate(":- not &del{ ?q(1) ;; ?p ;; &true .>? p}.",horizon=4)
        base_model = [(1,'("q",1)'),(1,'"p"'),(2,'"p"')]
        self.assert_base(base_model,result)

        result = run_generate(":- not &del{ * ( ?p ;; &true ) .>? ?q .>? ~ p}.",horizon=2)
        expected_models = [[(1,'"last"'),(1,'"q"')],
                          [(2,'"last"'),(1,'"q"')],
                          [(2,'"last"'),(1,'"q"'),(2,'"q"')],
                          [(2,'"last"'),(1,'"q"'),(2,'"p"')],
                          [(2,'"last"'),(2,'"q"'),(1,'"p"')],
                          [(2,'"last"'),(2,'"q"'),(1,'"q"'),(2,'"p"')],
                          [(2,'"last"'),(2,'"q"'),(1,'"p"'),(1,'"q"')]]
        self.assert_all(expected_models,result)                   

        result = run_generate(":- not &del{ &true .>* &false}.",horizon=3)
        expected_models = [[(1,'"last"')]]
        self.assert_all(expected_models,result)
        

    def test_check(self):
        self.maxDiff=None
        
        result = run_check(":- not &del{ &true .>? move(robot(1),(1,0))}.",trace="move(robot(1),(1,0),2).",horizon=2,mapping="./examples/traces/asprilo_trace_mapping.lp")
        self.assert_sat(result)

        result = run_check(":- not &del{ &true .>? move(robot(1),(1,0))}.",trace="move(robot(1),(1,0),1).",horizon=2,mapping="./examples/traces/asprilo_trace_mapping.lp")
        self.assert_unsat(result)


        result = run_check(":- not &del{ &true .>? p}.",trace="p(2).",horizon=2)
        self.assert_sat(result)


        result = run_check(":-not &del{ ?q .>* p}.",trace="")
        self.assert_all([[(1,'"last"')],[(2,'"last"')],[(3,'"last"')]],result)     

        result = run_check(":-not &del{ ?q .>* p}.",trace="")
        self.assert_all([[(1,'"last"')],[(2,'"last"')],[(3,'"last"')]],result)   

        result = run_check(":-not &del{ &true .>* p}.",trace="",horizon=2)
        self.assert_all([[(1,'"last"')]],result)   

        result = run_check(":-not &del{ &true .>* p}.",trace="q(2).",horizon=2)
        self.assert_unsat(result)  

        result = run_check(":-not &del{ &true .>* p}.",trace="p(2).",horizon=2)
        self.assert_all([[(2,'"last"'),(2,'"p"')]],result)   

        result = run_check(":-not &del{ &true .>? p}.",trace="",horizon=2)
        self.assert_unsat(result)   



        # result = run_check(":-not &del{ &true .>* p}."), [[]])
        # result = run_check(":-not &del{ &true .>* p}.q'."), [])
        # result = run_check(":-not &del{ &true .>* p}.p'."), [['p(1)']])
        # result = run_check(":-not &del{ &true .>? p}."), [])
        # result = run_check(":-not &del{ &true .>? p}.p'."), [['p(1)']])


        # result = run_check(":-not &del{ ?p;; ?q .>* s}.p.q."), [])
        # result = run_check(":-not &del{ ?p;; ?q .>* s}.p."), [['p(0)']])
        # result = run_check(":-not &del{ ?p;; ?q .>* s}.p.q.s."), [['p(0)','q(0)','s(0)']])
        # result = run_check(":-not &del{ ?p;; ?q .>? s}."), [])
        # result = run_check(":-not &del{ ?p;; ?q .>? s}.p.q.s."), [['p(0)','q(0)','s(0)']])
        # result = run_check(":-not &del{ &true;; ?q .>? s}.q'.s'."), [['q(1)','s(1)']])
        # result = run_check(":-not &del{ &true + ?q .>* s}.q.s.s'."), [['q(0)','s(0)','s(1)']])
        # result = run_check(":-not &del{ ?p+ ?q .>? s}."), [])
        # result = run_check(":-not &del{ ?p+ ?q .>? s}.p.s."), [['p(0)','s(0)']])
        # result = run_check(":-not &del{ ?p+ &true .>? s}.s'."), [['s(1)']])

        # result = run_check(":-not &del{ * &true .>? s}.s'."), [['s(1)']])
        # result = run_check(":-not &del{ * &true .>* s}.s''."), [])
        # result = run_check(":-not &del{ * &true .>* s}.s'.a''."), [])

        # result = run_check(":-not &del{ * (?p) .>? s}.s."), [["s(0)"]])
        # result = run_check(":-not &del{ * (?p) .>* s}.s."), [["s(0)"]])
        

        # result = run_check(":-not &del{ * (p) .>* s}."), [])
        # result = run_check(":-not &del{ * (p) .>* s}.s."), [["s(0)"]])

        # result = run_check(":-not &del{ * (?p ;; &true) .>* s}."), [])
        # result = run_check(":-not &del{ * (?p ;; &true) .>* s}.s."), [["s(0)"]])
        # result = run_check(":-not &del{ * (?p ;; &true) .>* s}.s.p.a'."), [])
        # result = run_check(":-not &del{ * (?p ;; &true) .>* s}.s.p.s'."), [['p(0)','s(0)','s(1)']])
        # result = run_check(":-not &del{ ?p + * &true .>* s}.s.p.s'."), [['p(0)','s(0)','s(1)']])
        # result = run_check(":-not &del{ ?p + * &true .>* s}.p.s'."), [])

        # result = run_check(":-not &del{ ?p .>? &true .>* &false }.p.s'."), [])
        # result = run_check(":-not &del{ ?p .>? &true .>* &false }.p."), [['p(0)']])
        # result = run_check(":-not &del{ ?p .>? ?q .>? &true }.p."), [])
        
        
        # result = run_check(":-not &del{ ?p .>? ?q .>? &true }.p.q."), [['p(0)','q(0)']])