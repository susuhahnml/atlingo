% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Trace:
% %     Creates the last time step of the trace where nothing
% %     can hold after
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %-------------------- Creates the last timestep ------------------------

#const horizon = 8.

time_atlingo(0..horizon). %Use a different name to avoid conflicts with each domain

% Last holds in horizon
in_trace_at(ID,horizon):-prop(ID,"last").

holds_map(T,MAP):- in_trace_at(ID,T), prop(ID,MAP).
% #show id_map/2.
% #show holds_map/2.