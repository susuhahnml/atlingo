%-----------------   Prop

delta_all(prop(A),(0,in,A),true):-state_all(prop(A)).

%-----------------   Neg
delta_all(neg(prop(A)),(0,out,A),true):-state_all(neg(prop(A))).

%-----------------   Boolean
delta_all(top,(0,in,true),true):-state_all(top).

%-----------------   Diamond

%--- diamond(test(F1),F2)

% Conditions from F1
delta_all(diamond(test(F1),F2),((CaseF1,CaseF2),OptF1,A),S') :- 
    state_all(diamond(test(F1),F2)), 
    delta_all(F1,(CaseF1,OptF1,A),S'),
    delta_all(F2,(CaseF2,_,_),_).

% Conditions from F2
delta_all(diamond(test(F1),F2),((CaseF1,CaseF2),OptF2,A),S') :- 
    state_all(diamond(test(F1),F2)), 
    delta_all(F2,(CaseF2,OptF2,A),S'),
    delta_all(F1,(CaseF1,_,_),_).

%--- diamond(top,F)

%If not last then F
delta_all(diamond(top,F),(1,out,LAST),F) :- 
    state_all(diamond(top,F)),
    prop(LAST,"last").

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
    prop(LAST,"last").

%If not last then F
delta_all(box(top,F),(1,out,LAST),F) :- 
    state_all(box(top,F)),
    prop(LAST,"last").

%--- box(sequence(P1,P2),F)
delta_all(box(sequence(P1,P2),F),(Case,Opt,A),S'):-
    state_all(box(sequence(P1,P2),F)),
    delta_all(box(P1,box(P2,F)),(Case,Opt,A),S').


%--- box(choice(P1,P2),F)
delta_all(box(choice(P1,P2),F),((CaseP1,CaseP2),OptP1,A),S'):-
    state_all(box(choice(P1,P2),F)),
    delta_all(box(P1,F),(CaseP1,OptP1,A),S'),
    delta_all(box(P2,F),(CaseP2,_,_),_).

delta_all(box(choice(P1,P2),F),((CaseP1,CaseP2),OptP2,A),S'):-
    state_all(box(choice(P1,P2),F)),
    delta_all(box(P2,F),(CaseP2,OptP2,A),S'),
    delta_all(box(P1,F),(CaseP1,_,_),_).

%--- box(star(P1),F)
is_test(test(P)):-state_all(box(star(test(P)),F)).

delta_all(box(star(test(P)),F),(Case,Opt,A),S') :- 
    state_all(box(star(test(P)),F)), 
    delta_all(F,(Case,Opt,A),S').

delta_all(box(star(P),F),((CaseP,CaseF),OptP,A),S') :- 
    state_all(box(star(P),F)), 
    not is_test(P),
    delta_all(box(P,box(star(P),F)),(CaseP,OptP,A),S'),
    delta_all(F,(CaseF,_,_),_).

delta_all(box(star(P),F),((CaseP,CaseF),OptF,A),S') :- 
    state_all(box(star(P),F)), 
    not is_test(P),
    delta_all(F,(CaseF,OptF,A),S'),
    delta_all(box(P,box(star(P),F)),(CaseP,_,_),_).



% ----------------------------------------------------- 
% Clean up
% ----------------------------------------------------- 


% -------------------- Keep only reachable states and deltas
reachable(F) :- initial_state(ID), state_id(ID,F).
reachable(S') :- delta_all(S,_,S'), reachable(S).

state(ID,S) :- state_all(S), reachable(S), state_id(ID,S).

delta_2(ID,(Case,Opt,A),ID') :- delta_all(S,(Case,Opt,A),S'), state(ID,S), state(ID',S').
delta_2(ID,(Case,Opt,A),true) :- delta_all(S,(Case,Opt,A),true), state(ID,S).

% -------------------- Remove cases for irelevat atoms using binary resolution 
% delta(S,C,S'):-delta_2(S,C,S').

% drop_delta_atom(Case1,A,S) :-
%     delta_2(S,(Case1,OptA,A),S'),
%     delta_2(S,(Case2,NotOptA,A),S'),
%     OptA!=NotOptA,
%     #count{OptB,B:delta_2(S,(Case2,OptB,B),S'),not delta_2(S,(Case1,OptB,B),S'),B!=A}=0,
%     #count{OptB,B:not delta_2(S,(Case2,OptB,B),S'), delta_2(S,(Case1,OptB,B),S'),B!=A}=0.

% -------------------- Remove contradicting cases in A and out A
drop_delta_2(Case,S):- delta_2(S,(Case,Opt,A),S'),delta_2(S,(Case,NotOpt,A),S''),NotOpt!=Opt.


delta(S,(Case,Opt,A),S'):-delta_2(S,(Case,Opt,A),S'), not drop_delta_atom(Case,A,S), not drop_delta_2(Case,S).

#show delta_2/3.
#show state_id/2.
% #show delta_2/3.
#show delta_all/3.
% #show theory_id_to_predicate/2.