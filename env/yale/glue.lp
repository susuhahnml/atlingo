% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One rule for each type of predicate used in the formula
in_trace_at(ID,T) :- load(T),prop(ID,("load")).
in_trace_at(ID,T) :- loaded(T),prop(ID,("loaded")).
in_trace_at(ID,T) :- alive(T),prop(ID,("alive")).
in_trace_at(ID,T) :- shoot(T),prop(ID,("shoot")).

