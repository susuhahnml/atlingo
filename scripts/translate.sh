#!/bin/bash
set -e
RED=`tput setaf 1`
GREEN=`tput setaf 2`
BLUE=`tput setaf 3`
NC=`tput sgr0`

echo "$BLUE -------------------------"
echo " |      Translating      |"
echo " -------------------------$NC"

ADDITIONAL_FILES=()
for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   
    case "$KEY" in
            LOGIC)              LOGIC=${VALUE} ;;
            ENV)    ENV=${VALUE} ;;     
            CONSTRAINT)    CONSTRAINT=${VALUE} ;;     
            *) ADDITIONAL_FILES+="${KEY} "
    esac    
done

LOGIC=${LOGIC:-tel}
ENV=${ENV:-asprilo}
HORIZON=${HORIZON:-10}
echo "$BLUE LOGIC = $NC $LOGIC"
echo "$BLUE ENV = $NC $ENV"
echo "$BLUE CONSTRAINT = $NC $CONSTRAINT"
echo "$BLUE ADDITIONAL_FILES = $NC $ADDITIONAL_FILES"
BASE_PATH=$"env/$ENV/temporal_constraints/$LOGIC/$CONSTRAINT"
OUTPUT_PATH=$"outputs/$ENV/$LOGIC/$CONSTRAINT"
echo "$BLUE BASE_PATH = $NC $BASE_PATH"
echo "$BLUE ------------------------$NC"


if [ -z "$CONSTRAINT" ]
then
    echo "$RED Constraint is required $NC"
    exit 1
fi

if test -f "$BASE_PATH.lp"; then
     mkdir -p $OUTPUT_PATH
else
     echo "File not found $BASE_PATH.lp"
     exit 1
fi

echo ""
echo "Reifying constraint..."
gringo formula_to_automaton/$LOGIC/theory.lp $BASE_PATH.lp --output=reify > $OUTPUT_PATH/reified.lp $ADDITIONAL_FILES


if  grep theory_atom $OUTPUT_PATH/reified.lp -q
then
     echo "$GREEN Reification successfull $NC"
else
     echo "$RED Reification failed, theory was not reified"
     exit 1
fi

echo "Translating...."
clingo $OUTPUT_PATH/reified.lp ./formula_to_automaton/automata_$LOGIC.lp -n 0 --outf=0 -V0 --out-atomf=%s. --warn=none | head -n1 | tr ". " ".\n"  > $OUTPUT_PATH/automaton.lp

if [ -s $OUTPUT_PATH/automaton.lp ]
then
     echo "$GREEN Translation successfull$NC"
else
     echo "$RED Translation failed, file is empty$NC"
     exit 1
fi