#!/bin/bash
R=`tput setaf 1`
G=`tput setaf 2`
Y=`tput setaf 3`
B=`tput setaf 5`
C=`tput setaf 6`
NC=`tput sgr0`

set -e
export PATH="$HOME/temporal-automata/stage_asp_gitlab/tools/MONA/Front:$PATH"
eval $(make clean -q)
APPROACH=$1
HORIZON=$2
MODELS=$3

NAME=${APPROACH}__h-${HORIZON}__n-${MODELS}


MACHINE=komputer # Value in <machine name="komputer"
# set this
BT_PATH=$HOME/temporal-automata/atlingo/benchmarks/benchmark-tool

# this has to be the same as project name in run-benchmark.xml
PROJECT=temporal-automata

# this has to be the command used in run-benchmark.xml
command=$PWD/solver.sh 

# set mode: sequential=1 or cluster=2
mode=2

# if mode==2, set username to your login in the cluster
USERNAME="hahnmar"

# email to send the results
email="hahnmartinlu@uni-potsdam.de"

dir=$PWD
echo ""
echo "$C ---------------------------"
echo " Starting benchmarks for $NAME"
echo "$C ---------------------------$NC"

# Results directory
RES_DIR=$dir/results/$NAME

# Create the runscript for the arguments
RUNSCRIPT_PATH=$PWD/runscripts/runscript_asprilo_$NAME.xml
echo "$Y Creating runscript in "
echo "$B    $RUNSCRIPT_PATH $NC"
sed 's/{H}/'$HORIZON'/g; s/{N}/'$MODELS'/g' ./runscripts/runscript_asprilo_$APPROACH.xml >  $RUNSCRIPT_PATH


echo "$Y Removing old result directory $NC"
rm -rf $RES_DIR
mkdir -p $RES_DIR

echo "$Y Moving to benchmarks-tool directory "
echo "$B    $BT_PATH $NC"
cd $BT_PATH


#Output directory inside benchmark-tool is the value in <runscript output="">
OUTPUT_DIR=output/$NAME/$PROJECT 

echo "$Y Removing old output directory "
echo "$B    $OUTPUT_DIR$NC"
#Clean old output generated from benchmarktool
rm -rf $OUTPUT_DIR

echo "$Y Calling ./bgen$NC"

./bgen $RUNSCRIPT_PATH


if [ $mode -eq 1 ]; then
    echo "$Y Running python start file "
    echo "$B    $BT_PATH/$OUTPUT_DIR/$MACHINE/start.py $NC"
    ./$OUTPUT_DIR/$MACHINE/start.py
else
    echo "$Y Running sh start file "
    echo "$B    $BT_PATH/$OUTPUT_DIR/$MACHINE/start.sh $NC"
    ./$OUTPUT_DIR/$MACHINE/start.sh
    sleep 3
    SEC=0
    while squeue | grep -q $USERNAME; do
	if !(( $SEC % 5 )); then
		echo "$B Waiting for all slurm process to finish..."
	fi
	sleep 1
	SEC=($SEC+1)
    done
fi


################ Error analysis


# Analize errors in runsolver.solver
echo "$G Slurm queue is now empty $NC"
for f in $(find ./$OUTPUT_DIR/$MACHINE/results/asprilo-benchmark  -type f -name "*runsolver.solver");
do
	if grep -q 'fail' $f; then
		echo "$R Run failed in file $f"
		cat $f
		echo "$NC"
		#rm -rf $OUTPUT_DIR
		exit 1
	fi
	echo "$(tail -34 $f)" > $f
done

echo "$Y beval...$NC"
if ! ./beval $RUNSCRIPT_PATH > $RES_DIR/$NAME.beval 2> $RES_DIR/$NAME.error ; then
	# Analize errors during evaluation
	echo "$R Error in evaluation"
	cat $RES_DIR/$NAME.error
	echo "$NC"
	#rm -rf $OUTPUT_DIR
	exit 1
fi

# Analize eval error when reading a strange runsolver.solver file
grep 'failed with unrecognized status or error!' $RES_DIR/$NAME.error | head -1 | sed -e 's#.*Run \(\)#\1#' | sed -e 's# failed.*\(\)#\1#' > fault_runsolver.txt
LINE_ERR=$(cat fault_runsolver.txt)
if [ ! -z $LINE_ERR ] 
then
	echo "$R Found error inside output of runsolver"
	LINE_ERR=$LINE_ERR/runsolver.solver
	echo $LINE_ERR
	cat $LINE_ERR
	echo "$NC"
	rm fault_runsolver.txt
	#rm -rf $OUPUT_DIR
	exit 1
fi
rm fault_runsolver.txt




################ Clean beval output an generate ods file

#rm -rf $OUTPUT_DIR
echo "$G Evaluation results saved in  "
echo "$B    $RES_DIR/$NAME.beval$NC"

sed -i 's/partition="short" partition="short"/partition="short"/g' $RES_DIR/$NAME.beval
rm $RUNSCRIPT_PATH


echo "$Y bconv..."
cat $RES_DIR/$NAME.beval | ./bconv -m time,ctime,csolve,ground0,groundN,models,timeout,restarts,conflicts,choices,domain,vars,cons,mem,error,memout > $RES_DIR/$NAME.ods 2>> $RES_DIR/$NAME.error
echo "$G Conversion results saved in "
echo "$B    $RES_DIR/$NAME.ods$NC"

echo "$G Done $NAME$NC"

