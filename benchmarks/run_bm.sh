#!/bin/bash
G=`tput setaf 2`
Y=`tput setaf 3`
B=`tput setaf 5`
NC=`tput sgr0`

set -e
APPROACH=$1
HORIZON=$2
MODELS=$3
BT_PATH=$4

NAME=${APPROACH}__h-${HORIZON}__n-${MODELS}


MACHINE=komputer # Value in <machine name="komputer"
# set this
BT_PATH=$HOME/temporal-automata/$BT_PATH

# this has to be the same as project name in run-benchmark.xml
PROJECT=temporal-automata


# this has to be the command used in run-benchmark.xml
command=$PWD/solver.sh 

# set mode: sequential=1 or cluster=2
mode=2

# if mode==2, set username to your login in the cluster
USERNAME="hahnmartinlu"

# email to send the results
email=""

dir=$PWD

#Results directory
RES_DIR=$dir/results/$NAME
# create the runscript for the arguments
RUNSCRIPT_PATH=$PWD/runscripts/runscript_asprilo_$NAME.xml
echo "$Y Creating runscript in "
echo "$B    $RUNSCRIPT_PATH $NC"
sed 's/{H}/'$HORIZON'/g; s/{N}/'$MODELS'/g' ./runscripts/runscript_asprilo_$APPROACH.xml >  $RUNSCRIPT_PATH

# maybe clean here soemthing
# rm -rf scrips_asprilo_${APPROACH}__h-${HORIZON}__n-${MODELS}

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
    while squeue | grep -q $USERNAME; do #TODO add here the id returned by sbatch
	if !(( $SEC % 2 )); then
	        squeue -u $USERNAME
		echo "$B Waiting for the slurm process to finish"
	fi
	sleep 1
	SEC=$SEC+1
    done
fi

echo "$Y beval...$NC"
./beval $RUNSCRIPT_PATH > $RES_DIR/$NAME.beval 2> $RES_DIR/$NAME.error
echo "$G Evaluation results saved in  "
echo "$B    $RES_DIR/$NAME.beval$NC"

sed -i 's/partition="short" partition="short"/partition="short"/g' $RES_DIR/$NAME.beval

echo "bconv..."
cat $RES_DIR/$NAME.beval | ./bconv -m models > $RES_DIR/$NAME.ods 2>> $RES_DIR/$NAME.error
echo "$G Conversion results saved in "
echo "$B    $RES_DIR/$NAME.ods$NC"

# echo "tar..."
# tar -czf $NAME.tar.gz output/$project
# mv $NAME.tar.gz $RES_DIR
# cp $RUNSCRIPT_PATH $RES_DIR
# cp $command $RES_DIR
# rm -rf output/$project

# echo "done"
# echo $RES_DIR/$NAME.ods
# # send an email to report that the experiments are done
# echo "done $1" | mail -s "[benchmark_finished] $1 " -A $RES_DIR/$NAME.ods $email