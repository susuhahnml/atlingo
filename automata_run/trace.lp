% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Trace:
% %     Creates the last time step of the trace where nothing
% %     can hold after
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %-------------------- "last" holds in last timestep ------------------------

#const horizon = 8. %Passed as a parameter

time_atlingo(0..horizon). %Use a different name to avoid conflicts with each domain

% Last holds in horizon
in_trace_at(ID,horizon):-prop(ID,"last").

% %-------------------- True holds in all time steps ------------------------
in_trace_at(true,0..horizon).

% %-------------------- Used to better visualize traces ------------------------
holds_map(T,MAP):- in_trace_at(ID,T), prop(ID,MAP).