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

operator("holds").
operator("trace").
operator("last").

prop_id(ID):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,P), not operator(P).
