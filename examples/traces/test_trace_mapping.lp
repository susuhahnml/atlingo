% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define actions and fluents in domain with explicit timestep
action(p,T):-p(T).
action(q,T):-q(T).

% One rule for each type of predicate used in the formula
holds(I,T) :- p(T),id_map(I,("p")).
holds(I,T) :- q(T),id_map(I,("q")).


% Must include other actions that afect the last time step
% to make sure nothing holds after the last point of the trace

holds(irrelevant,T) :- action(A,T).
holds(irrelevant,T) :- fluent(A,T).
