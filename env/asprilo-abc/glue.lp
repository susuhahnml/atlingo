% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%          Actions start at time point 1!!!


% One rule for each type of predicate used in the formula
in_trace_at(ID,T) :- move_atlingo(robot(N),T), prop(ID,("move_atlingo",("robot",N))).
in_trace_at(ID,T) :- pickup_atlingo(robot(N),T), prop(ID,("pickup_atlingo",("robot",N))).
in_trace_at(ID,T) :- putdown_atlingo(robot(N),T), prop(ID,("putdown_atlingo",("robot",N))).
in_trace_at(ID,T) :- carries_atlingo(robot(N),T), prop(ID,("carries_atlingo",("robot",N))).
in_trace_at(ID,T) :- process_atlingo(robot(N),T), prop(ID,("process_atlingo",("robot",N))).
in_trace_at(ID,T) :- process_atlingo(robot(N),shelf(S),T), prop(ID,("process_atlingo",("robot",N),("shelf",S))).


in_trace_at(ID,T) :- waits(robot(N),T), prop(ID,("waits",("robot",N))).
in_trace_at(ID,T) :- move(robot(N),(X,Y),T), prop(ID,("move",("robot",N),("",X,Y))).
in_trace_at(ID,T) :- pickup(robot(N),shelf(S),T), prop(ID,("pickup",("robot",N),("shelf",S))).
in_trace_at(ID,T) :- putdown(robot(N),shelf(S),T), prop(ID,("putdown",("robot",N),("shelf",S))).


% in_trace_at(ID,T) :- move(robot(N),T),prop(ID,("move",("robot",N),(X,Y))).
