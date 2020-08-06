#!/bin/sh
SUB='s/{H}/'$2'/g; s/{N}/'$3'/g; s/{APP}/'$1'/g; s/{PATH}/'$4'/g'
sed 's/{H}/'$2'/g; s/{N}/'$3'/g; s/{APP}/'$1'/g; s/{PATH}/'$4'/g' ./cluster_script.sh > ./cluster_script__$1__$2__$3.sh
sbatch cluster_script__$1__$2__$3.sh
