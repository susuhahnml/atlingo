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
            CONSTRAINT)    CONSTRAINT=${VALUE} ;;    
            HORIZON)    HORIZON=${VALUE} ;;     
            *) ADDITIONAL_FILES+="${KEY} "
    esac    
done

LOGIC=${LOGIC:-tel}
ENV=$"asprilo"
HORIZON=${HORIZON:-10}
echo "--- Params ---"
echo "LOGIC = $LOGIC"
echo "CONSTRAINT = $CONSTRAINT"
echo "HORIZON = $HORIZON"


if [ -z "$CONSTRAINT" ]
then
    echo "$RED Constraint is required $NC"
    exit 1
fi


BASE_PATH=$"env/$ENV/temporal_constraints/$LOGIC/$CONSTRAINT"
echo "BASE_PATH = $BASE_PATH"


scripts/translate.sh CONSTRAINT=$CONSTRAINT env/asprilo/asprilo-abstraction-encodings/asprilo-encodings/input.lp $ADDITIONAL_FILES

scripts/run.sh CONSTRAINT=$CONSTRAINT env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/{action-MD.lp,goal-MD.lp,output-M.lp} HORIZON=$HORIZON env/asprilo/augmented-md-to-m.lp $ADDITIONAL_FILES