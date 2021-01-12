% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Mapping for atoms into holds predicate
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One rule for each type of predicate used in the formula
in_trace_at(I,T) :- up(T),id_map(I,("up")).
in_trace_at(I,T) :- down(T),id_map(I,("down")).
in_trace_at(I,T) :- serve(T),id_map(I,("serve")).
in_trace_at(I,T) :- wait(T),id_map(I,("wait")).


#show holds_map/2.
#show called/2.
#show served/2.
#show serve/1.
% #show position/3.
% #show id_map/2.
% #show move/2.