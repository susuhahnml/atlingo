% :- not &tel{>* (>following(robot(N),robot(N')) | (at_destination(robot(N'))))}, robot(N),robot(N'),N'=N+1.

% :- not &tel{>* (>followed_by(robot(A),robot(B)) | (at_destination(robot(B))))}, 
%    robot(A), robot(B), B=A+1.

:- not &tel{>* ( (> f) | d)}.
% No next
% :- not &tel{ following(robot(N),robot(N+1)) >? >* ~ move(robot(N+1))}, robot(N).

% All robots follow the next one untill you reach your destination (Forever stop moving).
