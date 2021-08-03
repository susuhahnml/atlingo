HORIZON_R2='--horizon 24 --horizon 25 --horizon 26 --horizon 27 --horizon 28'
# HORIZON_R2='--horizon 26 --horizon 27 --horizon 28 --horizon 29 --horizon 30'
HORIZON_R3='--horizon 26 --horizon 27 --horizon 28 --horizon 29 --horizon 30'
HORIZON_ALL='--horizon 24 --horizon 25 --horizon 26 --horizon 27 --horizon 28 --horizon 29 --horizon 30'
CLINGO_APP='--approach telingo --approach afw'
AUTOMATA_APP='--approach telingo --approach afw --approach dfa-stm --approach dfa-mso'
ALL_APP='--approach nc '${AUTOMATA_APP}
BASE='--x #horizon --env asprilo-abc '
R2='--instance _r2_'
R3='--instance _r3_'
# ############ ALL
python plot.py  ${BASE} ${ALL_APP} ${R2} ${HORIZON_R2} --type table --stat cons --stat ptime --stat ctime --stat choices --stat conflicts --stat rules --prefix="all-" --models 0
python plot.py  ${BASE} ${ALL_APP} ${R3} ${HORIZON_R3} --type table --stat cons --stat ptime --stat ctime --stat choices --stat conflicts --stat rules --prefix="all-" --models 0

python plot.py  ${BASE} ${ALL_APP} ${R2} ${HORIZON_ALL} --type table --stat cons --stat ptime --stat ctime --stat choices --stat conflicts --stat rules --prefix="all-" --constrain procedure_full --models 0


# ############ One
python plot.py  ${BASE} ${ALL_APP} ${R2} ${HORIZON_R2} --type table --stat cons --stat ptime --stat ctime --stat choices --stat conflicts --stat rules --prefix="one-" --models 1
python plot.py  ${BASE} ${ALL_APP} ${R3} ${HORIZON_R3} --type table --stat cons --stat ptime --stat ctime --stat choices --stat conflicts --stat rules --prefix="one-" --models 1

python plot.py  ${BASE} ${ALL_APP} ${R2} ${HORIZON_ALL} --type table --stat cons --stat ptime --stat ctime --stat choices --stat conflicts --stat rules --prefix="one-" --constrain procedure_full --models 1

############ Clingo Times
# python plot.py  --models 0 --x horizon --env asprilo-abc ${CLINGO_APP} ${R2} --horizon 26 --horizon 27 --horizon 28 --horizon 29 --type bar --stat models --prefix="all-models-models-" --y 'Num models'
# python plot.py  --models 0 --x horizon --env asprilo-abc ${CLINGO_APP} ${R2} --horizon 26 --horizon 27 --horizon 28 --horizon 29 --type bar --stat ctime --prefix="all-models-time-" --y 'Clingo time'