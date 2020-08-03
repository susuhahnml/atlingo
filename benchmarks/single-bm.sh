#!/bin/bash
APPROACH=$1
# BT_PATH=benchmark-tool
BT_PATH=atlingo/benchmarks/benchmark-tool
HORIZON=$2
NEW_RUNSCRIPT=./runscripts/runscript_asprilo_${APPROACH}__h-$HORIZON.xml
echo "Generate..."
# cd $BT_PATH
cd ~/temporal-automata/$BT_PATH
sed 's/{H}/'$HORIZON'/g' ./runscripts/runscript_asprilo_$APPROACH.xml > $NEW_RUNSCRIPT
rm -rf scrips_asprilo_${APPROACH}__h-$HORIZON
./bgen $NEW_RUNSCRIPT
echo "Start..."
python2 asprilo_${APPROACH}_benchmark/clingo-seq-job/komputer/start.py
echo "Eval..."
./beval $NEW_RUNSCRIPT > results/benchmark_evaluated_${APPROACH}__h-$HORIZON.xml
echo "Conv..."
./bconv -m time,models,choices,conflicts  results/benchmark_evaluated__${APPROACH}__h-$HORIZON.xml > results/results_${APPROACH}__h-$HORIZON.ods