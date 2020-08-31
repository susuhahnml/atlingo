following(robot(N'),robot(N),T):-position(robot(N),(X,Y),T), position(robot(N'),(X,Y),T-1).
in_trace_at(I,T) :- following(robot(N),robot(M),T),id_map(I,("following",("robot",N),("robot",M))).