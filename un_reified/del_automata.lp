%-------------------- Initial formula --------------------------
state(F):-ldl(F).
initial_state(F):-ldl(F).
%-------------------- Fish lander closure to define states ------
%
%       state(F,ID): The state labeld with formula F with id ID
state(neg(prop(P))):- state(prop(P)).
state(F1):- state(neg(F1)).
state(F1):- state(and(F1,F2)).
state(F2):- state(and(F1,F2)).
state(F1):- state(or(F1,F2)).
state(F2):- state(or(F1,F2)).

state(F):- state(dimond(_,F)).
state(prop(A)):- state(dimond(check(prop(A)),_)).
state(dimond(P1,dimond(P2,F))):- state(dimond(sequence(P1,P2),F)).
state(dimond(P1,F)):- state(dimond(choice(P1,P2),F)).
state(dimond(P2,F)):- state(dimond(choice(P1,P2),F)).
state(dimond(P,dimond(star(P),F))):- state(dimond(star(P),F)).

state(F):- state(box(_,F)).
state(prop(A)):- state(box(check(prop(A)),_)).
state(box(P1,box(P2,F))):- state(box(sequence(P1,P2),F)).
state(box(P1,F)):- state(box(choice(P1,P2),F)).
state(box(P2,F)):- state(box(choice(P1,P2),F)).
state(box(P,box(star(P),F))):- state(box(star(P),F)).

% %-------------------- Positive boolean formulas shape ------------
% %
% %       pbf(id(ID)): Positive boolean formula refering to state with id ID
% %       pbf(true): true (__final accepting state)
% %       pbf(false): false (invalid state)
% %       pbf(and(B1,B2)): B1 and B2 
% %       pbf(or(B1,B2)): B1 or B2 
% %       pbf(decide(V,B1,B2)): if V is true choose B1 if not choose B2 


% %-------------------- Transition function ------------------------
% %
% %       delta(S,B): The delta transition from state S is the
% %                    positive boolean formula B

delta(prop(A),pbf(decide(A,pbf(true),pbf(false)))):- state(prop(A)).
delta(neg(prop(A)),pbf(decide(A,pbf(false),pbf(true)))):- state(neg(prop(A))).
delta(and(F1,F2),pbf(and(BF1,BF2))):- state(and(F1,F2)), 
                              delta(F1,BF1), 
                              delta(F2,BF2).
delta(or(F1,F2),pbf(or(BF1,BF2))):- state(or(F1,F2)), 
                              delta(F1,BF1), 
                              delta(F2,BF2).

delta(dimond(check(F1),F2),pbf(and(BF1,BF2))):- state(dimond(check(F1),F2)), 
                              delta(F1,BF1), 
                              delta(F2,BF2).
delta(dimond(skip,F),pbf(decide(__final,pbf(false),pbf(id(F))))):- state(dimond(skip,F)).
delta(dimond(choice(P1,P2),F),pbf(or(BF1,BF2))):- state(dimond(choice(P1,P2),F)),
                                                    delta(dimond(P1,F),BF1), 
                                                    delta(dimond(P2,F),BF2).
delta(dimond(sequence(P1,P2),F),B):- state(dimond(sequence(P1,P2),F)),
                                     delta(dimond(P1,dimond(P2,F)),B).


is_check(check(P)):-state(dimond(star(check(P)),F)).

delta(dimond(star(check(P)),F),B):- state(dimond(star(check(P)),F)), delta(F,B).

delta(dimond(star(P),F),pbf(or(BF,B))):- state(dimond(star(P),F)),
                             delta(dimond(P,dimond(star(P),F)),B),
                             delta(F,BF),
                             not is_check(P).

delta(box(check(F1),F2),pbf(or(BF1,BF2))):- state(box(check(F1),F2)), 
                                            delta(neg(F1),BF1), 
                                            delta(F2,BF2).

delta(box(skip,F),pbf(decide(__final,pbf(true),pbf(id(F))))):- state(box(skip,F)).
delta(box(choice(P1,P2),F),pbf(and(BF1,BF2))):- state(box(choice(P1,P2),F)),
                                                    delta(box(P1,F),BF1), 
                                                    delta(box(P2,F),BF2).
delta(box(sequence(P1,P2),F),B):- state(box(sequence(P1,P2),F)),
                                     delta(box(P1,box(P2,F)),B).

is_check(check(P)):-state(box(star(check(P)),F)).

delta(box(star(check(P)),F),B):- state(box(star(check(P)),F)), delta(F,B).

delta(box(star(P),F),pbf(and(BF,B))):- state(box(star(P),F)),
                             delta(F,BF),
                             delta(box(P,box(star(P),F)),B),
                             not is_check(P).
