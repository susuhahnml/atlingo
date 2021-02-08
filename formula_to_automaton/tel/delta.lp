% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Delta:
% %     Computes transtion for states
% %     delta_full USES PREDICATES 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------   Prop

delta_full(prop(A),(0,in,A),true) :- 
    state_full(prop(A)).

%-----------------   Neg
delta_full(neg(prop(A)),(0,out,A),true) :-
    state_full(neg(prop(A))).

%-----------------   Boolean
delta_full(top,(0,in,true),true) :-
    state_full(top).

%-----------------   Next
delta_full(next(F),(0,out,LAST),F) :- 
    state_full(next(F)), 
    prop(LAST,"last").

%-----------------   WNext
delta_full(wnext(F),(0,out,LAST),F) :- 
    state_full(wnext(F)),
    prop(LAST,"last").

delta_full(wnext(F),(1,in,LAST),true) :- 
    state_full(wnext(F)), 
    prop(LAST,"last").

%-----------------   And

% Conditions from F1
delta_full(and(F1,F2),((CaseF1,CaseF2),OptF1,A),S') :- 
    state_full(and(F1,F2)), 
    delta_full(F1,(CaseF1,OptF1,A),S'),
    delta_full(F2,(CaseF2,_,_),_).

% Conditions from F2
delta_full(and(F1,F2),((CaseF1,CaseF2),OptF2,A),S') :- 
    state_full(and(F1,F2)), 
    delta_full(F2,(CaseF2,OptF2,A),S'),
    delta_full(F1,(CaseF1,_,_),_).


%-----------------   Or

% Conditions from  F1
delta_full(or(F1,F2),((0,CaseF1),Opt,A),S') :- 
    state_full(or(F1,F2)),
    delta_full(F1,(CaseF1,Opt,A),S'). 

% Conditions from F2
delta_full(or(F1,F2),((1,CaseF2),Opt,A),S') :- 
    state_full(or(F1,F2)),
    delta_full(F2,(CaseF2,Opt,A),S').
    
%-----------------   Until

% Conditions from F1 and not last
delta_full(until(F1,F2),((0,CaseF1),Opt,A),S') :- 
    state_full(until(F1,F2)),
    delta_full(F1,(CaseF1,Opt,A),S').

delta_full(until(F1,F2),((0,CaseF1),out,LAST),until(F1,F2)) :- 
    state_full(until(F1,F2)),
    delta_full(F1,(CaseF1,_,_),_),
    prop(LAST,"last"). 

% Conditions from F2
delta_full(until(F1,F2),((1,CaseF2),Opt,A),S') :- 
    state_full(until(F1,F2)),
    delta_full(F2,(CaseF2,Opt,A),S').

    
%-----------------   Release


% Conditions for F2 and F1
delta_full(release(F1,F2),((0,(CaseF1,CaseF2)),Opt,A),S') :- 
    state_full(release(F1,F2)),
    delta_full(F1,(CaseF1,Opt,A),S'),
    delta_full(F2,(CaseF2,_,_),_).

delta_full(release(F1,F2),((0,(CaseF1,CaseF2)),Opt,A),S') :- 
    state_full(release(F1,F2)),
    delta_full(F2,(CaseF2,Opt,A),S'),
    delta_full(F1,(CaseF1,_,_),_).

% Conditions for F2 and  Last
delta_full(release(F1,F2),((1,CaseF2),Opt,A),S') :- 
    state_full(release(F1,F2)),
    delta_full(F2,(CaseF2,Opt,A),S').

delta_full(release(F1,F2),((1,CaseF2),in,LAST),true) :- 
    state_full(release(F1,F2)),
    delta_full(F2,(CaseF2,_,_),_),
    prop(LAST,"last"). 

% Conditions for F2 and not Last
delta_full(release(F1,F2),((2,CaseF2),Opt,A),S') :- 
    state_full(release(F1,F2)),
    delta_full(F2,(CaseF2,Opt,A),S').

delta_full(release(F1,F2),((2,CaseF2),out,LAST),release(F1,F2)) :- 
    state_full(release(F1,F2)),
    delta_full(F2,(CaseF2,_,_),_),
    prop(LAST,"last"). 


%-----------------   Eventually

% Conditions from  F1
delta_full(eventually(F),((0,CaseF),Opt,A),S') :- 
    state_full(eventually(F)),
    delta_full(F,(CaseF,Opt,A),S'). 

% Conditions from F2
delta_full(eventually(F),(1,out,LAST),eventually(F)) :- 
    state_full(eventually(F)),
    prop(LAST,"last").

%-----------------   Always

% Conditions from  F1
delta_full(always(F),((0,CaseF),Opt,A),S') :- 
    state_full(always(F)),
    delta_full(F,(CaseF,Opt,A),S'). 

delta_full(always(F),((0,CaseF),in,LAST),true) :- 
    state_full(always(F)),
    delta_full(F,(CaseF,_,_),_),
    prop(LAST,"last").


% Conditions from F2
delta_full(always(F),((1,CaseF),Opt,A),S') :- 
    state_full(always(F)),
    delta_full(F,(CaseF,Opt,A),S'). 

delta_full(always(F),((1,CaseF),out,LAST),always(F)) :- 
    state_full(always(F)),
    delta_full(F,(CaseF,_,_),_),
    prop(LAST,"last").
