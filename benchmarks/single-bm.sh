echo $PATH
cd benchmark-tool
./bgen runscripts/runscript_asprilo_nc.xml
python2 asprilo_NO-CONSTARINT_benchmark/clingo-seq-job/komputer/start.py
./beval runscripts/runscript_asprilo_no_constraint.xml >results/ benchmark_evaluated.xml
./bconv -m time,models,choices,conflicts  results/benchmark_evaluated.xml > results/results_no_constraint.ods
