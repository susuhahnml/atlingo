far_apart(robot(R1), robot(R2), T) :- R2>R1, position(robot(R1),(X1,Y1),T), position(robot(R2),(X2,Y2),T), |X1-X2| + |Y1-Y2| >= 2.
in_trace_at(I,T) :- far_apart(robot(N),robot(M),T),id_map(I,("far_apart",("robot",N),("robot",M))).
#show move/3.
