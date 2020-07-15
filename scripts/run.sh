#!/bin/bash
set -e
RED=`tput setaf 1`
GREEN=`tput setaf 2`
NC=`tput sgr0`

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
echo "--- Params ---"
echo "LOGIC = $LOGIC"
echo "ENV = $ENV"
echo "CONSTRAINT = $CONSTRAINT"
echo "HORIZON = $HORIZON"
echo "ADDITIONAL_FILES = $ADDITIONAL_FILES"


if [ -z "$CONSTRAINT" ]
then
    echo "$RED Constraint is required $NC"
    exit 1
fi

BASE_PATH=$"env/$ENV/temporal_constraints/$LOGIC/$CONSTRAINT"
echo "BASE_PATH = $BASE_PATH"


echo ""
echo "Fining plans..."
clingo $BASE_PATH.automaton.lp automata_run/run.lp env/$ENV/glue.lp -c horizon=$HORIZON $ADDITIONAL_FILES 