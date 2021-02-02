case_full(Case,S):-delta_full(Case,Opt,A,S,S').
%-----------------   Prop

delta_full(0,out,A,prop(A),false):-state_all(prop(A)).
delta_full(1,in,A,prop(A),true):-state_all(prop(A)).

%-----------------   Neg
delta_full(0,in,A,neg(prop(A)),false):-state_all(neg(prop(A))).
delta_full(1,out,A,neg(prop(A)),true):-state_all(neg(prop(A))).

%-----------------   Boolean
delta_full(0,in,true,bottom,false):-state_all(bottom).
delta_full(0,in,true,top,true):-state_all(top).

%-----------------   Diamond

%--- diamond(test(F1),F2)

% Conditions from F1
delta_full((CaseF1,CaseF2),OptF1,A,diamond(test(F1),F2),S') :- 
    state_all(diamond(test(F1),F2)), 
    delta_full(CaseF1,OptF1,A,F1,S'),
    case_full(CaseF2,F2).

% Conditions from F2
delta_full((CaseF1,CaseF2),OptF2,A,diamond(test(F1),F2),S') :- 
    state_all(diamond(test(F1),F2)), 
    delta_full(CaseF2,OptF2,A,F2,S'),
    case_full(CaseF1,F1).

%--- diamond(top,F)

%If last then false
delta_full(0,in,LAST,diamond(top,F),false) :- 
    state_all(diamond(top,F)),
    last_id(LAST).

%If not last then F
delta_full(1,out,LAST,diamond(top,F),F) :- 
    state_all(diamond(top,F)),
    last_id(LAST).

%--- diamond(sequence(P1,P2),F)
delta_full(Case,Opt,A,diamond(sequence(P1,P2),F),S'):-
    state_all(diamond(sequence(P1,P2),F)),
    delta_full(Case,Opt,A,diamond(P1,diamond(P2,F)),S').

%--- diamond(choice(P1,P2),F)
delta_full((0,CaseP1),OptP1,A,diamond(choice(P1,P2),F),S'):-
    state_all(diamond(choice(P1,P2),F)),
    delta_full(CaseP1,OptP1,A,diamond(P1,F),S').

delta_full((1,CaseP2),OptP2,A,diamond(choice(P1,P2),F),S'):-
    state_all(diamond(choice(P1,P2),F)),
    delta_full(CaseP2,OptP2,A,diamond(P2,F),S').

%--- diamond(star(P1),F)
is_test(test(P)):-state_all(diamond(star(test(P)),F)).

delta_full(Case,Opt,A,diamond(star(test(P)),F),S') :- 
    state_all(diamond(star(test(P)),F)), 
    delta_full(Case,Opt,A,F,S').

delta_full((0,CaseP),OptP,A,diamond(star(P),F),S') :- 
    state_all(diamond(star(P),F)), 
    not is_test(P),
    delta_full(CaseP,OptP,A,diamond(P,diamond(star(P),F)),S').

delta_full((1,CaseF),OptF,A,diamond(star(P),F),S') :- 
    state_all(diamond(star(P),F)), 
    not is_test(P),
    delta_full(CaseF,OptF,A,F,S').

%-----------------   Box

%--- box(test(F1),F2)

% Conditions from neg F1
delta_full((0,CaseF1),Opt,A,box(test(F1),F2),S') :- 
    state_all(box(test(F1),F2)),
    delta_full(CaseF1,Opt,A,F1',S'), 
    nnf(neg(F1),F1').

% Conditions from F2
delta_full((1,CaseF2),Opt,A,box(test(F1),F2),S') :- 
    state_all(box(test(F1),F2)),
    delta_full(CaseF2,Opt,A,F2,S').

%--- box(top,F)

%If last then true
delta_full(0,in,LAST,box(top,F),true) :- 
    state_all(box(top,F)),
    last_id(LAST).

%If not last then F
delta_full(1,out,LAST,box(top,F),F) :- 
    state_all(box(top,F)),
    last_id(LAST).

%--- box(sequence(P1,P2),F)
delta_full(Case,Opt,A,box(sequence(P1,P2),F),S'):-
    state_all(box(sequence(P1,P2),F)),
    delta_full(Case,Opt,A,box(P1,box(P2,F)),S').


%--- box(choice(P1,P2),F)
delta_full((CaseP1,CaseP2),OptP1,A,box(choice(P1,P2),F),S'):-
    state_all(box(choice(P1,P2),F)),
    delta_full(CaseP1,OptP1,A,box(P1,F),S'),
    case_full(CaseP2,box(P2,F)).

delta_full((CaseP1,CaseP2),OptP2,A,box(choice(P1,P2),F),S'):-
    state_all(box(choice(P1,P2),F)),
    delta_full(CaseP2,OptP2,A,box(P2,F),S'),
    case_full(CaseP1,box(P1,F)).

%--- box(star(P1),F)
is_test(test(P)):-state_all(box(star(test(P)),F)).

delta_full(Case,Opt,A,box(star(test(P)),F),S') :- 
    state_all(box(star(test(P)),F)), 
    delta_full(Case,Opt,A,F,S').

delta_full((CaseP,CaseF),OptP,A,box(star(P),F),S') :- 
    state_all(box(star(P),F)), 
    not is_test(P),
    delta_full(CaseP,OptP,A,box(P,box(star(P),F)),S'),
    case_full(CaseF,F).

delta_full((CaseP,CaseF),OptF,A,box(star(P),F),S') :- 
    state_all(box(star(P),F)), 
    not is_test(P),
    delta_full(CaseF,OptF,A,F,S'),
    case_full(CaseP,box(P,box(star(P),F))).



% -------------------- Clean up top down 

reachable(F):-initial_state(F).
unfold_reachable(BF):-delta_full(S,BF), reachable(S).

reachable(S'):-delta_full(_,_,_,S,S'),reachable(S).

state(S):-state_all(S),reachable(S).
delta(Case,Opt,A,S,false):-delta_full(Case,Opt,A,S,false), reachable(S).
case(Case,S):-case_full(Case,S),reachable(S).

% -------------------- Reduce A & false to false
false_case(Case,S):-delta_full(Case,Opt,A,S,false).
delta(Case,Opt,A,S,S'):-delta_full(Case,Opt,A,S,S'),not false_case(Case,S), reachable(S).