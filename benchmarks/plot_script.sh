HORIZON_R2='--horizon 24 --horizon 25 --horizon 26 --horizon 27 --horizon 28'
HORIZON_R3='--horizon 26 --horizon 27 --horizon 28 --horizon 29 --horizon 30'
HORIZON_ALL='--horizon 24 --horizon 25 --horizon 26 --horizon 27 --horizon 28 --horizon 29 --horizon 30'
AUTOMATA_APP='--approach nfa --approach telingo --approach afw --approach dfa-stm --approach dfa-mso'
ALL_APP='--approach nc '${AUTOMATA_APP}
BASE='--models 1 --x #robots --env asprilo-abc '
R2='--instance _r2_'
R3='--instance _r3_'
############ Models (Just for test)
# python plot.py  ${BASE} ${ALL_APP} ${R2} ${HORIZON_R2} --type bar --stat models --prefix="models-" --y 'models'
# python plot.py  ${BASE} ${ALL_APP} ${R3} ${HORIZON_R3} --type bar --stat models --prefix="models-" --y 'models'

############ Processing Time
# python plot.py  ${BASE} ${ALL_APP} ${R2} --horizon 24 --type bar --stat ptime --prefix="ptime-" --y 'Processing time (sec)'
# python plot.py  ${BASE} ${ALL_APP} ${R3} --horizon 24 --type bar --stat ptime --prefix="ptime-" --y 'Processing time (sec)'

############ Clingo Times
# python plot.py  ${BASE} ${ALL_APP} ${R2} ${HORIZON_R2} --type bar --stat ctime --prefix="time-" --y 'Clingo time (sec)'
# python plot.py  ${BASE} ${ALL_APP} ${R3} ${HORIZON_R3} --type bar --stat ctime --prefix="time-" --y 'Clingo time (sec)'

############ Clingo Times
# python plot.py  ${BASE} ${ALL_APP} ${R2} ${HORIZON_R2} --type bar --stat ctime --prefix="time-" --y 'Clingo time (sec)'
python plot.py  ${BASE} ${ALL_APP} ${R3} ${HORIZON_ALL} --type bar --stat ctime --prefix="alltime-" --y 'Clingo time (sec)'

############ Choices
# python plot.py  ${BASE} ${ALL_APP} ${R2} ${HORIZON_R2} --type bar --stat choices --prefix="choices-" --y '#choices'
# python plot.py  ${BASE} ${ALL_APP} ${R3} ${HORIZON_R3} --type bar --stat choices --prefix="choices-" --y '#choices'

############ Constraints
# python plot.py  ${BASE} ${ALL_APP} ${R2} ${HORIZON_R2} --type bar --stat cons --prefix="cons-" --y '#cons'
# python plot.py  ${BASE} ${ALL_APP} ${R3} ${HORIZON_R3} --type bar --stat cons --prefix="cons-" --y '#cons'

############ Rules
# python plot.py  ${BASE} ${ALL_APP} ${R2} ${HORIZON_R2} --type bar --stat rules --prefix="rules-" --y '#rules'
# python plot.py  ${BASE} ${ALL_APP} ${R3} ${HORIZON_R3} --type bar --stat rules --prefix="rules-" --y '#rules'