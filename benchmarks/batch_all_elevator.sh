#!/bin/bash
#Activate conda env
source /usr/local/apps/anaconda3/etc/profile.d/conda.sh
conda activate temporal-automata
make copy-programs

###### ALL MODELS

# For 5 floors
./run_bm.sh elevator afw_del 8 0
./run_bm.sh elevator afw_del 9 0
./run_bm.sh elevator afw_del 10 0
./run_bm.sh elevator afw_del 11 0
./run_bm.sh elevator afw_del 12 0
./run_bm.sh elevator afw_del 13 0
./run_bm.sh elevator afw_del 14 0
./run_bm.sh elevator afw_del 15 0
# ./run_bm.sh elevator afw_del 16 0
# ./run_bm.sh elevator afw_del 17 0
# ./run_bm.sh elevator afw_del 18 0
# ./run_bm.sh elevator afw_del 19 0
# ./run_bm.sh elevator afw_del 20 0
# ./run_bm.sh elevator afw_del 21 0


./run_bm.sh elevator nc 8 0
./run_bm.sh elevator nc 9 0
./run_bm.sh elevator nc 10 0
./run_bm.sh elevator nc 11 0
./run_bm.sh elevator nc 12 0
./run_bm.sh elevator nc 13 0
./run_bm.sh elevator nc 14 0
./run_bm.sh elevator nc 15 0
# ./run_bm.sh elevator nc 16 0
# ./run_bm.sh elevator nc 17 0
# ./run_bm.sh elevator nc 18 0
# ./run_bm.sh elevator nc 19 0
# ./run_bm.sh elevator nc 20 0
# ./run_bm.sh elevator nc 21 0

./run_bm.sh elevator telingo 8 0
./run_bm.sh elevator telingo 9 0
./run_bm.sh elevator telingo 10 0
./run_bm.sh elevator telingo 11 0
./run_bm.sh elevator telingo 12 0
./run_bm.sh elevator telingo 13 0
./run_bm.sh elevator telingo 14 0
./run_bm.sh elevator telingo 15 0

make clean -s

# ./print_summary.sh elevator

cd ..
make clean -s
