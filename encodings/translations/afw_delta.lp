% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Delta:
% %     Computes transtion for states
% %     delta_full USES PREDICATES 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% copy_all
delta_full(Q2,C):-
    copy_all(Q1,Q2),
    delta_full(Q1,C).
copy_case((Q1,C),(Q2,C)):-
    copy_all(Q1,Q2),
    delta_full(Q1,C).
% copy_case
delta_full(Q2,C2,T,P):-
    copy_case((Q1,C1),(Q2,C2)),
    delta_full(Q1,C1,T,P).
delta_full(Q2,C2,Q'):-
    copy_case((Q1,C1),(Q2,C2)),
    delta_full(Q1,C1,Q').

%-----------------   Prop
delta_full(prop(A),0):-
    state_full(prop(A)).
delta_full(prop(A),0,in,A):-
    state_full(prop(A)).

%-----------------   Neg
delta_full(neg(prop(A)),0):-
    state_full(neg(prop(A))).
delta_full(neg(prop(A)),0,out,A):-
    state_full(neg(prop(A))).

%-----------------   Boolean
delta_full(top,0):-
    state_full(top).

%-----------------   Diamond

%--------------------------------------
% diamond(test(F1),F2)
%--------------------------------------


% Conditions from F1
delta_full(diamond(test(F1),F2),(CF1,CF2)) :- 
    state_full(diamond(test(F1),F2)), 
    delta_full(F1,CF1),
    delta_full(F2,CF2).

copy_case((F1,CF1),(diamond(test(F1),F2),(CF1,CF2))) :- 
    delta_full(diamond(test(F1),F2),(CF1,CF2)).
copy_case((F2,CF2),(diamond(test(F1),F2),(CF1,CF2))) :- 
    delta_full(diamond(test(F1),F2),(CF1,CF2)).

%--------------------------------------
% diamond(stp,F)
%--------------------------------------

%If not last then F
delta_full(diamond(stp,F),0) :- 
    state_full(diamond(stp,F)).
% Conditions
delta_full(diamond(stp,F),0,out,LAST) :- 
    prop(LAST,"last"),
    delta_full(diamond(stp,F),0).
% Next
delta_full(diamond(stp,F),0,F) :- 
    delta_full(diamond(stp,F),0).

%--------------------------------------
% diamond(sequence(P1,P2),F)
%--------------------------------------
copy_all(diamond(P1,diamond(P2,F)),diamond(sequence(P1,P2),F)) :- 
    state_full(diamond(sequence(P1,P2),F)),
    state_full(diamond(P1,diamond(P2,F))).

%--------------------------------------
% diamond(choice(P1,P2),F)
%--------------------------------------

delta_full(diamond(choice(P1,P2),F),(0,CP1)):-
    state_full(diamond(choice(P1,P2),F)),
    delta_full(diamond(P1,F),CP1).
delta_full(diamond(choice(P1,P2),F),(1,CP2)):-
    state_full(diamond(choice(P1,P2),F)),
    delta_full(diamond(P2,F),CP2).

copy_case((diamond(P1,F),CP1),(diamond(choice(P1,P2),F),(0,CP1))) :- 
    delta_full(diamond(choice(P1,P2),F),(0,CP1)).

copy_case((diamond(P2,F),CP2),(diamond(choice(P1,P2),F),(1,CP2))) :- 
    delta_full(diamond(choice(P1,P2),F),(1,CP2)).

%--------------------------------------
% diamond(star(P1),F)
%--------------------------------------


is_test(test(P)):-state_full(diamond(star(test(P)),F)).
% Test case
copy_all(F,diamond(star(test(P)),F)):-
    state_full(diamond(star(test(P)),F)).

% No Test case

delta_full(diamond(star(P),F),(0,C)) :- 
    state_full(diamond(star(P),F)), not is_test(P),
    delta_full(diamond(P,diamond(star(P),F)),C).

delta_full(diamond(star(P),F),(1,C)) :- 
    state_full(diamond(star(P),F)), not is_test(P),
    delta_full(F,C).

copy_case((diamond(P,diamond(star(P),F)),C),(diamond(star(P),F),(0,C))):-
    delta_full(diamond(star(P),F),(0,C)), not is_test(P).

copy_case((F,C),(diamond(star(P),F),(1,C))):-
    delta_full(diamond(star(P),F),(1,C)), not is_test(P).

%-----------------   Box

%--------------------------------------
% box(test(F1),F2)
%--------------------------------------


% Conditions from neg F1
delta_full(box(test(F1),F2),((0,CF1),Opt,A),Q') :- 
    state_full(box(test(F1),F2)),
    delta_full(F1',(CF1,Opt,A),Q'), 
    nnf(neg(F1),F1').

% Conditions from F2
delta_full(box(test(F1),F2),((1,CF2),Opt,A),Q') :- 
    state_full(box(test(F1),F2)),
    delta_full(F2,(CF2,Opt,A),Q').

%--------------------------------------
% box(stp,F)
%--------------------------------------


%If last then null
delta_full(box(stp,F),(0,in,LAST),null) :- 
    state_full(box(stp,F)),
    prop(LAST,"last").

%If not last then F
delta_full(box(stp,F),(1,out,LAST),F) :- 
    state_full(box(stp,F)),
    prop(LAST,"last").

%--------------------------------------
% box(sequence(P1,P2),F)
%--------------------------------------

delta_full(box(sequence(P1,P2),F),(C,Opt,A),Q'):-
    state_full(box(sequence(P1,P2),F)),
    delta_full(box(P1,box(P2,F)),(C,Opt,A),Q').


%--------------------------------------
% box(choice(P1,P2),F)
%--------------------------------------

delta_full(box(choice(P1,P2),F),((CP1,CP2),OptP1,A),Q'):-
    state_full(box(choice(P1,P2),F)),
    delta_full(box(P1,F),(CP1,OptP1,A),Q'),
    delta_full(box(P2,F),(CP2,_,_),_).

delta_full(box(choice(P1,P2),F),((CP1,CP2),OptP2,A),Q'):-
    state_full(box(choice(P1,P2),F)),
    delta_full(box(P2,F),(CP2,OptP2,A),Q'),
    delta_full(box(P1,F),(CP1,_,_),_).

%--------------------------------------
% box(star(P1),F)
%--------------------------------------

is_test(test(P)):-state_full(box(star(test(P)),F)).

delta_full(box(star(test(P)),F),(C,Opt,A),Q') :- 
    state_full(box(star(test(P)),F)), 
    delta_full(F,(C,Opt,A),Q').

delta_full(box(star(P),F),((CP,CF),OptP,A),Q') :- 
    state_full(box(star(P),F)), 
    not is_test(P),
    delta_full(box(P,box(star(P),F)),(CP,OptP,A),Q'),
    delta_full(F,(CF,_,_),_).

delta_full(box(star(P),F),((CP,CF),OptF,A),Q') :- 
    state_full(box(star(P),F)), 
    not is_test(P),
    delta_full(F,(CF,OptF,A),Q'),
    delta_full(box(P,box(star(P),F)),(CP,_,_),_).
