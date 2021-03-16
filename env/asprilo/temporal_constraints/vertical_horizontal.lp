move_vertically(R, T) :- move(R, (0,_), T).

move_horizontally(R, T) :- move(R, (_,0), T).

in_trace_at(I,T) :- move_horizontally(robot(N),T),prop(I,("move_horizontally",("robot",N))).
in_trace_at(I,T) :- move_vertically(robot(N),T),prop(I,("move_vertically",("robot",N))).