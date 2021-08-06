#!/bin/bash
#Activate conda env
source /usr/local/apps/anaconda3/etc/profile.d/conda.sh
conda activate temporal-automata
make copy-programs
cd ..
make clean -s
cd benchmarks

make asprilo-clean-instances
make asprilo-abc-robots-instance

./run_bm.sh asprilo-abc afw 24 1
./run_bm.sh asprilo-abc afw 25 1
./run_bm.sh asprilo-abc afw 26 1
./run_bm.sh asprilo-abc afw 27 1
./run_bm.sh asprilo-abc afw 28 1
./run_bm.sh asprilo-abc afw 29 1
./run_bm.sh asprilo-abc afw 30 1

./run_bm.sh asprilo-abc telingo 24 1
./run_bm.sh asprilo-abc telingo 25 1
./run_bm.sh asprilo-abc telingo 26 1
./run_bm.sh asprilo-abc telingo 27 1
./run_bm.sh asprilo-abc telingo 28 1
./run_bm.sh asprilo-abc telingo 29 1
./run_bm.sh asprilo-abc telingo 30 1

./run_bm.sh asprilo-abc dfa-mso 24 1
./run_bm.sh asprilo-abc dfa-mso 25 1
./run_bm.sh asprilo-abc dfa-mso 26 1
./run_bm.sh asprilo-abc dfa-mso 27 1
./run_bm.sh asprilo-abc dfa-mso 28 1
./run_bm.sh asprilo-abc dfa-mso 29 1
./run_bm.sh asprilo-abc dfa-mso 30 1

./run_bm.sh asprilo-abc dfa-stm 24 1
./run_bm.sh asprilo-abc dfa-stm 25 1
./run_bm.sh asprilo-abc dfa-stm 26 1
./run_bm.sh asprilo-abc dfa-stm 27 1
./run_bm.sh asprilo-abc dfa-stm 28 1
./run_bm.sh asprilo-abc dfa-stm 29 1
./run_bm.sh asprilo-abc dfa-stm 30 1

./run_bm.sh asprilo-abc nc 24 1
./run_bm.sh asprilo-abc nc 25 1
./run_bm.sh asprilo-abc nc 26 1
./run_bm.sh asprilo-abc nc 27 1
./run_bm.sh asprilo-abc nc 28 1
./run_bm.sh asprilo-abc nc 29 1
./run_bm.sh asprilo-abc nc 30 1


make clean -s

make asprilo-clean-instances
make asprilo-abc-small-instance
###### ALL MODELS


./run_bm.sh asprilo-abc afw 12 0 all- --project=show
./run_bm.sh asprilo-abc afw 13 0 all- --project=show
./run_bm.sh asprilo-abc afw 14 0 all- --project=show

./run_bm.sh asprilo-abc telingo 12 0 all- --project=show
./run_bm.sh asprilo-abc telingo 13 0 all- --project=show
./run_bm.sh asprilo-abc telingo 14 0 all- --project=show

./run_bm.sh asprilo-abc dfa-stm 12 0 all- --project=show
./run_bm.sh asprilo-abc dfa-stm 13 0 all- --project=show
./run_bm.sh asprilo-abc dfa-stm 14 0 all- --project=show

./run_bm.sh asprilo-abc dfa-mso 12 0 all- --project=show
./run_bm.sh asprilo-abc dfa-mso 13 0 all- --project=show
./run_bm.sh asprilo-abc dfa-mso 14 0 all- --project=show

./run_bm.sh asprilo-abc nc 12 0 all- --project=show
./run_bm.sh asprilo-abc nc 13 0 all- --project=show
./run_bm.sh asprilo-abc nc 14 0 all- --project=show


python size-table.py

make clean -s

./print_summary.sh asprilo-abc

cd ..
make clean -s
