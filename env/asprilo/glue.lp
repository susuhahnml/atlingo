% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%          Actions start at time point 1!!!


% One rule for each type of predicate used in the formula
holds(I,T-1) :- move(robot(N),(X,Y),T),id_map(I,("move",("robot",N),(X,Y))).
holds(I,T-1) :- move(robot(N),(X,Y),T),id_map(I,("move",("robot",N),(X,Y))).
holds(I,T-1) :- move_r(robot(N),T),id_map(I,("move_r",("robot",N))).
holds(I,T-1) :- move_l(robot(N),T),id_map(I,("move_l",("robot",N))).
holds(I,T-1) :- move_u(robot(N),T),id_map(I,("move_u",("robot",N))).
holds(I,T-1) :- move_d(robot(N),T),id_map(I,("move_d",("robot",N))).

holds(I,T-1) :- move_h(robot(N),T),id_map(I,("move_h",("robot",N))).
holds(I,T-1) :- move_v(robot(N),T),id_map(I,("move_v",("robot",N))).

holds(I,T-1) :- no_move(robot(N),T),id_map(I,("no_move",("robot",N))).

holds(I,T) :- position(robot(N),(X,Y),T),id_map(I,("position",("robot",N),(X,Y))).

holds(I,T) :- following(robot(N),robot(M),T),id_map(I,("following",("robot",N),("robot",M))).

% Must include other actions that afect the last time step
% to make sure nothing holds after the last point of the trace
holds("action",T-1):-move(R,D,T).

following(robot(R'),robot(R),T):-position(robot(R),(X,Y),T), position(robot(R'),(X,Y),T-1).


no_move(R,T):- not move_v(R,T), not move_h(R,T), robot(R), time(T).


move_r(R,T):-move(R,(1,0),T).
move_l(R,T):-move(R,(-1,0),T).
move_u(R,T):-move(R,(0,-1),T).
move_d(R,T):-move(R,(0,1),T).

move_v(R,T):-move(R,(0,_),T).
move_h(R,T):-move(R,(_,0),T).


#show holds/2.
#show position/3.
#show id_map/2.