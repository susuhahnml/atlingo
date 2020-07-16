% :- not &tel{ >? (move_r(robot(R)) & > move_r(robot(R)) & > > move_r(robot(R)) & > > > move_r(robot(R)) & > > > > move_r(robot(R)))}, RIGHT=(1,0), robot(R).
% :- not &tel{ >? (position(robot(R),D) & >position(robot(R'),D))}, robot(R),robot(R').


:- not &tel{ >? (following(robot(R),robot(R')) & > following(robot(R),robot(R')) & > > following(robot(R),robot(R')))}, robot(R),robot(R'),R!=R'.

% :- not &tel{ >? (following(robot(R),robot(R')) & > following(robot(R),robot(R')) & > > following(robot(R),robot(R')) & move_u(robot(R)) & >move_u(robot(R)))}, robot(R),robot(R'),R!=R'.