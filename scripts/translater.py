from graphviz import Digraph, Source
from pystructures.ldlf import (
    LTLfAnd,
    LTLfEquivalence,
    LTLfAlways,
    LDLfFormula
)
from ltlf2dfa.base import MonaProgram
from pystructures.automata import AFW
import argparse
import sys
import re

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Translations for LDLf formulas and automatas')
    parser.add_argument('--input', type=str, 
                        help='Starting input: afw or ldlf')
    parser.add_argument('--app', type=str, 
                        help='Approach name: dfa-mso, dfa-stm, nfa')
    parser.add_argument('--out-file', type=str, 
                        help='Path for output automata file')
    parser.add_argument('--in-files', type=str, 
                        help='Path for ldlf constraint or afw representation')

    args = parser.parse_args()
    in_files = args.in_files.split(" ")
    in_files = [f for f in in_files if f!=""]
    if args.input=="afw":
        assert args.app == "nfa"
        afw = AFW.from_lp(files = in_files, inline_data= "")
        automata = afw.to_nfa()
        automata_lp = automata.to_lp()

    elif args.input=="ldlf":
        assert args.app in ["dfa-mso","dfa-stm"]
        ldlfformulas = LDLfFormula.from_lp(files=in_files,inline_data="")
        automata_lp= ""
        for i,f in enumerate(ldlfformulas):
            dfa = f.dfa(translation=args.app.split('-')[1])
            automata_lp+="\n%========== AUTOMATA {} ==========\n".format(i)
            automata_lp+=dfa.to_lp(state_prefix= "a{}_".format(i))
    # elif args.input=="telingo":
    #     program = ""
    #     for fn in sys.argv[3:]:
    #         f = open(fn, 'r')
    #         program += f.read()
    #         f.close()
    #         print(program)
    #         horizon = int(sys.argv[1]) + 1
    #         solve(program, imin=horizon, out_file=sys.argv[2], imax=horizon, istop="UNKNOWN")
    else:
        raise RuntimeError("Invalid input")

    with open(args.out_file, 'w') as f:
        f.write(automata_lp)
            
    import sys
    sys.exit()

