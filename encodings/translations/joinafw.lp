

%--- diamond(test(F1),F2)

initial_state_new(N):-#count{1,S:state(S,SNAME)}=N.
state_new(N,box(top,top)):-initial_state_new(N).

% join_initial(S,(S,())):-initial_state(S), #count{1,S2:initial_state(S2),S>S2}=0.

next_initial(S,null):-initial_state(S), #false :initial_state(S2), S<S2.

next_initial(S,S3):-initial_state(S), initial_state(S3), S3>S, #false :initial_state(S2), S2<S3, S2>S.

cases(S,M):- #count{1,C: delta(S,(C,_,_),_)}=M, initial_state(S).

delta_join(S,C,S'):-
                    next_initial(S,null),
                    delta(S,C,S').


delta_join1(S2,((CaseF1,CaseF2),OptF1,A),S') :- 
    delta_join(S1,(CaseF1,OptF1,A),S'),
    delta(S2,(CaseF2,_,_),_),
    next_initial(S2,S1).

delta_join1(S2,((CaseF1,CaseF2),OptF2,A),S') :- 
    delta_join(S1,(CaseF1,_,_),_),
    delta(S2,(CaseF2,OptF2,A),S'),
    next_initial(S2,S1).


% -------------------- Remove contradicting cases: (C,in,A) and (C,out,A)
delta_join(S,(Case,Opt,A),S'):- delta_join1(S,(Case,Opt,A),S'), not drop_delta(Case,S).

drop_delta(Case,S):- 
    delta_join1(S,(Case,Opt,A),S'), 
    delta_join1(S,(Case,NotOpt,A),S''), 
    NotOpt!=Opt.

% -------------------- Idea to Remove cases contained in others

% drop_delta(Case,S):- 
%     delta_join(S,(Case,_,_),S'),
%     delta_join(S,(Case2,_,_),_),
%     Case<Case2,

%     % All conditions are same (contained)
%     % All Successors are contained
%     #false: delta_join(S,(Case,Opt,A),_), 
%             not delta_join(S,(Case2,Opt,A),_);
%     #false: delta_join(S,(Case,_,_),S2), 
%             not delta_join(S,(Case2,_,_),S2).



% -------------------- Keep new delta from new initial state joined

delta(N,C,S'):- delta_join(S,C,S'), 
                not next_initial(_,S),
                initial_state_new(N).
% #count{1,S2:initial_state(S2),S>S2}=0.


% delta_new()
% delta(S,())

% % Conditions from F1
% delta_full(diamond(test(F1),F2),((CaseF1,CaseF2),OptF1,A),S') :- 
%     state_full(diamond(test(F1),F2)), 
%     delta_full(F1,(CaseF1,OptF1,A),S'),
%     delta_full(F2,(CaseF2,_,_),_).

% % Conditions from F2
% delta_full(diamond(test(F1),F2),((CaseF1,CaseF2),OptF2,A),S') :- 
%     state_full(diamond(test(F1),F2)), 
%     delta_full(F2,(CaseF2,OptF2,A),S'),
%     delta_full(F1,(CaseF1,_,_),_).



#show state(X,L) : state_new(X,L).
#show state(X,L) : state(X,L).
#show initial_state(ID) : initial_state_new(ID).
#show delta(ID,O,N) :  delta(ID,O,N).
#show prop/2.
#show final_state(ID) : final_state_nfa(ID).


% #show next_initial/2.
% #show initial_state_new/1.
% #show state_new/2.
% #show delta_join/3.
% #show cases/2.
