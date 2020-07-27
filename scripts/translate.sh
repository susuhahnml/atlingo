#!/bin/bash
set -e
R=`tput setaf 1`
G=`tput setaf 2`
Y=`tput setaf 3`
B=`tput setaf 4`
NC=`tput sgr0`

echo "$Y -------------------------"
echo " |      Translating      |"
echo " -------------------------$NC"

for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   
    case "$KEY" in
            LOGIC)              LOGIC=${VALUE} ;;
            ENV)    ENV=${VALUE} ;;     
            CONSTRAINT)    CONSTRAINT=${VALUE} ;;     
            INSTANCE)    INSTANCE=${VALUE}  
    esac    
done

LOGIC=${LOGIC:-tel}
ENV=${ENV:-asprilo}
HORIZON=${HORIZON:-10}
echo "$Y LOGIC = $NC $LOGIC"
echo "$Y ENV = $NC $ENV"
echo "$Y CONSTRAINT = $NC $CONSTRAINT"
BASE_PATH=$"env/$ENV/temporal_constraints/$LOGIC/$CONSTRAINT"
OUTPUT_PATH=$"outputs/$ENV/$LOGIC/$CONSTRAINT"
echo "$Y BASE_PATH = $NC $BASE_PATH"
echo "$Y INSTANCE = $NC $INSTANCE"
echo "$Y ------------------------$NC"


if [ -z "$CONSTRAINT" ]
then
    echo "$R Constraint is required $NC"
    exit 1
fi

if test -f "$BASE_PATH.lp"; then
     mkdir -p $OUTPUT_PATH
else
     echo "File not found $BASE_PATH.lp"
     exit 1
fi

echo ""
echo "$B Reifying constraint... $NC"
gringo formula_to_automaton/$LOGIC/theory.lp $BASE_PATH.lp $INSTANCE --output=reify > $OUTPUT_PATH/reified.lp 


if  grep theory_atom $OUTPUT_PATH/reified.lp -q
then
     echo "$G Reification successfull $NC"
else
     echo "$R Reification failed, theory was not reified"
     exit 1
fi

echo "$B Translating.... $NC"
clingo $OUTPUT_PATH/reified.lp ./formula_to_automaton/automata_$LOGIC.lp -n 0 --outf=0 -V0 --out-atomf=%s. --warn=none | head -n1 | tr ". " ".\n"  > $OUTPUT_PATH/automaton.lp

if [ -s $OUTPUT_PATH/automaton.lp ]
then
     echo "$G Translation successfull$NC"
else
     echo "$R Translation failed, file is empty$NC"
     exit 1
fi