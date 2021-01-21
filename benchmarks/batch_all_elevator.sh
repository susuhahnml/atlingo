#!/bin/bash
#Activate conda env
source /usr/local/apps/anaconda3/etc/profile.d/conda.sh
conda activate temporal-automata
make copy-programs

###### ONE MODEL
./run_bm.sh elevator afw_del 8 1

./run_bm.sh elevator nc 8 1

###### ALL MODELS

./run_bm.sh elevator afw_del 8 0


make clean -s

# ./print_summary.sh asprilo

cd ..
make clean -s
