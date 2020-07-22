% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Delta:
% %     Defines the translation function
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------- Initial formula --------------------------
initial_state(ID):-
theory_atom(ID_A,ID_O,ID_E),
theory_string(ID_O,"tel"),
theory_element(ID_E,ID_T,_),
theory_tuple(ID_T,0,ID).

%-------------------- Initial operators --------------------------

% %-------------------- Positive boolean formulas shape ------------
% %
% %       pbf(id(ID)): Positive boolean formula refering to state with id ID
% %       pbf(true): true (__last accepting state)
% %       pbf(false): false (invalid state)
% %       pbf(and(B1,B2)): B1 and B2 
% %       pbf(or(B1,B2)): B1 or B2 
% %       pbf(decide(V,B1,B2)): if V is true choose B1 if not choose B2 


% %-------------------- Transition function ------------------------
% %
% %       delta(S,B): The delta transition from state S is the
% %                    positive boolean formula B

%----- Prop
delta(ID ,pbf_decide(ID,pbf_true,pbf_false)):- 
prop_id(ID).

%----- Neg ~prop
delta(ID ,pbf_decide(ID_L,pbf_false,pbf_true)):- 
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,"~"),
theory_tuple(ID_T,0,ID_L).

%----- Boolean True
delta(ID ,pbf_true):- 
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,"&"),
theory_tuple(ID_T,0,ID_L),
theory_string(ID_L,"true").

%----- Boolean False
delta(ID ,pbf_false):- 
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,"&"),
theory_tuple(ID_T,0,ID_L),
theory_string(ID_L,"false").


%----- Next >
delta(ID ,pbf_decide(ID_LAST,pbf_false,pbf_id(ID_L))):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,">"),
theory_tuple(ID_T,0,ID_L),
last_id(ID_LAST).

%----- Weak Next >:
delta(ID ,pbf_decide(ID_LAST,pbf_true,pbf_id(ID_L))):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,">:"),
theory_tuple(ID_T,0,ID_L),
last_id(ID_LAST).


%----- And &
delta(ID ,pbf_and(PBF_L,PBF_R)):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,"&"),
theory_tuple(ID_T,0,ID_L),
theory_tuple(ID_T,1,ID_R),
delta(ID_L,PBF_L),
delta(ID_R,PBF_R).

%----- Or >?
delta(ID ,pbf_or(PBF_L,PBF_R)):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,"|"),
theory_tuple(ID_T,0,ID_L),
theory_tuple(ID_T,1,ID_R),
delta(ID_L,PBF_L),
delta(ID_R,PBF_R).

%----- Untill >?
delta(ID ,pbf_or(PBF_R,pbf_and(PBF_L,pbf_decide(ID_LAST,pbf_false,pbf_id(ID))))):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,">?"),
theory_tuple(ID_T,0,ID_L),
theory_tuple(ID_T,1,ID_R),
delta(ID_L,PBF_L),
delta(ID_R,PBF_R),
last_id(ID_LAST).


%----- Release >*
delta(ID ,pbf_and(PBF_R,pbf_or(PBF_L,pbf_decide(ID_LAST,pbf_true,pbf_id(ID))))):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,">*"),
theory_tuple(ID_T,0,ID_L),
theory_tuple(ID_T,1,ID_R),
delta(ID_L,PBF_L),
delta(ID_R,PBF_R),
last_id(ID_LAST).

%----- Eventually >?
delta(ID ,pbf_or(PBF_L,pbf_decide(ID_LAST,pbf_false,pbf_id(ID)))):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,">?"),
theory_tuple(ID_T,0,ID_L),
not theory_tuple(ID_T,1,_),
delta(ID_L,PBF_L),
last_id(ID_LAST).

%----- Allways >*
delta(ID ,pbf_and(PBF_L,pbf_decide(ID_LAST,pbf_true,pbf_id(ID)))):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,">*"),
theory_tuple(ID_T,0,ID_L),
not theory_tuple(ID_T,1,_),
delta(ID_L,PBF_L),
last_id(ID_LAST).