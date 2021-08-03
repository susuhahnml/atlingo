% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One rule for each type of predicate used in the formula
in_trace_at(ID,T) :- p(T),prop(ID,"p").
in_trace_at(ID,T) :- q(T),prop(ID,"q").
in_trace_at(ID,T) :- r(T),prop(ID,"r").
in_trace_at(ID,T) :- s(T),prop(ID,"s").
in_trace_at(ID,T) :- a(T),prop(ID,"a").
in_trace_at(ID,T) :- b(T),prop(ID,"b").
in_trace_at(ID,T) :- c(T),prop(ID,"c").
in_trace_at(ID,T) :- b(1,T),prop(ID,("b",1)).
in_trace_at(ID,T) :- b(2,T),prop(ID,("b",2)).