#!/bin/bash

#Activate conda with instalation
source /usr/local/apps/anaconda3/5.3.0/etc/profile.d/conda.sh
conda activate temporal-automata


./run_bm.sh afw 15 1
#./run_bm.sh afw 25 1
#./run_bm.sh afw 35 1
#./run_bm.sh afw 45 1

./run_bm.sh nc 15 1
#./run_bm.sh nc 25 1
#./run_bm.sh nc 35 1
#./run_bm.sh nc 45 1

./run_bm.sh asp 15 1
#./run_bm.sh asp 25 1
#./run_bm.sh asp 35 1
#./run_bm.sh asp 45 1

./run_bm.sh dfa 15 1
#./run_bm.sh dfa 25 1
#./run_bm.sh dfa 35 1
#./run_bm.sh dfa 45 1

# ./run_bm.sh afw 15 0
#./run_bm.sh afw 25 0

# ./run_bm.sh nc 15 0

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
#cat results/summary.txt | mail -s "[Benchmark Finished]" hahnmartinlu@uni-potsdam.de

cd ..
make clean -q
