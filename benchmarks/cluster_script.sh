#!/bin/sh
#SBATCH --time=01:30:00 
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
srun ./single-bm.sh no_constraint 15 1
srun ./single-bm.sh no_constraint 25 1

srun ./single-bm.sh afw 15 1
srun ./single-bm.sh afw 25 1

srun ./single-bm.sh afw 15 0
