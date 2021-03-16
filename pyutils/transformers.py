from graphviz import Digraph, Source
from pyutils.ldlf import (
    LTLfAnd,
    LTLfEquivalence,
    LTLfAlways
)
from ltlf2dfa.base import MonaProgram
from ltlf2dfa.ltlf2dfa import createMonafile, invoke_mona, output2dot
from dotpy.parser.parser import MyParser
from pyutils.automata import NFA
from pyutils.ldlf import LDLfFormula
import sys
import re

def ldlf2ltlf(ldlf_formula):
    eqs = []
    rep2t = {}
    l = ldlf_formula.to_ltlf(eqs,rep2t)
    ltl = l
    for eq in eqs[::-1]:
        ltl = LTLfAnd([ltl, LTLfAlways(LTLfEquivalence([eq[0],eq[1]]))])
    return ltl


def ltlf2nfa(ltlf_formula):
    p = MonaProgram(ltlf_formula)
    vrs = [v for v in p.vars if v[:4]!="AUX_"]
    aux_vrs = [v for v in p.vars if v[:4]=="AUX_"]
    mona_p_string = "\n{};\n".format(p.header)
    if len(vrs)>0:
        mona_p_string += "var2 {};\n".format(", ".join(vrs))
    if len(aux_vrs)>0:
        mona_p_string += "(ex2 {}: {});\n".format(", ".join(aux_vrs), p.formula.to_mona())
    else:
        mona_p_string += "{};\n".format(p.formula.to_mona())

    createMonafile(mona_p_string)

    mona_dfa = invoke_mona("mona -q -w /tmp/automa.mona")

    nfa = NFA.from_mona(mona_dfa)
    return nfa

def nfa2lp(nfa, out_file, prefix = ""):
    with open(out_file, 'w') as f:
        f.write(nfa.to_lp(state_prefix= prefix))

def ldlflp2nfalp(nfa_file,ldl_files=[],ldl_inline=""):
    ldlfformulas = LDLfFormula.from_lp(files=ldl_files,inline_data=ldl_inline)
    p = ""
    for i,f in enumerate(ldlfformulas):
        ltlformula = ldlf2ltlf(f)
        nfa = ltlf2nfa(ltlformula)
        # nfa.save_png() 
        p+="\n%========== AUTOMATA {} ==========\n".format(i)
        p+=nfa.to_lp(state_prefix= "a{}_".format(i))

    with open(nfa_file, 'w') as f:
        f.write(p)

if __name__ == "__main__":
    ldlfformulas = LDLfFormula.from_lp(files=sys.argv[2:])
    ldlflp2nfalp(sys.argv[1],sys.argv[2:])
