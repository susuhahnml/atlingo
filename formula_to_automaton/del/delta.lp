case_all(Case,S):-delta_all(S,(Case,Opt,A),S').
%-----------------   Prop

delta_all(prop(A),(0,out,A),false):-state_all(prop(A)).
delta_all(prop(A),(1,in,A),true):-state_all(prop(A)).

%-----------------   Neg
delta_all(neg(prop(A)),(0,in,A),false):-state_all(neg(prop(A))).
delta_all(neg(prop(A)),(1,out,A),true):-state_all(neg(prop(A))).

%-----------------   Boolean
delta_all(bottom,(0,in,true),false):-state_all(bottom).
delta_all(top,(0,in,true),true):-state_all(top).

%-----------------   Diamond

%--- diamond(test(F1),F2)

% Conditions from F1
delta_all(diamond(test(F1),F2),((CaseF1,CaseF2),OptF1,A),S') :- 
    state_all(diamond(test(F1),F2)), 
    delta_all(F1,(CaseF1,OptF1,A),S'),
    case_all(CaseF2,F2).

% Conditions from F2
delta_all(diamond(test(F1),F2),((CaseF1,CaseF2),OptF2,A),S') :- 
    state_all(diamond(test(F1),F2)), 
    delta_all(F2,(CaseF2,OptF2,A),S'),
    case_all(CaseF1,F1).

%--- diamond(top,F)

%If last then false
delta_all(diamond(top,F),(0,in,LAST),false) :- 
    state_all(diamond(top,F)),
    last_id(LAST).

%If not last then F
delta_all(diamond(top,F),(1,out,LAST),F) :- 
    state_all(diamond(top,F)),
    last_id(LAST).

%--- diamond(sequence(P1,P2),F)
delta_all(diamond(sequence(P1,P2),F),(Case,Opt,A),S'):-
    state_all(diamond(sequence(P1,P2),F)),
    delta_all(diamond(P1,diamond(P2,F)),(Case,Opt,A),S').

%--- diamond(choice(P1,P2),F)
delta_all(diamond(choice(P1,P2),F),((0,CaseP1),OptP1,A),S'):-
    state_all(diamond(choice(P1,P2),F)),
    delta_all(diamond(P1,F),(CaseP1,OptP1,A),S').

delta_all(diamond(choice(P1,P2),F),((1,CaseP2),OptP2,A),S'):-
    state_all(diamond(choice(P1,P2),F)),
    delta_all(diamond(P2,F),(CaseP2,OptP2,A),S').

%--- diamond(star(P1),F)
is_test(test(P)):-state_all(diamond(star(test(P)),F)).

delta_all(diamond(star(test(P)),F),(Case,Opt,A),S') :- 
    state_all(diamond(star(test(P)),F)), 
    delta_all(F,(Case,Opt,A),S').

delta_all(diamond(star(P),F),((0,CaseP),OptP,A),S') :- 
    state_all(diamond(star(P),F)), 
    not is_test(P),
    delta_all(diamond(P,diamond(star(P),F)),(CaseP,OptP,A),S').

delta_all(diamond(star(P),F),((1,CaseF),OptF,A),S') :- 
    state_all(diamond(star(P),F)), 
    not is_test(P),
    delta_all(F,(CaseF,OptF,A),S').

%-----------------   Box

%--- box(test(F1),F2)

% Conditions from neg F1
delta_all(box(test(F1),F2),((0,CaseF1),Opt,A),S') :- 
    state_all(box(test(F1),F2)),
    delta_all(F1',(CaseF1,Opt,A),S'), 
    nnf(neg(F1),F1').

% Conditions from F2
delta_all(box(test(F1),F2),((1,CaseF2),Opt,A),S') :- 
    state_all(box(test(F1),F2)),
    delta_all(F2,(CaseF2,Opt,A),S').

%--- box(top,F)

%If last then true
delta_all(box(top,F),(0,in,LAST),true) :- 
    state_all(box(top,F)),
    last_id(LAST).

%If not last then F
delta_all(box(top,F),(1,out,LAST),F) :- 
    state_all(box(top,F)),
    last_id(LAST).

%--- box(sequence(P1,P2),F)
delta_all(box(sequence(P1,P2),F),(Case,Opt,A),S'):-
    state_all(box(sequence(P1,P2),F)),
    delta_all(box(P1,box(P2,F)),(Case,Opt,A),S').


%--- box(choice(P1,P2),F)
delta_all(box(choice(P1,P2),F),((CaseP1,CaseP2),OptP1,A),S'):-
    state_all(box(choice(P1,P2),F)),
    delta_all(box(P1,F),(CaseP1,OptP1,A),S'),
    case_all(CaseP2,box(P2,F)).

delta_all(box(choice(P1,P2),F),((CaseP1,CaseP2),OptP2,A),S'):-
    state_all(box(choice(P1,P2),F)),
    delta_all(box(P2,F),(CaseP2,OptP2,A),S'),
    case_all(CaseP1,box(P1,F)).

%--- box(star(P1),F)
is_test(test(P)):-state_all(box(star(test(P)),F)).

delta_all(box(star(test(P)),F),(Case,Opt,A),S') :- 
    state_all(box(star(test(P)),F)), 
    delta_all(F,(Case,Opt,A),S').

delta_all(box(star(P),F),((CaseP,CaseF),OptP,A),S') :- 
    state_all(box(star(P),F)), 
    not is_test(P),
    delta_all(box(P,box(star(P),F)),(CaseP,OptP,A),S'),
    case_all(CaseF,F).

delta_all(box(star(P),F),((CaseP,CaseF),OptF,A),S') :- 
    state_all(box(star(P),F)), 
    not is_test(P),
    delta_all(F,(CaseF,OptF,A),S'),
    case_all(CaseP,box(P,box(star(P),F))).



% -------------------- Clean up top down 

reachable(F):-initial_state(F).
reachable(S'):-delta_all(S,_,S'),reachable(S).

state(S):-state_all(S),reachable(S).
delta(S,C,false):-delta_all(S,C,false), reachable(S).
case(Case,S):-case_all(Case,S),reachable(S).

% -------------------- Reduce A & false to false
false_case(Case,S):-delta_all(S,(Case,Opt,A),false).
delta(S,(Case,Opt,A),S'):-delta_all(S,(Case,Opt,A),S'),not false_case(Case,S), reachable(S).