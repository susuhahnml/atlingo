rm ./results/*.ods
for f in ./results/*.beval
do
NAME=$(basename -- $f .beval)
NAME=$(echo $NAME | cut -c21-)
echo "Computing .ods... for $(basename -- $NAME .beval)"
./bconv -m time,models,choices,conflicts  $f > ./results/results_$NAME.ods
done