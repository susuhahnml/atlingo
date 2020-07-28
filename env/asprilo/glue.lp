% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%          Actions start at time point 1!!!


% One rule for each type of predicate used in the formula
in_trace_at(I,T) :- move(robot(N),(X,Y),T),id_map(I,("move",("robot",N),(X,Y))).
in_trace_at(I,T) :- move(robot(N),(X,Y),T),id_map(I,("move",("robot",N),(X,Y))).
in_trace_at(I,T) :- position(robot(N),(X,Y),T),id_map(I,("position",("robot",N),(X,Y))).

% Additional predicates used
in_trace_at(I,T) :- move(robot(N),T),id_map(I,("move",("robot",N))).


move(R, T) :- move(R, _, T).



% #show holds/2.
% #show position/3.
% #show id_map/2.
% #show move/2.