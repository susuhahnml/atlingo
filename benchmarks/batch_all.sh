#!/bin/sh
./generate_run_script.sh no-constraint 15 1
./generate_run_script.sh no-constraint 25 1
./generate_run_script.sh no-constraint 35 1
./generate_run_script.sh no-constraint 45 1

./generate_run_script.sh afw 15 1
./generate_run_script.sh afw 25 1
./generate_run_script.sh afw 35 1
./generate_run_script.sh afw 45 1

./generate_run_script.sh no-constraint 15 0

./generate_run_script.sh afw 15 0