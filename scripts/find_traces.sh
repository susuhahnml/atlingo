#!/bin/bash
echo "Reifying..."
gringo $1/theory.lp $2 --output=reify > ./outputs/$1/instance_reified.lp
echo "Solving.."
clingo ./outputs/$1/instance_reified.lp $1/automaton.lp trace_finder.lp run.lp -n 0 > ./outputs/$1/found_traces.lp
cat ./outputs/$1/found_traces.lp
echo "Removing.."
sed -i "" '1,3d' ./outputs/$1/found_traces.lp
echo "Replacing.."
sed -i "" $'s/) /).\\\n/g' ./outputs/$1/found_traces.lp
