import unittest
import sys
import clingo
# from subprocess import Popen, PIPE
import subprocess
import itertools



logic = 'tel'

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
    ctl.add("base",[],"#show holds_map/2.")
    ctl.ground([("base", [])], context=Context())
    ctl.solve(on_model= lambda m: r.append(parse_model(m)))
    return sorted(r)

def translate(constraint,file,extra=[]):
    f = open("env/test/temporal_constraints/{}/{}".format(logic,file), "w")
    f.write(constraint)
    f.close()
    command = 'make translate LOGIC={} CONSTRAINT={} ENV_APP=test INSTANCE=env/test/instances/empty.lp'.format(logic,file[:-3]) 
    subprocess.check_output(command.split())

def run_generate(constraint,mapping=None,horizon=3,file="formula_test.lp"):
    translate(constraint,file)
    files = ["outputs/test/{}/formula_test/empty/automaton.lp".format(logic),"./encodings/automata_run/run.lp","./encodings/automata_run/trace_generator.lp"]
    if not mapping is None:
        files.append(mapping)
    return solve(["-c horizon={}".format(horizon)],files)

def run_check(constraint,trace="",mapping="./env/test/glue.lp",encoding="",file="formula_test.lp",horizon=3,visualize=False):
    translate(constraint,file)
    if visualize:
        command = "python scripts/viz.py {} {}".format(logic,file[:-3]) 
        subprocess.check_output(command.split())

    return solve(["-c horizon={}".format(horizon)],["outputs/test/{}/formula_test/empty/automaton.lp".format(logic),"./encodings/automata_run/run.lp",mapping],[trace,encoding])




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
        self.assertGreater(len(result),0, "Is UNSAT")

    def assert_unsat(self,result):
        self.assertEqual(len(result),0, "Is NOT UNSAT. Found model: {}".format(result))

class TestMain(TestCase):


    def test_generation(self):
        self.maxDiff=None
        
        result = run_generate(":- not &tel{ &true >? p}.",horizon=2)
        expected_models = [[(2,'"last"'),(0,'"p"')],
                          [(2,'"last"'),(1,'"p"')],
                          [(2,'"last"'),(2,'"p"')],
                          [(2,'"last"'),(2,'"p"'),(0,'"p"')],
                          [(2,'"last"'),(2,'"p"'),(1,'"p"')],
                          [(2,'"last"'),(0,'"p"'),(1,'"p"')],
                          [(2,'"last"'),(0,'"p"'),(1,'"p"'),(2,'"p"')]]

        self.assert_all(expected_models,result)                   

    def test_multiple(self):

        result = run_check(":- not &tel{ p }. :- not &tel{ q }.",trace="p(0).",horizon=2)
        self.assert_unsat(result)
        result = run_check(":- not &tel{ p }. :- not &tel{ q }.",trace="q(0).",horizon=2)
        self.assert_unsat(result)
        result = run_check(":- not &tel{ p }. :- not &tel{ q }.",trace="q(0).p(0).",horizon=2)
        self.assert_sat(result)

    def test_asprilo(self):
        ######### Examples using asprilo env starting actions in timepoint 1.

        result = run_check(":- not &tel{ > move(robot(1),(1,0)) & > > move(robot(1),(1,0)) }.",trace="move(robot(1),(1,0),2).move(robot(1),(1,0),1).",horizon=2,mapping="./env/asprilo/glue.lp")
        self.assert_sat(result)

        result = run_check(":- not &tel{ > move(robot(1),(1,0)) & > > move(robot(1),(1,0)) }.",trace="move(robot(1),(1,0),2).",horizon=2,mapping="./env/asprilo/glue.lp")
        self.assert_unsat(result)


    def test_check(self):
        self.maxDiff=None
        
        ######### Examples using simple env starting actions in timepoint 0.

        # Boolean constats

        result = run_check(":- not &tel{ &true }.",trace="p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &tel{ &true }.",trace="",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &tel{ &true }.",trace="",horizon=0)
        self.assert_sat(result)

        result = run_check(":- not &tel{ &false }.",trace="p(1).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":- not &tel{ &false }.",trace="",horizon=2)
        self.assert_unsat(result)

        result = run_check(":- not &tel{ &false }.",trace="",horizon=0)
        self.assert_unsat(result)


        # Atoms

        result = run_check(":- not &tel{ p }.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &tel{ p }.",trace="p(1).",horizon=2)
        self.assert_unsat(result)


        # Negated Atoms

        result = run_check(":- not &tel{ ~ p }.",trace="p(0).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":- not &tel{ ~ p }.",trace="p(1).",horizon=2)
        self.assert_sat(result)

        # And

        result = run_check(":- not &tel{ q & ~ p }.",trace="p(0).",horizon=2)
        self.assert_unsat(result)
        
        result = run_check(":- not &tel{ q & ~ p }.",trace="",horizon=2)
        self.assert_unsat(result)

        result = run_check(":- not &tel{ q & ~ p }.",trace="q(0).",horizon=2)
        self.assert_sat(result)

        # Or

        result = run_check(":- not &tel{ q | ~ p }.",trace="p(0).",horizon=2)
        self.assert_unsat(result)
        
        result = run_check(":- not &tel{ q | ~ p }.",trace="",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &tel{ q | ~ p }.",trace="q(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &tel{ q | ~ p }.",trace="q(0).p(0).",horizon=2)
        self.assert_sat(result)

        
        # Next 
        result = run_check(":- not &tel{ > p}.",trace="p(1).",horizon=2)
        self.assert_sat(result)
        
        result = run_check(":-not &tel{ > p}.",trace="",horizon=2)
        self.assert_unsat(result)   
        
        result = run_check(":-not &tel{ > p}.",trace="",horizon=0)
        self.assert_unsat(result)   



        # Weak Next 
        result = run_check(":- not &tel{ >: p}.",trace="p(1).",horizon=2)
        self.assert_sat(result)
        
        result = run_check(":-not &tel{ >: p}.",trace="",horizon=2)
        self.assert_unsat(result)   

        result = run_check(":-not &tel{ >: p}.",trace="",horizon=0)
        self.assert_sat(result) 
        

        # Eventually
        result = run_check(":- not &tel{ >? p}.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &tel{ >? p}.",trace="p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &tel{ >? p}.",trace="p(2).",horizon=2)
        self.assert_sat(result)
        
        result = run_check(":-not &tel{ >? p}.",trace="",horizon=2)
        self.assert_unsat(result)   

        result = run_check(":-not &tel{ >? p}.",trace="",horizon=0)
        self.assert_unsat(result) 


        # Always
        result = run_check(":- not &tel{ >* p}.",trace="p(0).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":- not &tel{ >* p}.",trace="p(1).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":- not &tel{ >* p}.",trace="p(2).",horizon=2)
        self.assert_unsat(result)
        
        result = run_check(":- not &tel{ >* p}.",trace="p(0).p(1).p(2).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &tel{ >* p}.",trace="p(0).",horizon=0)
        self.assert_sat(result) 


        # Until
        result = run_check(":- not &tel{ &true >? p}.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &tel{ &true >? p}.",trace="p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &tel{ &true >? p}.",trace="p(2).",horizon=2)
        self.assert_sat(result)
        
        result = run_check(":-not &tel{ &true >? p}.",trace="",horizon=2)
        self.assert_unsat(result)   

        result = run_check(":-not &tel{ &true >? p}.",trace="",horizon=0)
        self.assert_unsat(result) 


        result = run_check(":- not &tel{ q >? p}.",trace="p(0).",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &tel{ q >? p}.",trace="q(0).p(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":- not &tel{ q >? p}.",trace="q(0).q(1).p(2).",horizon=2)
        self.assert_sat(result)
        
        result = run_check(":-not &tel{ q >? p}.",trace="",horizon=2)
        self.assert_unsat(result)   

        result = run_check(":-not &tel{ q >? p}.",trace="p(2).",horizon=2)
        self.assert_unsat(result)   

        result = run_check(":-not &tel{ q >? p}.",trace="q(0).p(2).",horizon=2)
        self.assert_unsat(result)   

        result = run_check(":-not &tel{ q >? p}.",trace="",horizon=0)
        self.assert_unsat(result) 


        # Release
        result = run_check(":- not &tel{ &false >* p}.",trace="p(0).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":- not &tel{ &false >* p}.",trace="p(1).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":- not &tel{ &false >* p}.",trace="p(2).",horizon=2)
        self.assert_unsat(result)
        
        result = run_check(":- not &tel{ &false >* p}.",trace="p(0).p(1).p(2).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &tel{ &false >* p}.",trace="p(0).",horizon=0)
        self.assert_sat(result) 

        result = run_check(":- not &tel{ q >* p}.",trace="p(0).",horizon=2)
        self.assert_unsat(result)

        result = run_check(":- not &tel{ q >* p}.",trace="p(0).p(1).q(1).",horizon=2)
        self.assert_sat(result)

        result = run_check(":-not &tel{ q >* p}.",trace="p(0).q(0).",horizon=0)
        self.assert_sat(result) 

    def test_z(self):
        self.maxDiff=None
        

        # result = run_check(":- not &tel{ > p & (q >? p) }.",trace="p(1).q(0).p(1).",horizon=2)
        result = run_generate(":- not &tel{ > a & (b >? a) }.",horizon=2)
        # self.assert_sat(result)

    def test_special(self):
        self.maxDiff=None

        result = run_generate(":-not &tel{>*(~X | >? ~X)},prop(X).prop(p).",horizon=2)
        # print(result)