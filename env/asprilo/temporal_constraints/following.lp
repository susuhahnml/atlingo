following(robot(N'),robot(N),T):-position(robot(N),(X,Y),T), position(robot(N'),(X,Y),T-1).
in_trace_at(I,T) :- following(robot(N),robot(M),T),prop(I,("following",("robot",N),("robot",M))).