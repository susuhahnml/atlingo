% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Delta:
% %     Computes transtion for states
% %     delta_full USES PREDICATES 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------   Prop

delta_full(prop(A),(0,in,A),true):-state_full(prop(A)).

%-----------------   Neg
delta_full(neg(prop(A)),(0,out,A),true):-state_full(neg(prop(A))).

%-----------------   Boolean
delta_full(top,(0,in,true),true):-state_full(top).

%-----------------   Diamond

%--- diamond(test(F1),F2)

% Conditions from F1
delta_full(diamond(test(F1),F2),((CaseF1,CaseF2),OptF1,A),S') :- 
    state_full(diamond(test(F1),F2)), 
    delta_full(F1,(CaseF1,OptF1,A),S'),
    delta_full(F2,(CaseF2,_,_),_).

% Conditions from F2
delta_full(diamond(test(F1),F2),((CaseF1,CaseF2),OptF2,A),S') :- 
    state_full(diamond(test(F1),F2)), 
    delta_full(F2,(CaseF2,OptF2,A),S'),
    delta_full(F1,(CaseF1,_,_),_).

%--- diamond(top,F)

%If not last then F
delta_full(diamond(top,F),(1,out,LAST),F) :- 
    state_full(diamond(top,F)),
    prop(LAST,"last").

%--- diamond(sequence(P1,P2),F)
delta_full(diamond(sequence(P1,P2),F),(Case,Opt,A),S'):-
    state_full(diamond(sequence(P1,P2),F)),
    delta_full(diamond(P1,diamond(P2,F)),(Case,Opt,A),S').

%--- diamond(choice(P1,P2),F)
delta_full(diamond(choice(P1,P2),F),((0,CaseP1),OptP1,A),S'):-
    state_full(diamond(choice(P1,P2),F)),
    delta_full(diamond(P1,F),(CaseP1,OptP1,A),S').

delta_full(diamond(choice(P1,P2),F),((1,CaseP2),OptP2,A),S'):-
    state_full(diamond(choice(P1,P2),F)),
    delta_full(diamond(P2,F),(CaseP2,OptP2,A),S').

%--- diamond(star(P1),F)
is_test(test(P)):-state_full(diamond(star(test(P)),F)).

delta_full(diamond(star(test(P)),F),(Case,Opt,A),S') :- 
    state_full(diamond(star(test(P)),F)), 
    delta_full(F,(Case,Opt,A),S').

delta_full(diamond(star(P),F),((0,CaseP),OptP,A),S') :- 
    state_full(diamond(star(P),F)), 
    not is_test(P),
    delta_full(diamond(P,diamond(star(P),F)),(CaseP,OptP,A),S').

delta_full(diamond(star(P),F),((1,CaseF),OptF,A),S') :- 
    state_full(diamond(star(P),F)), 
    not is_test(P),
    delta_full(F,(CaseF,OptF,A),S').

%-----------------   Box

%--- box(test(F1),F2)

% Conditions from neg F1
delta_full(box(test(F1),F2),((0,CaseF1),Opt,A),S') :- 
    state_full(box(test(F1),F2)),
    delta_full(F1',(CaseF1,Opt,A),S'), 
    nnf(neg(F1),F1').

% Conditions from F2
delta_full(box(test(F1),F2),((1,CaseF2),Opt,A),S') :- 
    state_full(box(test(F1),F2)),
    delta_full(F2,(CaseF2,Opt,A),S').

%--- box(top,F)

%If last then true
delta_full(box(top,F),(0,in,LAST),true) :- 
    state_full(box(top,F)),
    prop(LAST,"last").

%If not last then F
delta_full(box(top,F),(1,out,LAST),F) :- 
    state_full(box(top,F)),
    prop(LAST,"last").

%--- box(sequence(P1,P2),F)
delta_full(box(sequence(P1,P2),F),(Case,Opt,A),S'):-
    state_full(box(sequence(P1,P2),F)),
    delta_full(box(P1,box(P2,F)),(Case,Opt,A),S').


%--- box(choice(P1,P2),F)
delta_full(box(choice(P1,P2),F),((CaseP1,CaseP2),OptP1,A),S'):-
    state_full(box(choice(P1,P2),F)),
    delta_full(box(P1,F),(CaseP1,OptP1,A),S'),
    delta_full(box(P2,F),(CaseP2,_,_),_).

delta_full(box(choice(P1,P2),F),((CaseP1,CaseP2),OptP2,A),S'):-
    state_full(box(choice(P1,P2),F)),
    delta_full(box(P2,F),(CaseP2,OptP2,A),S'),
    delta_full(box(P1,F),(CaseP1,_,_),_).

%--- box(star(P1),F)
is_test(test(P)):-state_full(box(star(test(P)),F)).

delta_full(box(star(test(P)),F),(Case,Opt,A),S') :- 
    state_full(box(star(test(P)),F)), 
    delta_full(F,(Case,Opt,A),S').

delta_full(box(star(P),F),((CaseP,CaseF),OptP,A),S') :- 
    state_full(box(star(P),F)), 
    not is_test(P),
    delta_full(box(P,box(star(P),F)),(CaseP,OptP,A),S'),
    delta_full(F,(CaseF,_,_),_).

delta_full(box(star(P),F),((CaseP,CaseF),OptF,A),S') :- 
    state_full(box(star(P),F)), 
    not is_test(P),
    delta_full(F,(CaseF,OptF,A),S'),
    delta_full(box(P,box(star(P),F)),(CaseP,_,_),_).
