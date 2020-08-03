#!/bin/sh
#SBATCH --time=00:10:00 
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
echo "Start"
~/temporal-automata/atlingo/benchmarks/benchmark-tool
echo "Generate"
cd benchmark-tool
./bgen ./runscripts/runscript_asprilo_no_constraint.xml
echo "Start"
python2 asprilo_NO-CONSTARINT_benchmark/clingo-seq-job/komputer/start.py
echo "Eval"
./beval runscripts/runscript_asprilo_no_constraint.xml >results/benchmark_evaluated.xml
echo "Conv"
./bconv -m time,models,choices,conflicts  results/benchmark_evaluated.xml > results/results_no_constraint.ods
