% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%          Actions start at time point 1!!!


% One rule for each type of predicate used in the formula
holds(I,T-1) :- move(robot(N),(X,Y),T),id_map(I,("move",("robot",N),(X,Y))).

% Must include other actions that afect the last time step
% to make sure nothing holds after the last point of the trace
holds("action",T-1):-move(R,D,T).
