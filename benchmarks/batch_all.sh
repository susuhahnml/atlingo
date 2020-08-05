#!/bin/sh
N=1
APP=no-constraint
HORIZON=15
sed 's/{H}/'$HORIZON'/g; s/{N}/'$N'/g; s/{APP}/'$APP'/g' ./cluster_script.sh > ./cluster_script__${APP}__${HORIZON}__${N}.sh
echo sbatch cluster_script__${APP}__${HORIZON}__${N}.sh
HORIZON=25
sed 's/{H}/'$HORIZON'/g; s/{N}/'$N'/g; s/{APP}/'$APP'/g' ./cluster_script.sh > ./cluster_script__${APP}__${HORIZON}__${N}.sh
echo sbatch cluster_script__${APP}__${HORIZON}__${N}.sh
HORIZON=35
sed 's/{H}/'$HORIZON'/g; s/{N}/'$N'/g; s/{APP}/'$APP'/g' ./cluster_script.sh > ./cluster_script__${APP}__${HORIZON}__${N}.sh
echo sbatch cluster_script__${APP}__${HORIZON}__${N}.sh
HORIZON=45
sed 's/{H}/'$HORIZON'/g; s/{N}/'$N'/g; s/{APP}/'$APP'/g' ./cluster_script.sh > ./cluster_script__${APP}__${HORIZON}__${N}.sh
echo sbatch cluster_script__${APP}__${HORIZON}__${N}.sh


APP=afw
HORIZON=15
sed 's/{H}/'$HORIZON'/g; s/{N}/'$N'/g; s/{APP}/'$APP'/g' ./cluster_script.sh > ./cluster_script__${APP}__${HORIZON}__${N}.sh
echo sbatch cluster_script__${APP}__${HORIZON}__${N}.sh
HORIZON=25
sed 's/{H}/'$HORIZON'/g; s/{N}/'$N'/g; s/{APP}/'$APP'/g' ./cluster_script.sh > ./cluster_script__${APP}__${HORIZON}__${N}.sh
echo sbatch cluster_script__${APP}__${HORIZON}__${N}.sh
HORIZON=35
sed 's/{H}/'$HORIZON'/g; s/{N}/'$N'/g; s/{APP}/'$APP'/g' ./cluster_script.sh > ./cluster_script__${APP}__${HORIZON}__${N}.sh
echo sbatch cluster_script__${APP}__${HORIZON}__${N}.sh
HORIZON=45
sed 's/{H}/'$HORIZON'/g; s/{N}/'$N'/g; s/{APP}/'$APP'/g' ./cluster_script.sh > ./cluster_script__${APP}__${HORIZON}__${N}.sh
echo sbatch cluster_script__${APP}__${HORIZON}__${N}.sh