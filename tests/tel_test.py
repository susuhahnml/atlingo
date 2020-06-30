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
    command = "./scripts/translate.sh tel {}".format(file) 
    subprocess.check_output(command.split())

def run_generate(constraint,file="formula_test.lp",horizon=3):
    translate(constraint,file)
    return solve(["-c horizon={}".format(horizon)],["./output_automata_facts/tel/formula_test.lp","./automata_run/run.lp","./automata_run/trace_generator.lp"])

def run_check(constraint,trace="",mapping="./examples/traces/test_trace_mapping.lp",encoding="",file="formula_test.lp",horizon=3):
    translate(constraint,file)
    return solve(["-c horizon={}".format(horizon)],["./output_automata_facts/tel/formula_test.lp","./automata_run/run.lp",mapping],[trace,encoding])



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
        
        result = run_generate(":- not &tel{ &true >? p}.",horizon=2)
        expected_models = [[(1,'"last"'),(1,'"p"')],
                          [(2,'"last"'),(1,'"p"')],
                          [(2,'"last"'),(2,'"p"')],
                          [(2,'"last"'),(1,'"p"'),(2,'"p"')]]

        self.assert_all(expected_models,result)                   


    def test_check(self):
        self.maxDiff=None
        
        result = run_check(":- not &tel{ move(robot(1),(1,0)) & > move(robot(1),(1,0)) }.",trace="move(robot(1),(1,0),2).move(robot(1),(1,0),1).",horizon=2,mapping="./examples/traces/asprilo_trace_mapping.lp")
        self.assert_sat(result)

        result = run_check(":- not &tel{ move(robot(1),(1,0)) & > move(robot(1),(1,0)) }.",trace="move(robot(1),(1,0),2).",horizon=2,mapping="./examples/traces/asprilo_trace_mapping.lp")
        self.assert_unsat(result)
