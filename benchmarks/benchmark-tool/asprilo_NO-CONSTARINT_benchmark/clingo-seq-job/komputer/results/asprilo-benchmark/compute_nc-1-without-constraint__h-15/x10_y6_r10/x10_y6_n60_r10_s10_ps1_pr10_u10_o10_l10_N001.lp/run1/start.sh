#!/bin/bash
# http://www.cril.univ-artois.fr/~roussel/runsolver/

CAT="../../../../../../../../../programs/gcat.sh"

cd "$(dirname $0)"

#top -n 1 -b > top.txt

[[ -e .finished ]] || $CAT "../../../../../../../../../../../env/asprilo/asprilo-abstraction-encodings/instances/md/structured/x10_y6_r10/x10_y6_n60_r10_s10_ps1_pr10_u10_o10_l10_N001.lp" | "../../../../../../../../../runsolver-3.4.0/runsolver/src/runsolver" \
	-M 20000 \
	-w runsolver.watcher \
	-o runsolver.solver \
	-W 900 \
	"../../../../../../../../../programs/compute_nc-1"  ../../../../../../../../.. ../../../../../../../../../../../env/asprilo/asprilo-abstraction-encodings/instances/md/structured/x10_y6_r10/x10_y6_n60_r10_s10_ps1_pr10_u10_o10_l10_N001.lp 15

touch .finished
