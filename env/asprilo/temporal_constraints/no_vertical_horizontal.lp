#include "vertical_horizontal.lp".

no_move_vertically(robot(N), T) :- not move_vertically(robot(N), T), robot(N), time(T).
:- move_vertically(R, T), no_move_vertically(R, T).
no_move_vertically(robot(N), 0) :- robot(N).

no_move_horizontally(robot(N), T) :- not move_horizontally(robot(N), T), robot(N), time(T).
:- move_horizontally(R, T), no_move_horizontally(R, T).
no_move_horizontally(robot(N), 0) :- robot(N).

in_trace_at(I,T) :- no_move_vertically(robot(N),T),id_map(I,("no_move_vertically",("robot",N))).
in_trace_at(I,T) :- no_move_horizontally(robot(N),T),id_map(I,("no_move_horizontally",("robot",N))).