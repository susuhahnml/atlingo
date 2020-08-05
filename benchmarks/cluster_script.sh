#!/bin/sh
#SBATCH --time=00:59:00 
#SBATCH -N 1 # number of nodes
#SBATCH --output=out.%j
#SBATCH --error=err.%j
#SBATCH --job-name={APP}-{H}-{N}
$PATH_AWF = atlingo/benchmarks/benchmark-tool
set -e
srun ./single-bm.sh {APP} {H} {N}
