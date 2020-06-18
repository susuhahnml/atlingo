% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One rule for each type of predicate used in the formula
holds(I,T) :- move(robot(N),(X,Y),T),id_map(I,("move",("robot",N),(X,Y))).

% Must include other actions that afect the last time step
% to make sure nothing holds after the last point of the trace
holds("action",T):-move(R,D,T).