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

# ./run_bm.sh asprilo-abc afw 24 0
# ./run_bm.sh asprilo-abc afw 25 0
# ./run_bm.sh asprilo-abc afw 26 0
# ./run_bm.sh asprilo-abc afw 27 0
# ./run_bm.sh asprilo-abc afw 28 0
# ./run_bm.sh asprilo-abc afw 29 0
# ./run_bm.sh asprilo-abc afw 30 0

# ./run_bm.sh asprilo-abc telingo 24 0
# ./run_bm.sh asprilo-abc telingo 25 0
# ./run_bm.sh asprilo-abc telingo 26 0
# ./run_bm.sh asprilo-abc telingo 27 0
# ./run_bm.sh asprilo-abc telingo 28 0
# ./run_bm.sh asprilo-abc telingo 29 0
# ./run_bm.sh asprilo-abc telingo 30 0

# ./run_bm.sh asprilo-abc dfa-mso 24 0
# ./run_bm.sh asprilo-abc dfa-mso 25 0
# ./run_bm.sh asprilo-abc dfa-mso 26 0
# ./run_bm.sh asprilo-abc dfa-mso 27 0
# ./run_bm.sh asprilo-abc dfa-mso 28 0
# ./run_bm.sh asprilo-abc dfa-mso 29 0
# ./run_bm.sh asprilo-abc dfa-mso 30 0

./run_bm.sh asprilo-abc dfa-stm 24 0
./run_bm.sh asprilo-abc dfa-stm 25 0
./run_bm.sh asprilo-abc dfa-stm 26 0
./run_bm.sh asprilo-abc dfa-stm 27 0
./run_bm.sh asprilo-abc dfa-stm 28 0
./run_bm.sh asprilo-abc dfa-stm 29 0
./run_bm.sh asprilo-abc dfa-stm 30 0

# ./run_bm.sh asprilo-abc nc 24 0
# ./run_bm.sh asprilo-abc nc 25 0
# ./run_bm.sh asprilo-abc nc 26 0
# ./run_bm.sh asprilo-abc nc 27 0
# ./run_bm.sh asprilo-abc nc 28 0
# ./run_bm.sh asprilo-abc nc 29 0
# ./run_bm.sh asprilo-abc nc 30 0


# make clean -s

# make asprilo-clean-instances
# make asprilo-abc-small-robots-instance
###### ALL MODELS


# ./run_bm.sh asprilo-abc afw 25 0 all- --project=show
# ./run_bm.sh asprilo-abc afw 26 0 all- --project=show

# ./run_bm.sh asprilo-abc telingo 25 0 all- --project=show
# ./run_bm.sh asprilo-abc telingo 26 0 all- --project=show

# ./run_bm.sh asprilo-abc dfa-mso 25 0 all- --project=show
# ./run_bm.sh asprilo-abc dfa-mso 26 0 all- --project=show

# ./run_bm.sh asprilo-abc dfa-stm 25 0 all- --project=show
# ./run_bm.sh asprilo-abc dfa-stm 26 0 all- --project=show

# ./run_bm.sh asprilo-abc nc 25 0 all- --project=show
# ./run_bm.sh asprilo-abc nc 26 0 all- --project=show

# make clean -s

###### PROJECTED MODELS TO VERIFY CORRECTENESS proj- --project=show

#./run_bm.sh asprilo-abc afw 12 0 proj- --project=show

#./run_bm.sh asprilo-abc telingo 12 0 proj- --project=show

#./run_bm.sh asprilo-abc dfa-mso 12 0 proj --project=show

#./run_bm.sh asprilo-abc dfa-stm 12 0 proj --project=show


python size-table.py

# make clean -s

./print_summary.sh asprilo-abc

cd ..
make clean -s
