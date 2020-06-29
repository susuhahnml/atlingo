% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define actions and fluents in domain with explicit timestep
action(up(X),T):-up(X,T).
fluent(waiting,T):-waiting(T).

% One rule for each type of predicate used in the formula
holds(I,T) :- up(X,T),id_map(I,("up",X)).
holds(I,T) :- down(X,T),id_map(I,("down",X)).


% Must include other actions that afect the last time step
% to make sure nothing holds after the last point of the trace

holds(irrelevant,T) :- action(A,T).
holds(irrelevant,T) :- fluent(A,T).
