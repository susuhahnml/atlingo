#!/bin/bash

#Activate conda env
source /usr/local/apps/anaconda3/5.3.0/etc/profile.d/conda.sh
conda activate temporal-automata
make copy-programs

###### ONE MODEL
make all-instances

#./run_bm.sh afw_del 20 1
#./run_bm.sh afw_del 25 1
#./run_bm.sh afw_del 30 1
#./run_bm.sh afw_del 35 1

# ./run_bm.sh afw 20 1
#./run_bm.sh afw 25 1
#./run_bm.sh afw 30 1
#./run_bm.sh afw 35 1

#./run_bm.sh nc 20 1
#./run_bm.sh nc 25 1
#./run_bm.sh nc 30 1
#./run_bm.sh nc 35 1

#./run_bm.sh asp 20 1
#./run_bm.sh asp 25 1
#./run_bm.sh asp 30 1
#./run_bm.sh asp 35 1

# ./run_bm.sh dfa 20 1
# ./run_bm.sh dfa 25 1
# ./run_bm.sh dfa 30 1
# ./run_bm.sh dfa 35 1

make clean-instances
make small-instances
###### ALL MODELS

./run_bm.sh afw 6 0
#./run_bm.sh afw 7 0
# ./run_bm.sh afw 8 0

./run_bm.sh afw_del 6 0
#./run_bm.sh afw_del 7 0
# ./run_bm.sh afw_del 8 0

./run_bm.sh asp 6 0
#./run_bm.sh asp 7 0
# ./run_bm.sh asp 8 0

# ./run_bm.sh dfa 6 0
# ./run_bm.sh dfa 7 0

./run_bm.sh nc 6 0
#./run_bm.sh nc 7 0
# ./run_bm.sh nc 8 0


make clean-instances
make all-grid
###### ALL MODELS GRID

# ./run_bm.sh afw 6 0
./run_bm.sh afw 6 0 grid-

# ./run_bm.sh afw_del 6 0
./run_bm.sh afw_del 6 0 grid-

# ./run_bm.sh asp 6 0
./run_bm.sh asp 6 0 grid-

# ./run_bm.sh dfa 6 0
# ./run_bm.sh dfa 6 0 grid-
# ./run_bm.sh nc 6 0
./run_bm.sh nc 6 0 grid-


###### PROJECTED MODELS TO VERIFY CORRECTENESS
make small-instances
./run_bm.sh afw 6 0 proj- '--project=show' 
#./run_bm.sh afw 7 0 proj- '--project=show' 

./run_bm.sh afw_del 6 0 proj- '--project=show'
#./run_bm.sh afw_del 7 0 proj- '--project=show'

./run_bm.sh asp 6 0 proj- '--project=show'
#./run_bm.sh asp 7 0 proj- '--project=show'

./run_bm.sh dfa 6 0 proj- '--project=show'
#./run_bm.sh dfa 7 0 proj- '--project=show'


make clean -s
echo "--------------------" > results/summary.txt
echo "Summary">> results/summary.txt
echo "--------------------">> results/summary.txt

echo "Successful:">> results/summary.txt
for f in $(find ./results/  -type f -name "*.ods");
do
    echo "  $(basename $f .ods)">> results/summary.txt
done
echo "Error:">> results/summary.txt
for f in $(find ./results/  -type f -name "*.error");
do
    if [ -s "$f" ];then
        echo "  $(basename $f .error)">> results/summary.txt
    fi
done

cat results/summary.txt

# send an email to report that the experiments are done
cat results/summary.txt | mail -s "[Benchmark Finished]" hahnmartinlu@uni-potsdam.de

cd ..
make clean -s
