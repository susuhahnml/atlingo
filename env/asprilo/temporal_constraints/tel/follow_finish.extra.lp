#include "../following.lp".
at_destination(robot(N),T):-position(robot(N),(X,Y),T),position(destination(N),(X,Y)).
in_trace_at(I,T) :- at_destination(robot(N),T),id_map(I,("at_destination",("robot",N))).