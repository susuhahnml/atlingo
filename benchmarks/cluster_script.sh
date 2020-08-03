#!/bin/sh
#SBATCH --time=00:10:00 
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --chdir= ~/temporal-automata/atlingo/benchmarks/benchmark-tool
echo pwd
echo "Holi"
srun ./bgen runscripts/runscript_asprilo_dfa.xml