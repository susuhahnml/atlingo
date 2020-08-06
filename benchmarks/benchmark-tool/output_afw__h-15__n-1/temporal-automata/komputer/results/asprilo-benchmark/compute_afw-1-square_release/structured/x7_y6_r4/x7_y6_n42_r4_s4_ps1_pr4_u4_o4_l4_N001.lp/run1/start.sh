#!/bin/bash
# http://www.cril.univ-artois.fr/~roussel/runsolver/

CAT="../../../../../../../../../../programs/gcat.sh"

cd "$(dirname $0)"

#top -n 1 -b > top.txt

[[ -e .finished ]] || $CAT "../../../../../../../../../../../asprilo_instances/structured/x7_y6_r4/x7_y6_n42_r4_s4_ps1_pr4_u4_o4_l4_N001.lp" | "../../../../../../../../../../runsolver-3.4.0/runsolver/src/runsolver" \
	-M 20000 \
	-w runsolver.watcher \
	-o runsolver.solver \
	-W 1200 \
	"../../../../../../../../../../programs/compute_afw-1"  ../../../../../../../../../.. ../../../../../../../../../../../asprilo_instances/structured/x7_y6_r4/x7_y6_n42_r4_s4_ps1_pr4_u4_o4_l4_N001.lp 15 1 square_release

touch .finished
