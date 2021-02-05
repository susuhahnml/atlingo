% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One rule for each type of predicate used in the formula
in_trace_at(ID,T) :- up(T),prop(ID,("up")).
in_trace_at(ID,T) :- down(T),prop(ID,("down")).
in_trace_at(ID,T) :- serve(T),prop(ID,("serve")).
in_trace_at(ID,T) :- wait(T),prop(ID,("wait")).
in_trace_at(ID,T) :- ready(T),prop(ID,("ready")).


% #show called/2.
% #show served/2.
% #show serve/1.
% #show position/3.
% #show id_map/2.
% #show move/2.