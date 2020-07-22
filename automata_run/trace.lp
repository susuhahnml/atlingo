% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Trace:
% %     Creates the last time step of the trace where nothing
% %     can hold after
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %-------------------- Creates the last timestep ------------------------

#const horizon = 8.

%last_id Should come as part of the facts

time_atlingo(0..horizon). %Start in 1 (like in asprilo)
% Last holds in horizon
holds(ID,horizon):-last_id(ID).

% % Last can hold at any instant
% {holds(ID,T)}:-time_atlingo(T),last_id(ID).
% % Only one last step
% :- #count{1,T:holds(ID,T),time_atlingo(T)}!=1,last_id(ID).

% Nothing can hold after last
:-holds(ID,T),holds(P,T'),T'>T,last_id(ID).

#show holds_map(T,MAP): holds(ID,T), id_map(ID,MAP).

