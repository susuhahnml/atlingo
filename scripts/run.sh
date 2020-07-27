#!/bin/bash
set -e
# set -o pipefail
RED=`tput setaf 1`
GREEN=`tput setaf 2`
NC=`tput sgr0`
BLUE=`tput setaf 3`


echo "$BLUE -------------------------"
echo " |        RUNNINNG       |"
echo " -------------------------"

ADDITIONAL_FILES=()
for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)  
    case "$KEY" in
            LOGIC)              LOGIC=${VALUE} ;;
            ENV)    ENV=${VALUE} ;;     
            CONSTRAINT)    CONSTRAINT=${VALUE} ;;     
            INSTANCE)    INSTANCE=${VALUE} ;;     
            HORIZON)    HORIZON=${VALUE} ;;     
            *) ADDITIONAL_FILES+="${KEY} "
    esac    
done

LOGIC=${LOGIC:-tel}
ENV=${ENV:-asprilo}
HORIZON=${HORIZON:-10}
OUTPUT_PATH=$"outputs/$ENV/$LOGIC/$CONSTRAINT"
echo "$BLUE LOGIC = $NC $LOGIC"
echo "$BLUE ENV = $NC $ENV"
echo "$BLUE CONSTRAINT = $NC $CONSTRAINT"
echo "$BLUE HORIZON = $NC $HORIZON"
echo "$BLUE ADDITIONAL_FILES = $NC $ADDITIONAL_FILES"
echo "$BLUE INSTANCE = $NC $INSTANCE"
echo "$BLUE OUTPUT_PATH = $NC $OUTPUT_PATH"
echo "$BLUE ------------------"
echo "$NC"

if [ -z "$CONSTRAINT" ]
then
    echo "$RED Constraint is required $NC"
    exit 1
fi


# set -o pipefail
echo ""
echo "Finding plans..."
clingo $OUTPUT_PATH/automaton.lp automata_run/run.lp env/$ENV/glue.lp $INSTANCE $ADDITIONAL_FILES -c horizon=$HORIZON | tee $OUTPUT_PATH/plan.txt
echo $?
# set +o pipefail