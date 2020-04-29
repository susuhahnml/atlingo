#const horizon = 1.
#const new_last_id = 200.
time(0..horizon).

%Define theory_string for last
theory_string(new_last_id+1,"last").
theory_function(new_last_id,new_last_id+1,-1).


% Any proposition can hold at any instant
{holds(ID,T)}:-prop_id(ID),time(T).
% Last can hold at any instant
{holds(new_last_id,T)}:-time(T).

%Any step could be the last
:- #count{1,T:holds(new_last_id,T)}!=1.
%Nothing can hold after last
:-holds(new_last_id,T),holds(P,T'),T'>T,prop_id(P).

%Viz propositions to hold
holds_visual(O,T):-
holds(ID,T),
theory_function(ID,ID_O,_),
theory_string(ID_O,O).

% #show holds_visual/2.


% holds(200,0).