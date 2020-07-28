% :- not &tel{ > following(robot(R),robot(R')) >? >* ~ move(robot(R'))}, robot(R),robot(R'),R'=R+1.

% New wrong
:- not &tel{ > (following(robot(R),robot(R')) >? >* ~ move(robot(R')))}, robot(R),robot(R'),R'=R+1.
