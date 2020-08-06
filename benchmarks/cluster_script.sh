#!/bin/sh
#SBATCH --time=00:59:00 
#SBATCH -N 1 # number of nodes
#SBATCH --output=slurm_out/out.%j
#SBATCH --error=slurm_out/err.%j
#SBATCH --job-name={APP}-{H}-{N}
set -e
srun ./single-bm.sh {APP} {H} {N} {PATH}
