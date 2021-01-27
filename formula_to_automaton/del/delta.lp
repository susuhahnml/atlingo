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
% %       delta_all(S,B): The delta transition from state S is the
% %                    positive boolean formula B

%Prop
delta_all(prop(A),pbf_if(A,pbf_true,pbf_false)) :- 
    state_all(prop(A)).

%Neg
delta_all(neg(prop(A)),pbf_if(A,pbf_false,pbf_true)) :- 
    state_all(neg(prop(A))).

%Boolean
delta_all(top,pbf_true) :- 
    state_all(top).

delta_all(bottom,pbf_false) :- 
    state_all(top).

%Diamond
delta_all(diamond(test(F1),F2),pbf_and(BF1,BF2)) :- 
    state_all(diamond(test(F1),F2)), 
    delta_all(F1,BF1), 
    delta_all(F2,BF2).

delta_all(diamond(top,F),pbf_if(LAST,pbf_false,pbf_state(F))) :- 
    state_all(diamond(top,F)),
    last_id(LAST).

delta_all(diamond(choice(P1,P2),F),pbf_or(BF1,BF2)) :- 
    state_all(diamond(choice(P1,P2),F)),
    delta_all(diamond(P1,F),BF1), 
    delta_all(diamond(P2,F),BF2).

delta_all(diamond(sequence(P1,P2),F),B) :- 
    state_all(diamond(sequence(P1,P2),F)),
    delta_all(diamond(P1,diamond(P2,F)),B).

delta_all(diamond(star(test(P)),F),B) :- 
    state_all(diamond(star(test(P)),F)), 
    delta_all(F,B).

is_test(test(P)):-state_all(diamond(star(test(P)),F)).
delta_all(diamond(star(P),F),pbf_or(BF,B)) :- 
    state_all(diamond(star(P),F)),
    delta_all(diamond(P,diamond(star(P),F)),B),
    delta_all(F,BF),
    not is_test(P).


%Box
delta_all(box(test(F1),F2),pbf_or(BF1,BF2)) :- 
    state_all(box(test(F1),F2)), 
    delta_all(F1',BF1), 
    delta_all(F2,BF2),
    nnf(neg(F1),F1').

delta_all(box(top,F),pbf_if(LAST,pbf_true,pbf_state(F))) :- 
    state_all(box(top,F)),
    last_id(LAST).

delta_all(box(choice(P1,P2),F),pbf_and(BF1,BF2)) :- 
    state_all(box(choice(P1,P2),F)),
    delta_all(box(P1,F),BF1), 
    delta_all(box(P2,F),BF2).

delta_all(box(sequence(P1,P2),F),B) :- 
    state_all(box(sequence(P1,P2),F)),
    delta_all(box(P1,box(P2,F)),B).

delta_all(box(star(test(P)),F),B) :- 
    state_all(box(star(test(P)),F)), 
    delta_all(F,B).

is_test(test(P)):-state_all(box(star(test(P)),F)).

delta_all(box(star(P),F),pbf_and(BF,B)) :- 
    state_all(box(star(P),F)),
    delta_all(box(P,box(star(P),F)),B),
    delta_all(F,BF),
    not is_test(P).
