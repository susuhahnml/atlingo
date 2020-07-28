move_r(R,T):-move(R,(1,0),T).
in_trace_at(I,T) :- move_r(robot(N),T),id_map(I,("move_r",("robot",N))).