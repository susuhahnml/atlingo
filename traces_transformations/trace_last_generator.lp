#const horizon = 4.
#const new_last_id = 99999.
time(0..horizon).

% Define theory_string for last
theory_string(new_last_id+1,"last").
theory_function(new_last_id,new_last_id+1,-1).

% Last can hold at any instant
{holds(new_last_id,T)}:-time(T).
% Only one last step
:- #count{1,T:holds(new_last_id,T),time(T)}!=1.
% Nothing can hold after last
:-holds(new_last_id,T),holds(P,T'),T'>T,prop_id(P).
