#!/bin/bash
grep 'failed with unrecognized status or error!' results/dfa__h-15__n-1/*.error | head -1 | sed -e 's#.*Run \(\)#\1#' | sed -e 's# failed.*\(\)#\1#' > fault_runsolver.txt
LINE_ERR=$(cat fault_runsolver.txt) 
echo $([ -f $LINE_ERR ] && cat $LINE_ERR)
echo "Done"
