% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % States:
% %     Computes all states for automaton using 
% %     fisher lander closure
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------- Initial state --------------------------
initial_state(F):-
theory_atom(ID_A,ID_O,ID_E),
theory_string(ID_O,"del"),
theory_element(ID_E,ID_T,_),
theory_tuple(ID_T,0,ID),
id_pred_map(ID,F).

%-------------------- Fish lander closure to define states ------
%
% 
%%%%%% Transforming theory predicates into nested predicate
% Formulas
id_pred_map(I,prop(I)) :- prop_id(I).
id_pred_map(I,top) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"&"),
    theory_tuple(T,0,L),
    theory_string(L,"true").
id_pred_map(I,bottom) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"&"),
    theory_tuple(T,0,L),
    theory_string(L,"false").
id_pred_map(I,neg(FL)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"~"),
    theory_tuple(T,0,L),
    id_pred_map(L,FL).
id_pred_map(I,diamond(FL,FR)) :-
    theory_function(I,N,T),
    theory_string(N,".>?"),
    theory_tuple(T,0,L),
    theory_tuple(T,1,R),
    id_pred_map(L,FL), id_pred_map(R,FR).
id_pred_map(I,box(FL,FR)) :-
    theory_function(I,N,T),
    theory_string(N,".>*"),
    theory_tuple(T,0,L),
    theory_tuple(T,1,R),
    id_pred_map(L,FL), id_pred_map(R,FR).
% Paths
id_pred_map(I,check(FL)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"?"),
    theory_tuple(T,0,L),
    id_pred_map(L,FL).
id_pred_map(I,sequence(FL,FR)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,";;"),
    theory_tuple(T,0,L),
    theory_tuple(T,1,R),
    id_pred_map(L,FL), id_pred_map(R,FR).
id_pred_map(I,choice(FL,FR)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"+"),
    theory_tuple(T,0,L),
    theory_tuple(T,1,R),
    id_pred_map(L,FL), id_pred_map(R,FR).
id_pred_map(I,star(FL)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"*"),
    theory_tuple(T,0,L),
    id_pred_map(L,FL).

%Keep only formulas and not paths
formula(prop(ID)) :- id_pred_map(_,prop(ID)).
formula(neg(F)) :- id_pred_map(_,neg(F)).
formula(top) :- id_pred_map(_,top).
formula(bottom) :- id_pred_map(_,bottom).
formula(diamond(FL,FR)) :- id_pred_map(_,diamond(FL,FR)).
formula(box(FL,FR)) :- id_pred_map(_,box(FL,FR)).

%Generate Fisher-Lander closure using nested predicates
closure(F,F):-formula(F).
closure(F,neg(prop(ID))):-closure(F,prop(ID)).

closure(F,diamond(X,Z)):-closure(F,diamond(choice(X,Y),Z)).
closure(F,diamond(Y,Z)):-closure(F,diamond(choice(X,Y),Z)).
closure(F,diamond(X,diamond(Y,Z))):-closure(F,diamond(sequence(X,Y),Z)).
closure(F,diamond(X,diamond(star(X),Z))):-closure(F,diamond(star(X),Z)).
closure(F,Z):-closure(F,diamond(_,Z)).

closure(F,box(X,Z)):-closure(F,box(choice(X,Y),Z)).
closure(F,box(Y,Z)):-closure(F,box(choice(X,Y),Z)).
closure(F,box(X,box(Y,Z))):-closure(F,box(sequence(X,Y),Z)).
closure(F,box(X,box(star(X),Z))):-closure(F,box(star(X),Z)).
closure(F,Z):-closure(F,box(_,Z)).

%State predicate
state(F):-closure(_,F).