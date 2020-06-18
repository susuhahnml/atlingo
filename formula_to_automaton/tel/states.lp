% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % States:
% %     Computes all states for automaton
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------- Initial formula --------------------------
initial_state(ID):-
theory_atom(ID_A,ID_O,ID_E),
theory_string(ID_O,"tel"),
theory_element(ID_E,ID_T,_),
theory_tuple(ID_T,0,ID).


state(ID):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,P), operator(P).

state(ID):- prop_id(ID).