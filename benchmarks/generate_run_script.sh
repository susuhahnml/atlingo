#!/bin/sh
sed 's/{H}/'$2'/g; s/{N}/'$3'/g; s/{APP}/'$1'/g' ./cluster_script.sh > ./cluster_script__$1__$2__$3.sh
echo sbatch cluster_script__$1__$2__$3.sh