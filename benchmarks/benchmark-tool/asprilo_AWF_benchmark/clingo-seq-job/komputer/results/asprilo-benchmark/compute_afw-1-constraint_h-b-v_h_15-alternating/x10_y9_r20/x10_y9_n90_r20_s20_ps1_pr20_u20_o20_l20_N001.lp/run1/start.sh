#!/bin/bash
# http://www.cril.univ-artois.fr/~roussel/runsolver/

CAT="../../../../../../../../../programs/gcat.sh"

cd "$(dirname $0)"

#top -n 1 -b > top.txt

[[ -e .finished ]] || $CAT "../../../../../../../../../../../env/asprilo/asprilo-abstraction-encodings/instances/md/structured/x10_y9_r20/x10_y9_n90_r20_s20_ps1_pr20_u20_o20_l20_N001.lp" | "../../../../../../../../../runsolver-3.4.0/runsolver/src/runsolver" \
	-M 20000 \
	-w runsolver.watcher \
	-o runsolver.solver \
	-W 900 \
	"../../../../../../../../../programs/compute_afw-1"  ../../../../../../../../.. ../../../../../../../../../../../env/asprilo/asprilo-abstraction-encodings/instances/md/structured/x10_y9_r20/x10_y9_n90_r20_s20_ps1_pr20_u20_o20_l20_N001.lp 15 horizontally_before_vertically

touch .finished
