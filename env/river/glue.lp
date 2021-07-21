% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One rule for each type of predicate used in the formula
in_trace_at(ID,T) :- at(f,l,T),prop(ID,("at","f","l")).
in_trace_at(ID,T) :- at(c,l,T),prop(ID,("at","c","l")).
in_trace_at(ID,T) :- at(g,l,T),prop(ID,("at","g","l")).
in_trace_at(ID,T) :- at(boat,l,T),prop(ID,("at","boat","l")).

in_trace_at(ID,T) :- at(f,r,T),prop(ID,("at","f","r")).
in_trace_at(ID,T) :- at(c,r,T),prop(ID,("at","c","r")).
in_trace_at(ID,T) :- at(g,r,T),prop(ID,("at","g","r")).
in_trace_at(ID,T) :- at(boat,r,T),prop(ID,("at","boat","r")).

in_trace_at(ID,T) :- take(f,T),prop(ID,("take","f")).
in_trace_at(ID,T) :- take(c,T),prop(ID,("take","c")).
in_trace_at(ID,T) :- take(g,T),prop(ID,("take","g")).
in_trace_at(ID,T) :- take(boat,T),prop(ID,("take","boat")).

