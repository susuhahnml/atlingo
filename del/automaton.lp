
%-------------------- Initial state --------------------------
initial_state(F):-
theory_atom(ID_A,ID_O,ID_E),
theory_string(ID_O,"del"),
theory_element(ID_E,ID_T,_),
theory_tuple(ID_T,0,ID),
f(ID,F).
%-------------------- Fish lander closure to define states ------
%
% 
operator(";;").operator("+"). %Binary paths
operator("?").operator("*").operator("~").operator("&"). %Unary operators
operator(".>?"). operator(".>*").

% Used in other files
last_id(ID):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,"last").

prop_id(I) :- theory_function(I,N,_), theory_string(N,Name), not operator(Name).

%%%%%% Transforming theory predicates into nested predicate
% Formulas
f(I,prop(I)) :- prop_id(I).
f(I,top) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"&"),
    theory_tuple(T,0,L),
    theory_string(L,"true").
f(I,bottom) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"&"),
    theory_tuple(T,0,L),
    theory_string(L,"false").
f(I,neg(FL)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"~"),
    theory_tuple(T,0,L),
    f(L,FL).
f(I,diamond(FL,FR)) :-
    theory_function(I,N,T),
    theory_string(N,".>?"),
    theory_tuple(T,0,L),
    theory_tuple(T,1,R),
    f(L,FL), f(R,FR).
f(I,box(FL,FR)) :-
    theory_function(I,N,T),
    theory_string(N,".>*"),
    theory_tuple(T,0,L),
    theory_tuple(T,1,R),
    f(L,FL), f(R,FR).
% Paths
f(I,check(FL)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"?"),
    theory_tuple(T,0,L),
    f(L,FL).
f(I,sequence(FL,FR)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,";;"),
    theory_tuple(T,0,L),
    theory_tuple(T,1,R),
    f(L,FL), f(R,FR).
f(I,choice(FL,FR)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"+"),
    theory_tuple(T,0,L),
    theory_tuple(T,1,R),
    f(L,FL), f(R,FR).
f(I,star(FL)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"*"),
    theory_tuple(T,0,L),
    f(L,FL).

%Keep only formulas and not paths
formula(prop(ID)) :- f(_,prop(ID)).
formula(neg(F)) :- f(_,neg(F)).
formula(top) :- f(_,top).
formula(bottom) :- f(_,bottom).
formula(diamond(FL,FR)) :- f(_,diamond(FL,FR)).
formula(box(FL,FR)) :- f(_,box(FL,FR)).

%Generate Fisher-Lander closure using nested predicates
subformula(F,F):-formula(F).
subformula(F,neg(prop(ID))):-subformula(F,prop(ID)).

subformula(F,diamond(X,Z)):-subformula(F,diamond(choice(X,Y),Z)).
subformula(F,diamond(Y,Z)):-subformula(F,diamond(choice(X,Y),Z)).
subformula(F,diamond(X,diamond(Y,Z))):-subformula(F,diamond(sequence(X,Y),Z)).
subformula(F,diamond(X,diamond(star(X),Z))):-subformula(F,diamond(star(X),Z)).
subformula(F,Z):-subformula(F,diamond(_,Z)).

subformula(F,box(X,Z)):-subformula(F,box(choice(X,Y),Z)).
subformula(F,box(Y,Z)):-subformula(F,box(choice(X,Y),Z)).
subformula(F,box(X,box(Y,Z))):-subformula(F,box(sequence(X,Y),Z)).
subformula(F,box(X,box(star(X),Z))):-subformula(F,box(star(X),Z)).
subformula(F,Z):-subformula(F,box(_,Z)).

%State predicate
state(F):-subformula(_,F).


% %-------------------- Transition function ------------------------
% %
% %       delta(S,B): The delta transition from state S is the
% %                    positive boolean formula B

%Prop
delta(prop(A),pbf_decide(A,pbf_true,pbf_false)):- 
    state(prop(A)).
%Neg
delta(neg(prop(A)),pbf_decide(A,pbf_false,pbf_true)):- 
    state(neg(prop(A))).
%Boolean
delta(top,pbf_true):- 
    state(top).

delta(bottom,pbf_false):- 
    state(top).

%And, Or
% delta(and(F1,F2),pbf_and(BF1,BF2)):- 
%     state(and(F1,F2)), 
%     delta(F1,BF1), 
%     delta(F2,BF2).

% delta(or(F1,F2),pbf_or(BF1,BF2)):- 
%     state(or(F1,F2)), 
%     delta(F1,BF1), 
%     delta(F2,BF2).

%Diamond
delta(diamond(check(F1),F2),pbf_and(BF1,BF2)):- 
    state(diamond(check(F1),F2)), 
    delta(F1,BF1), 
    delta(F2,BF2).
delta(diamond(top,F),pbf_decide(LAST,pbf_false,pbf_id(F))):- 
    state(diamond(top,F)),
    last_id(LAST).
delta(diamond(choice(P1,P2),F),pbf_or(BF1,BF2)):- 
    state(diamond(choice(P1,P2),F)),
    delta(diamond(P1,F),BF1), 
    delta(diamond(P2,F),BF2).
delta(diamond(sequence(P1,P2),F),B):- 
    state(diamond(sequence(P1,P2),F)),
    delta(diamond(P1,diamond(P2,F)),B).
delta(diamond(star(check(P)),F),B):- 
    state(diamond(star(check(P)),F)), 
    delta(F,B).
is_check(check(P)):-state(diamond(star(check(P)),F)).
delta(diamond(star(P),F),pbf_or(BF,B)):- 
    state(diamond(star(P),F)),
    delta(diamond(P,diamond(star(P),F)),B),
    delta(F,BF),
    not is_check(P).


%Box
delta(box(check(F1),F2),pbf_or(BF1,BF2)):- 
    state(box(check(F1),F2)), 
    delta(neg(F1),BF1), 
    delta(F2,BF2).
delta(box(top,F),pbf_decide(LAST,pbf_true,pbf_id(F))):- 
    state(box(top,F)),
    last_id(LAST).
delta(box(choice(P1,P2),F),pbf_and(BF1,BF2)):- 
    state(box(choice(P1,P2),F)),
    delta(box(P1,F),BF1), 
    delta(box(P2,F),BF2).
delta(box(sequence(P1,P2),F),B):- 
    state(box(sequence(P1,P2),F)),
    delta(box(P1,box(P2,F)),B).
delta(box(star(check(P)),F),B):- 
    state(box(star(check(P)),F)), 
    delta(F,B).
is_check(check(P)):-state(box(star(check(P)),F)).
delta(box(star(P),F),pbf_and(BF,B)):- 
    state(box(star(P),F)),
    delta(box(P,box(star(P),F)),B),
    delta(F,BF),
    not is_check(P).
