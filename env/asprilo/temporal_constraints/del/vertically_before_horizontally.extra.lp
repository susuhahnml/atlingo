
move_vertically(R, T) :- move(R, (0,_), T).
no_move_vertically(robot(N), T) :- not move_vertically(robot(N), T), robot(N), time(T).
:- move_vertically(R, T), no_move_vertically(R, T).
no_move_vertically(robot(N), 0) :- robot(N).

move_horizontally(R, T) :- move(R, (_,0), T).
no_move_horizontally(robot(N), T) :- not move_horizontally(robot(N), T), robot(N), time(T).
:- move_horizontally(R, T), no_move_horizontally(R, T).
no_move_horizontally(robot(N), 0) :- robot(N).

wait(robot(R), T) :- not move(robot(R), _, T), robot(R), time(T).
in_trace_at(I,T) :- move_horizontally(robot(N),T),id_map(I,("move_horizontally",("robot",N))).
in_trace_at(I,T) :- move_vertically(robot(N),T),id_map(I,("move_vertically",("robot",N))).
in_trace_at(I,T) :- no_move_vertically(robot(N),T),id_map(I,("no_move_vertically",("robot",N))).
in_trace_at(I,T) :- no_move_horizontally(robot(N),T),id_map(I,("no_move_horizontally",("robot",N))).
in_trace_at(I,T) :- wait(robot(N),T),id_map(I,("wait",("robot",N))).