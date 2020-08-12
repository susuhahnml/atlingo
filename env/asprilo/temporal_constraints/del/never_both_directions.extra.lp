wait(robot(R), T) :- not move(robot(R), _, T), robot(R), time(T).
in_trace_at(I,T) :- wait(robot(N),T),id_map(I,("wait",("robot",N))).