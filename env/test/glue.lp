% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One rule for each type of predicate used in the formula
in_trace_at(ID,T) :- p(T),prop(ID,"p").
in_trace_at(ID,T) :- q(T),prop(ID,"q").