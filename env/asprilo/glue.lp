% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%          Actions start at time point 1!!!


% One rule for each type of predicate used in the formula
holds(I,T-1) :- move(robot(N),(X,Y),T),id_map(I,("move",("robot",N),(X,Y))).
holds(I,T-1) :- move_h(robot(N),T),id_map(I,("move_h",("robot",N))).
holds(I,T-1) :- move_v(robot(N),T),id_map(I,("move_v",("robot",N))).

% Must include other actions that afect the last time step
% to make sure nothing holds after the last point of the trace
holds("action",T-1):-move(R,D,T).


move_v(R,T):-move(R,(0,_),T).
move_h(R,T):-move(R,(_,0),T).