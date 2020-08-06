#!/bin/bash
G=`tput setaf 2`
Y=`tput setaf 3`
B=`tput setaf 4`
NC=`tput sgr0`
set -e 
APPROACH=$1
# BT_PATH=benchmark-tool
BT_PATH=$4
HORIZON=$2
MODELS=$3
echo "$Y -------------------------"
echo "   Runnning benchmarks for: "
echo "   $APPROACH "
echo "     horizon=$HORIZON models=$MODELS $NC"
echo "$ -------------------------$NC"

# cd $BT_PATH
cd ~/temporal-automata/$BT_PATH

echo "$G Crating main script scripts...$NC"
NEW_RUNSCRIPT=./runscripts/runscript_asprilo_${APPROACH}__h-${HORIZON}__n-${MODELS}.xml
sed 's/{H}/'$HORIZON'/g' ./runscripts/runscript_asprilo_$APPROACH.xml > ./runscripts/temp.xml
sed 's/{N}/'$MODELS'/g' ./runscripts/temp.xml > $NEW_RUNSCRIPT
rm -rf scrips_asprilo_${APPROACH}__h-${HORIZON}__n-${MODELS}
echo "$G Generating scripts...$NC"
./bgen $NEW_RUNSCRIPT
echo "$G Start...$NC"
cd scripts_asprilo_${APPROACH}__h-${HORIZON}__n-${MODELS}/clingo-pbs-job/komputer
./start.sh
cd ../../..
echo "$G Evaluating...$NC"
./beval $NEW_RUNSCRIPT > results/benchmark_evaluated_${APPROACH}__h-${HORIZON}__n-${MODELS}.xml
