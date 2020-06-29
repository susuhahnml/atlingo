% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Trace:
% %     Creates the last time step of the trace where nothing
% %     can hold after
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %-------------------- Creates the last timestep ------------------------

#const horizon = 8.
#const new_last_id = 99999. %Also used when computing automaton

time(1..horizon). %Start in 1 (like in asprilo)

% Last can hold at any instant
{holds(new_last_id,T)}:-time(T).
% Only one last step
:- #count{1,T:holds(new_last_id,T),time(T)}!=1.
% Nothing can hold after last
:-holds(new_last_id,T),holds(P,T'),T'>T.

#show holds_map(T,MAP): holds(ID,T), id_map(ID,MAP).

