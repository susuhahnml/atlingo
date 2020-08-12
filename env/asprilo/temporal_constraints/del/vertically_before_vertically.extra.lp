move_vertically(R, T) :- move(R, (0,_), T).
move_horizontally(R, T) :- move(R, (_,0), T).
wait(robot(R), T) :- not move(robot(R), _, T), robot(R), time(T).
in_trace_at(I,T) :- move_horizontally(robot(N),T),id_map(I,("move_horizontally",("robot",N))).
in_trace_at(I,T) :- move_vertically(robot(N),T),id_map(I,("move_vertically",("robot",N))).
in_trace_at(I,T) :- wait(robot(N),T),id_map(I,("wait",("robot",N))).