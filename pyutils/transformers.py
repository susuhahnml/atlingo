from graphviz import Digraph, Source
from pyutils.ldlf import (
    LTLfAnd,
    LTLfEquivalence,
    LTLfAlways
)
from ltlf2dfa.base import MonaProgram
from ltlf2dfa.ltlf2dfa import createMonafile, invoke_mona, output2dot
from pyutils.automata import NFA, AFW
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

def ltlf2mona(ltlf_formula):
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

    return mona_p_string

def ltlf2dfa(ltlf_formula):

    createMonafile(ltlf2mona(ltlf_formula))

    mona_dfa = invoke_mona("mona -q -w /tmp/automa.mona")

    nfa = NFA.from_mona(mona_dfa)
    return nfa

def ldlf2dfa(ldlf_formula):

    createMonafile(LDLfFormula.to_mso(ldlf_formula))

    mona_dfa = invoke_mona("mona -q -w /tmp/automa.mona")

    nfa = NFA.from_mona(mona_dfa)
    return nfa

def nfa2lp(nfa, out_file, prefix = ""):
    with open(out_file, 'w') as f:
        f.write(nfa.to_lp(state_prefix= prefix))

def ldlflp2dfalp(dfa_file,files=[],inline_data=""):
    ldlfformulas = LDLfFormula.from_lp(files=files,inline_data=inline_data)
    p = ""
    for i,f in enumerate(ldlfformulas):
        # ltlformula = ldlf2ltlf(f)
        # dfa = ltlf2dfa(ltlformula)
        dfa = ldlf2dfa(f)
        # dfa.save_png() 
        p+="\n%========== AUTOMATA {} ==========\n".format(i)
        p+=dfa.to_lp(state_prefix= "a{}_".format(i))

    with open(dfa_file, 'w') as f:
        f.write(p)

    return dfa

def afwlp2nfalp(nfa_file,files=[],inline_data=""):
    afw = AFW.from_lp(files = files, inline_data= inline_data)
    nfa = afw.to_nfa()
    with open(nfa_file, 'w') as f:
        f.write(nfa.to_lp())
    return nfa

if __name__ == "__main__":
    if sys.argv[1]=="dfa":
        ldlflp2dfalp(sys.argv[2],sys.argv[3:])
    elif sys.argv[1]=="nfa":
        afwlp2nfalp(sys.argv[2],sys.argv[3:])
    elif sys.argv[1]=="viz":
        app = sys.argv[2]
        if app=="dfa":
            automata = ldlflp2dfalp(sys.argv[3],sys.argv[4:])
        elif app=="nfa":
            automata = afwlp2nfalp(sys.argv[3],sys.argv[4:])
        elif app=="afw":
            automata = AFW.from_lp(files = sys.argv[4:])
        automata.save_png()
            
