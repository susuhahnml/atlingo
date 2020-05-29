% Any proposition can hold at any instant
{holds(ID,T)}:-prop_id(ID),time(T).

%Viz propositions to hold
holds_visual(O,T):-
holds(ID,T),
theory_function(ID,ID_O,_),
theory_string(ID_O,O).

#show holds_visual/2.