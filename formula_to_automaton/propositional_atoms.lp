% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Propositional atoms:
% %     Gets the ids for all atomic propositions in the formula
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TEL Operators
operator("~").
operator(">").
operator(">:").
operator(">?").
operator(">*").
operator("&").
operator("|").
operator(">?").

%DEL Operators
operator(";;").
operator("+").
operator("?").
operator("*").
operator("~").
operator("&").
operator(".>?").
operator(".>*").

other_string("holds").
other_string("trace").
other_string("last").
other_string("true").
other_string("false").

pos_prop_id(ID):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,P), not operator(P), not other_string(P).

pos_prop_id(ID):-
theory_string(ID,P), not operator(P), not other_string(P).

prop_id(ID):-
pos_prop_id(ID), 
#count{1,ID_PARENT:theory_function(ID_PARENT, _, ID_T),theory_tuple(ID_T,0..4,ID),not pos_prop_id(ID_PARENT)}>0.
