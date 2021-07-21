% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One rule for each type of predicate used in the formula
in_trace_at(ID,T) :- move(T),prop(ID,("move")).
in_trace_at(ID,T) :- move(D,T),prop(ID,("move",D)).
in_trace_at(ID,T) :- smallestfree(D,T),prop(ID,("smallestfree",D)).
