ENV=$1

echo "--------------------" > results/$ENV/summary.txt
echo "Summary">> results/$ENV/summary.txt
echo "--------------------">> results/$ENV/summary.txt

echo "Successful:">> results/$ENV/summary.txt
for f in $(find ./results/$ENV/  -type f -name "*.ods");
do
    echo "  $(basename $f .ods)">> results/$ENV/summary.txt
done
echo "Error:">> results/$ENV/summary.txt
for f in $(find ./results/$ENV/  -type f -name "*.error");
do
    if [ -s "$f" ];then
        echo "  $(basename $f .error)">> results/$ENV/summary.txt
    fi
done

cat results/$ENV/summary.txt

# send an email to report that the experiments are done
cat results/$ENV/summary.txt | mail -s "[Benchmark Finished]" hahnmartinlu@uni-potsdam.de
