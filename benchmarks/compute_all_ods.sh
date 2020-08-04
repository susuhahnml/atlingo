cd benchmark-tool
rm ./results/*.ods
for f in ./results/*.xml
do
NAME=$(basename -- $f .xml)
NAME=$(echo $NAME | cut -c21-)
echo "Computing .ods... for $(basename -- $NAME .xml)"
./bconv -m time,models,choices,conflicts  $f > ./results/results_$NAME.ods
done