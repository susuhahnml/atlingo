#!/bin/sh
echo "Reifying constraint..."
gringo formula_to_automaton/$1/theory.lp examples/temporal_constraints/$2 $3 --output=reify > ./output_reified_formulas/$1/$2 
echo "Translating...."
clingo ./output_reified_formulas/$1/$2 ./formula_to_automaton/automata_$1.lp -n 0 --outf=0 -V0 --out-atomf=%s. --warn=none | head -n1 | tr ". " ".\n"  > ./output_automata_facts/$1/$2 
