% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % States:
% %     Computes all states for automaton using 
% %     fisher lander closure
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------- Initial state --------------------------
initial_state(F) :- theory_atom(ID_A,ID_O,ID_E),
                    theory_string(ID_O,"del"),
                    theory_element(ID_E,ID_T,_),
                    theory_tuple(ID_T,0,ID),
                    map_id_to_predicate(ID,F).

%-------------------- Fish lander closure to define states ------
%
% 
%%%%%% Transforming theory ids into nested predicate

%%%%%%%%%% Formulas

% Proposition
map_id_to_predicate(ID,prop(ID)) :- 
        prop_id(ID).

% Top
map_id_to_predicate(ID,top) :-                                                        
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,"&"),
        theory_tuple(ID_T,0,ID_L),
        theory_string(ID_L,"true").

% Bottom
map_id_to_predicate(ID,bottom) :-                                                        
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,"&"),
        theory_tuple(ID_T,0,ID_L),
        theory_string(ID_L,"false").

% Negation
map_id_to_predicate(ID,neg(FL)) :-                                                        
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,"~"),
        theory_tuple(ID_T,0,ID_L),
        map_id_to_predicate(ID_L,FL).

% Diamond
map_id_to_predicate(ID,diamond(FL,FR)) :-
        theory_function(ID,ID_O,ID_T),
        theory_string(ID_O,".>?"),
        theory_tuple(ID_T,0,ID_L),
        theory_tuple(ID_T,1,ID_R),
        map_id_to_predicate(ID_L,FL), 
        map_id_to_predicate(ID_R,FR).

% Box
map_id_to_predicate(ID,box(FL,FR)) :-
        theory_function(ID,ID_O,ID_T),
        theory_string(ID_O,".>*"),
        theory_tuple(ID_T,0,ID_L),
        theory_tuple(ID_T,1,ID_R),
        map_id_to_predicate(ID_L,FL), 
        map_id_to_predicate(ID_R,FR).

%%%%%%%%%% Paths

% Test
map_id_to_predicate(ID,test(FL)) :-                                                        
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,"?"),
        theory_tuple(ID_T,0,ID_L),
        map_id_to_predicate(ID_L,FL).

% Sequence
map_id_to_predicate(ID,sequence(FL,FR)) :-                                                        
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,";;"),
        theory_tuple(ID_T,0,ID_L),
        theory_tuple(ID_T,1,ID_R),
        map_id_to_predicate(ID_L,FL), 
        map_id_to_predicate(ID_R,FR).

% Choice
map_id_to_predicate(ID,choice(FL,FR)) :-                                                        
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,"+"),
        theory_tuple(ID_T,0,ID_L),
        theory_tuple(ID_T,1,ID_R),
        map_id_to_predicate(ID_L,FL), 
        map_id_to_predicate(ID_R,FR).

% Star
map_id_to_predicate(ID,star(FL)) :-                                                        
        theory_function(ID,ID_O,ID_T), 
        theory_string(ID_O,"*"),
        theory_tuple(ID_T,0,ID_L),
        map_id_to_predicate(ID_L,FL).

%Keep only formulas and not paths

dynamic_formula(prop(ID)) :- map_id_to_predicate(_,prop(ID)).
dynamic_formula(neg(F)) :- map_id_to_predicate(_,neg(F)).
dynamic_formula(top) :- map_id_to_predicate(_,top).
dynamic_formula(bottom) :- map_id_to_predicate(_,bottom).
dynamic_formula(diamond(FL,FR)) :- map_id_to_predicate(_,diamond(FL,FR)).
dynamic_formula(box(FL,FR)) :- map_id_to_predicate(_,box(FL,FR)).

%Generate Fisher-Lander closure using nested predicates
closure(F) :- dynamic_formula(F).

closure(X) :- closure(neg(X)).
closure(neg(prop(ID))) :- closure(prop(ID)).
closure(neg(bottom)) :- closure(bottom).
closure(neg(top)) :- closure(top).
closure(neg(diamond(X,Z))) :- closure(diamond(X,Z)).
closure(neg(box(X,Z))) :- closure(box(X,Z)).

closure(diamond(X,Z)) :- closure(diamond(choice(X,Y),Z)).
closure(diamond(Y,Z)) :- closure(diamond(choice(X,Y),Z)).
closure(diamond(X,diamond(Y,Z))) :- closure(diamond(sequence(X,Y),Z)).
closure(diamond(X,diamond(star(X),Z))) :- closure(diamond(star(X),Z)).
closure(Z) :- closure(diamond(_,Z)).

closure(box(X,Z)) :- closure(box(choice(X,Y),Z)).
closure(box(Y,Z)) :- closure(box(choice(X,Y),Z)).
closure(box(X,box(Y,Z))) :- closure(box(sequence(X,Y),Z)).
closure(box(X,box(star(X),Z))) :- closure(box(star(X),Z)).
closure(Z) :- closure(box(_,Z)).

%Negation normal form for formulas in the closure
nnf(neg(neg(X)),X):-closure(neg(X)).
nnf(neg(bottom),top).
nnf(neg(top),bottom).
nnf(neg(prop(ID)),neg(prop(ID))) :- closure(neg(prop(ID))).
nnf(neg(diamond(X,Z)),box(X,Z')) :- closure(neg(diamond(X,Z))),nnf(neg(Z),Z').
nnf(neg(box(X,Z)),diamond(X,Z')) :- closure(neg(box(X,Z))),nnf(neg(Z),Z').

nnf(top,top).
nnf(botom,bottom).
nnf(prop(ID),prop(ID)) :- closure(prop(ID)).
nnf(diamond(X,Z),diamond(X,Z)) :- closure(diamond(X,Z)).
nnf(box(X,Z),box(X,Z)) :- closure(box(X,Z)).





%State predicate
state_all(X') :- closure(X), nnf(X,X').

#show map_id_to_predicate/2.
#show prop_id/1.
% #show pos_prop_id/1.