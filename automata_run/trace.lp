% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Trace:
% %     Creates the last time step of the trace where nothing
% %     can hold after
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %-------------------- Creates the last timestep ------------------------

#const horizon = 8.

%last_id Should come as part of the facts

time_atlingo(0..horizon). %Use a different name to avoid conflicts with each domain

% Last holds in horizon
in_trace_at(ID,horizon):-last_id(ID).

% Nothing can hold after last
% :-in_trace_at(ID,T),in_trace_at(P,T'),T'>T,last_id(ID).
holds_map(T,MAP):- in_trace_at(ID,T), id_map(ID,MAP).
% #show holds_map/2.