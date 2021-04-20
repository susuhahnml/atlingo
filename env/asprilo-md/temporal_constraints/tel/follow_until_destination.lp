% New wrong
:- not &tel{ > (following(robot(N),robot(N')) >? >* ~ move(robot(N')))}, robot(N),robot(N'),N'=N+1.


% No next
% :- not &tel{ following(robot(N),robot(N+1)) >? >* ~ move(robot(N+1))}, robot(N).

% All robots follow the next one untill you reach your destination (Forever stop moving).
