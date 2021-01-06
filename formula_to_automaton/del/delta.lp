% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Delta:
% %     Defines the translation function
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %-------------------- Positive boolean formulas shape ------------
% %
% %       pbf_state(ID): Positive boolean formula refering to state with id ID
% %       pbf_true: true (__last accepting state)
% %       pbf_false: false (invalid state)
% %       pbf_and(B1,B2): B1 and B2 
% %       pbf_or(B1,B2): B1 or B2 
% %       pbf_if(V,B1,B2): if V is true choose B1 if not choose B2 


% %-------------------- Transition function ------------------------
% %
% %       delta(S,B): The delta transition from state S is the
% %                    positive boolean formula B

%Prop
delta(prop(A),pbf_if(A,pbf_true,pbf_false)) :- 
    state(prop(A)).

%Neg
delta(neg(prop(A)),pbf_if(A,pbf_false,pbf_true)) :- 
    state(neg(prop(A))).

%Boolean
delta(top,pbf_true) :- 
    state(top).

delta(bottom,pbf_false) :- 
    state(top).

%Diamond
delta(diamond(test(F1),F2),pbf_and(BF1,BF2)) :- 
    state(diamond(test(F1),F2)), 
    delta(F1,BF1), 
    delta(F2,BF2).

delta(diamond(top,F),pbf_if(LAST,pbf_false,pbf_state(F))) :- 
    state(diamond(top,F)),
    last_id(LAST).

delta(diamond(choice(P1,P2),F),pbf_or(BF1,BF2)) :- 
    state(diamond(choice(P1,P2),F)),
    delta(diamond(P1,F),BF1), 
    delta(diamond(P2,F),BF2).

delta(diamond(sequence(P1,P2),F),B) :- 
    state(diamond(sequence(P1,P2),F)),
    delta(diamond(P1,diamond(P2,F)),B).

delta(diamond(star(test(P)),F),B) :- 
    state(diamond(star(test(P)),F)), 
    delta(F,B).

is_test(test(P)):-state(diamond(star(test(P)),F)).
delta(diamond(star(P),F),pbf_or(BF,B)) :- 
    state(diamond(star(P),F)),
    delta(diamond(P,diamond(star(P),F)),B),
    delta(F,BF),
    not is_test(P).


%Box
delta(box(test(F1),F2),pbf_or(BF1,BF2)) :- 
    state(box(test(F1),F2)), 
    delta(F1',BF1), 
    delta(F2,BF2),
    nnf(neg(F1),F1').

delta(box(top,F),pbf_if(LAST,pbf_true,pbf_state(F))) :- 
    state(box(top,F)),
    last_id(LAST).

delta(box(choice(P1,P2),F),pbf_and(BF1,BF2)) :- 
    state(box(choice(P1,P2),F)),
    delta(box(P1,F),BF1), 
    delta(box(P2,F),BF2).

delta(box(sequence(P1,P2),F),B) :- 
    state(box(sequence(P1,P2),F)),
    delta(box(P1,box(P2,F)),B).

delta(box(star(test(P)),F),B) :- 
    state(box(star(test(P)),F)), 
    delta(F,B).

is_test(test(P)):-state(box(star(test(P)),F)).

delta(box(star(P),F),pbf_and(BF,B)) :- 
    state(box(star(P),F)),
    delta(box(P,box(star(P),F)),B),
    delta(F,BF),
    not is_test(P).
