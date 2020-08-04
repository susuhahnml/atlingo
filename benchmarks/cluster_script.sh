#!/bin/sh
#SBATCH --time=00:59:00 
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
$PATH_AWF = atlingo/benchmarks/benchmark-tool
srun ./single-bm.sh no_constraint 15 1
srun ./single-bm.sh no_constraint 25 1

srun ./single-bm.sh afw 15 1
srun ./single-bm.sh afw 25 1

srun ./single-bm.sh afw 15 0
