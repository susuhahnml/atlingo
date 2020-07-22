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
            CLINGO)    CLINGO=${VALUE} ;;     
            VIZ)    VIZ="viz" ;;
            MODEL_N)  MODEL_N=${VALUE};;
            *) ADDITIONAL_FILES+="${KEY} "
    esac    
done

LOGIC=${LOGIC:-tel}
ENV=$"asprilo"
HORIZON=${HORIZON:-10}
MODEL_N=${MODEL_N:-1}

if [ -z "$CONSTRAINT" ]
then
    echo "$RED Constraint is required $NC"
    exit 1
fi

OUTPUT_PATH=$"outputs/$ENV/$LOGIC/$CONSTRAINT"


scripts/translate.sh CONSTRAINT=$CONSTRAINT LOGIC=$LOGIC env/asprilo/asprilo-abstraction-encodings/asprilo-encodings/input.lp $ADDITIONAL_FILES

CLINGO="$CLINGO -n $MODEL_N"

scripts/run.sh CONSTRAINT=$CONSTRAINT LOGIC=$LOGIC env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/{action-MD.lp,goal-MD.lp,output-M.lp} HORIZON=$HORIZON env/asprilo/asprilo-abstraction-encodings/asprilo/misc/augment-md-to-m.lp $ADDITIONAL_FILES $CLINGO


if [ -z "$VIZ" ]
then
    echo ""
else
    MODEL_N_S="$(($MODEL_N*2+2))"
    MODEL_N_E="$(($MODEL_N*2+3))"
    sed -n "${MODEL_N_S},${MODEL_N_E}"p $OUTPUT_PATH/plan.txt | viz
fi
