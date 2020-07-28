following(robot(R'),robot(R),T):-position(robot(R),(X,Y),T), position(robot(R'),(X,Y),T-1).
in_trace_at(I,T) :- following(robot(N),robot(M),T),id_map(I,("following",("robot",N),("robot",M))).
