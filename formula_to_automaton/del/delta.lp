% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Delta:
% %     Defines the translation function
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
