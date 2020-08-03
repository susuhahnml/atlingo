#!/bin/sh
#SBATCH --time=00:10:00 
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
./single-bm.sh no_constraint 15
./single-bm.sh no_constraint 25