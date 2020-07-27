#!/bin/bash

echo "Holi"

HERE=$(pwd)"/"

ROOT="$1""/"
INSTANCE=$2
HORIZON=$3

# Get all the "../" in front of "real" path
# PREFIX=$(echo $INSTANCE | sed -rn 's/(..\/+)[0-9a-z_].*$/\1/p')
# echo $PREFIX


# sleep 7

PATH_FROM_DFA_TO_ROOT="benchmarks/benchmark-tool/"
PATH_FROM_ROOT_TO_DFA="../../"
PATH_CONVERT_M_TO_MD="$ROOT""$PATH_FROM_ROOT_TO_DFA""env/asprilo/asprilo-abstraction-encodings/asprilo/misc/augment-m-to-md.lp"
PATH_ENCODING_M="$ROOT""$PATH_FROM_ROOT_TO_DFA""env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/{action-MD.lp,goal-MD.lp,output-M.lp}"

# echo $PATH_CONVERT_M_TO_MD


if [ $# -eq 3 ]
  then
	echo "	clingo --stats $INSTANCE $PATH_CONVERT_M_TO_MD $PATH_ENCODING_M -c horizon=$HORIZON	"
	clingo --stats $INSTANCE $PATH_CONVERT_M_TO_MD $PATH_ENCODING_M -c horizon=$HORIZON	
  else
	INSTANCE_NAME=$(basename "$INSTANCE")
	SAVE_NAME="$HERE""$INSTANCE_NAME""_plan.lp"

	INSTANCE=${INSTANCE#"$ROOT"}
	INSTANCE=$PATH_FROM_DFA_TO_ROOT$INSTANCE
	CONSTRAINT=$PATH_FROM_DFA_TO_ROOT$4
	( cd $ROOT ; cd $PATH_FROM_ROOT_TO_DFA ; scripts/run-asprilo.sh HORIZON=$HORIZON CONSTRAINT=$CONSTRAINT ; make print_stats ; 
		make save_plan SAVE_NAME=$SAVE_NAME)
 	# cat $SAVE_NAME 
fi

