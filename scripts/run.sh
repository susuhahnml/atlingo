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
            HORIZON)    HORIZON=${VALUE} ;;     
            *) ADDITIONAL_FILES+="${KEY} "
    esac    
done

LOGIC=${LOGIC:-tel}
ENV=${ENV:-asprilo}
HORIZON=${HORIZON:-10}
BASE_PATH=$"env/$ENV/temporal_constraints/$LOGIC/$CONSTRAINT"
echo "$BLUE LOGIC = $NC $LOGIC"
echo "$BLUE ENV = $NC $ENV"
echo "$BLUE CONSTRAINT = $NC $CONSTRAINT"
echo "$BLUE HORIZON = $NC $HORIZON"
echo "$BLUE ADDITIONAL_FILES = $NC $ADDITIONAL_FILES"
echo "$BLUE BASE_PATH = $NC $BASE_PATH"
echo "$BLUE ------------------"
echo "$NC"

if [ -z "$CONSTRAINT" ]
then
    echo "$RED Constraint is required $NC"
    exit 1
fi


# set -o pipefail
echo ""
echo "Fining plans..."
clingo $BASE_PATH.automaton.lp automata_run/run.lp env/$ENV/glue.lp -c horizon=$HORIZON $ADDITIONAL_FILES | tee plan.txt
echo $?
# set +o pipefail