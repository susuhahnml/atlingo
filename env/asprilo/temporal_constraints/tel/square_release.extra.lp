looping_starts(R, T) :- move(R, (1,0), T), move(R, (0,-1), T+1), move(R, (-1,0), T+2), move(R, (0,1), T+3).
in_trace_at(I,T) :- looping_starts(robot(N),T),id_map(I,("looping_starts",("robot",N))).
