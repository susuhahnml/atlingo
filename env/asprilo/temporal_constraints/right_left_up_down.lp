right((1,0)).
left((-1,0)).
up((0,-1)).
down((0,1)).

move_right(robot(N), T) :- move(robot(N), R, T), right(R).

in_trace_at(I,T) :- move_right(robot(N),T),id_map(I,("move_right",("robot",N))).


move_left(robot(N), T) :- move(robot(N), R, T), left(R).

in_trace_at(I,T) :- move_left(robot(N),T),id_map(I,("move_left",("robot",N))).

move_up(robot(N), T) :- move(robot(N), R, T), up(R).

in_trace_at(I,T) :- move_up(robot(N),T),id_map(I,("move_up",("robot",N))).

% #show move_right/2.
% #show right/1.