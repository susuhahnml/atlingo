#!/bin/bash
R=`tput setaf 1`
G=`tput setaf 2`
Y=`tput setaf 3`
B=`tput setaf 5`
C=`tput setaf 6`
NC=`tput sgr0`
cd benchmark-tool
for f in $(find ../results  -type f -name "*.beval");
do
NAME=$(basename -- $f .beval)
DIR=$(dirname -- $f)
rm -f $DIR/*.ods
echo "$Y Computing .ods... for $f $NC"
if [ -s $f ]; then
    ./bconv -m time,ctime,csolve,ground0,groundN,models,timeout,restarts,conflicts,choices,domain,vars,cons,mem,error,memout,status,atoms,rules,roriginal,bodies,equiv,rchoices $f > $DIR/$NAME.ods 2> $DIR/$NAME.error
    cat $DIR/$NAME.error
else
    echo "$R.beval is empty$NC"
fi
done