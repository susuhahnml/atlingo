wait(robot(N), T) :- not move(robot(N), _, T), robot(N), time(T).
in_trace_at(I,T) :- wait(robot(N),T),id_map(I,("wait",("robot",N))).
wait(robot(N),0):-robot(N).