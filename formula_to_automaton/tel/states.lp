% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % States:
% %     Computes all states for automaton using 
% %     fisher lander closure and negation normal form
% %     state_full USES PREDICATES 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------- Initial state --------------------------
initial_state_full(F) :- theory_atom(ID_A,ID_O,ID_E),
                    theory_string(ID_O,"tel"),
                    theory_element(ID_E,ID_T,_),
                    theory_tuple(ID_T,0,ID),
                    theory_id_to_predicate(ID,F).

%-------------------- Fish lander closure to define states ------

%%%%%% Transforming theory ids into nested predicate

% Proposition
theory_id_to_predicate(ID,prop(ID)) :- 
        prop_id(ID).

% Top
theory_id_to_predicate(ID,top) :-                                                        
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,"&"),
        theory_tuple(ID_T,0,ID_L),
        theory_string(ID_L,"true").

% Bottom
theory_id_to_predicate(ID,bottom) :- 
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,"&"),
        theory_tuple(ID_T,0,ID_L),
        theory_string(ID_L,"false").

% Negation
theory_id_to_predicate(ID,neg(FL)) :-
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,"~"),
        theory_tuple(ID_T,0,ID_L),
        theory_id_to_predicate(ID_L,FL).

% Next >
theory_id_to_predicate(ID,next(FL)) :-
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,">"),
        theory_tuple(ID_T,0,ID_L),
        theory_id_to_predicate(ID_L,FL).

% Weak Next >:
theory_id_to_predicate(ID,wnext(FL)) :-
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,">:"),
        theory_tuple(ID_T,0,ID_L),
        theory_id_to_predicate(ID_L,FL).

% And
theory_id_to_predicate(ID,and(FL,FR)) :-
        theory_function(ID,ID_O,ID_T),
        theory_string(ID_O,"&"),
        theory_tuple(ID_T,0,ID_L),
        theory_tuple(ID_T,1,ID_R),
        theory_id_to_predicate(ID_L,FL), 
        theory_id_to_predicate(ID_R,FR).

% Or
theory_id_to_predicate(ID,or(FL,FR)) :-
        theory_function(ID,ID_O,ID_T),
        theory_string(ID_O,"|"),
        theory_tuple(ID_T,0,ID_L),
        theory_tuple(ID_T,1,ID_R),
        theory_id_to_predicate(ID_L,FL), 
        theory_id_to_predicate(ID_R,FR).

% And
theory_id_to_predicate(ID,and(FL,FR)) :-
        theory_function(ID,ID_O,ID_T),
        theory_string(ID_O,"&"),
        theory_tuple(ID_T,0,ID_L),
        theory_tuple(ID_T,1,ID_R),
        theory_id_to_predicate(ID_L,FL), 
        theory_id_to_predicate(ID_R,FR).

% Until >?
theory_id_to_predicate(ID,until(FL,FR)) :-
        theory_function(ID,ID_O,ID_T),
        theory_string(ID_O,">?"),
        theory_tuple(ID_T,0,ID_L),
        theory_tuple(ID_T,1,ID_R),
        theory_id_to_predicate(ID_L,FL), 
        theory_id_to_predicate(ID_R,FR).

% Release >*
theory_id_to_predicate(ID,release(FL,FR)) :-
        theory_function(ID,ID_O,ID_T),
        theory_string(ID_O,">*"),
        theory_tuple(ID_T,0,ID_L),
        theory_tuple(ID_T,1,ID_R),
        theory_id_to_predicate(ID_L,FL), 
        theory_id_to_predicate(ID_R,FR).

% Eventually >?
theory_id_to_predicate(ID,eventually(FL)) :-
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,">?"),
        theory_tuple(ID_T,0,ID_L),
        not theory_tuple(ID_T,1,_),
        theory_id_to_predicate(ID_L,FL).

% Always >*
theory_id_to_predicate(ID,always(FL)) :-
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,">*"),
        theory_tuple(ID_T,0,ID_L),
        not theory_tuple(ID_T,1,_),
        theory_id_to_predicate(ID_L,FL).


%State predicate
state_full(X) :- theory_id_to_predicate(ID,X).
