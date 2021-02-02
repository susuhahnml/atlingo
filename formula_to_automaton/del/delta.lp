case(Case,S):-delta(Case,Opt,A,S,S').
%-----------------   Prop

delta(0,out,A,prop(A),false):-state(prop(A)).
delta(1,in,A,prop(A),true):-state(prop(A)).

%-----------------   Neg
delta(0,in,A,neg(prop(A)),false):-state(neg(prop(A))).
delta(1,out,A,neg(prop(A)),true):-state(neg(prop(A))).

%-----------------   Boolean
delta(0,in,true,bottom,false):-state(bottom).
delta(0,in,true,top,true):-state(top).

%-----------------   Diamond

%--- diamond(test(F1),F2)

% Conditions from F1
delta((CaseF1,CaseF2),OptF1,A,diamond(test(F1),F2),S') :- 
    state(diamond(test(F1),F2)), 
    delta(CaseF1,OptF1,A,F1,S'),
    case(CaseF2,F2).

% Conditions from F2
delta((CaseF1,CaseF2),OptF2,A,diamond(test(F1),F2),S') :- 
    state(diamond(test(F1),F2)), 
    delta(CaseF2,OptF2,A,F2,S'),
    case(CaseF1,F1).

%--- diamond(top,F)

%If last then false
delta(0,in,LAST,diamond(top,F),false) :- 
    state(diamond(top,F)),
    last_id(LAST).

%If not last then F
delta(1,out,LAST,diamond(top,F),F) :- 
    state(diamond(top,F)),
    last_id(LAST).

%--- diamond(sequence(P1,P2),F)
delta(Case,Opt,A,diamond(sequence(P1,P2),F),S'):-
    state(diamond(sequence(P1,P2),F)),
    delta(Case,Opt,A,diamond(P1,diamond(P2,F)),S').

%--- diamond(choice(P1,P2),F)
delta((0,CaseP1),OptP1,A,diamond(choice(P1,P2),F),S'):-
    state(diamond(choice(P1,P2),F)),
    delta(CaseP1,OptP1,A,diamond(P1,F),S').

delta((1,CaseP2),OptP2,A,diamond(choice(P1,P2),F),S'):-
    state(diamond(choice(P1,P2),F)),
    delta(CaseP2,OptP2,A,diamond(P2,F),S').

%--- diamond(star(P1),F)
is_test(test(P)):-state(diamond(star(test(P)),F)).

delta(Case,Opt,A,diamond(star(test(P)),F),S') :- 
    state(diamond(star(test(P)),F)), 
    delta(Case,Opt,A,F,S').

delta((0,CaseP),OptP,A,diamond(star(P),F),S') :- 
    state(diamond(star(P),F)), 
    not is_test(P),
    delta(CaseP,OptP,A,diamond(P,diamond(star(P),F)),S').

delta((1,CaseF),OptF,A,diamond(star(P),F),S') :- 
    state(diamond(star(P),F)), 
    not is_test(P),
    delta(CaseF,OptF,A,F,S').

%-----------------   Box

%--- box(test(F1),F2)

% Conditions from neg F1
delta((0,CaseF1),Opt,A,box(test(F1),F2),S') :- 
    state(box(test(F1),F2)),
    delta(CaseF1,Opt,A,F1',S'), 
    nnf(neg(F1),F1').

% Conditions from F2
delta((1,CaseF2),Opt,A,box(test(F1),F2),S') :- 
    state(box(test(F1),F2)),
    delta(CaseF2,Opt,A,F2,S').

%--- box(top,F)

%If last then true
delta(0,in,LAST,box(top,F),true) :- 
    state(box(top,F)),
    last_id(LAST).

%If not last then F
delta(1,out,LAST,box(top,F),F) :- 
    state(box(top,F)),
    last_id(LAST).

%--- box(sequence(P1,P2),F)
delta(Case,Opt,A,box(sequence(P1,P2),F),S'):-
    state(box(sequence(P1,P2),F)),
    delta(Case,Opt,A,box(P1,box(P2,F)),S').


%--- box(choice(P1,P2),F)
delta((CaseP1,CaseP2),OptP1,A,box(choice(P1,P2),F),S'):-
    state(box(choice(P1,P2),F)),
    delta(CaseP1,OptP1,A,box(P1,F),S'),
    case(CaseP2,box(P2,F)).

delta((CaseP1,CaseP2),OptP2,A,box(choice(P1,P2),F),S'):-
    state(box(choice(P1,P2),F)),
    delta(CaseP2,OptP2,A,box(P2,F),S'),
    case(CaseP1,box(P1,F)).

%--- box(star(P1),F)
is_test(test(P)):-state(box(star(test(P)),F)).

delta(Case,Opt,A,box(star(test(P)),F),S') :- 
    state(box(star(test(P)),F)), 
    delta(Case,Opt,A,F,S').

delta((CaseP,CaseF),OptP,A,box(star(P),F),S') :- 
    state(box(star(P),F)), 
    not is_test(P),
    delta(CaseP,OptP,A,box(P,box(star(P),F)),S'),
    case(CaseF,F).

delta((CaseP,CaseF),OptF,A,box(star(P),F),S') :- 
    state(box(star(P),F)), 
    not is_test(P),
    delta(CaseF,OptF,A,F,S'),
    case(CaseP,box(P,box(star(P),F))).