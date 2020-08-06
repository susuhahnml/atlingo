#!/bin/sh
PATH_AWF=atlingo\\\/benchmarks\\\/benchmark-tool
./generate_run_script.sh nc 15 1 $PATH_AWF
#./generate_run_script.sh nc 26 1 $PATH_AWF
#./generate_run_script.sh nc 35 1 $PATH_AWF
#./generate_run_script.sh nc 45 1 $PATH_AWF

./generate_run_script.sh afw 15 1 $PATH_AWF
#./generate_run_script.sh afw 25 1 $PATH_AWF
#./generate_run_script.sh afw 35 1 $PATH_AWF
#./generate_run_script.sh afw 45 1 $PATH_AWF

#./generate_run_script.sh nc 15 0 $PATH_AWF

#./generate_run_script.sh afw 15 0 $PATH_AWF
