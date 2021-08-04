

%--- diamond(test(F1),F2)

initial_state_new(N):-#count{1,Q:state(Q,QNAME)}=N.
state_new(N,box(top,top)):-initial_state_new(N).

% join_initial(Q,(Q,())):-initial_state(Q), #count{1,Q2:initial_state(Q2),Q>Q2}=0.

next_initial(Q,null):-initial_state(Q), #false :initial_state(Q2), Q<Q2.

next_initial(Q,Q3):-initial_state(Q), initial_state(Q3), Q3>Q, #false :initial_state(Q2), Q2<Q3, Q2>Q.

cases(Q,M):- #count{1,C: delta(Q,(C,_,_),_)}=M, initial_state(Q).

delta_join(Q,C,Q'):-
                    next_initial(Q,null),
                    delta(Q,C,Q').


delta_join1(Q2,((CF1,CF2),OptF1,A),Q') :- 
    delta_join(Q1,(CF1,OptF1,A),Q'),
    delta(Q2,(CF2,_,_),_),
    next_initial(Q2,Q1).

delta_join1(Q2,((CF1,CF2),OptF2,A),Q') :- 
    delta_join(Q1,(CF1,_,_),_),
    delta(Q2,(CF2,OptF2,A),Q'),
    next_initial(Q2,Q1).


% -------------------- Remove contradicting cases: (C,in,A) and (C,out,A)
delta_join(Q,(C,Opt,A),Q'):- delta_join1(Q,(C,Opt,A),Q'), not drop_delta(C,Q).

drop_delta(C,Q):- 
    delta_join1(Q,(C,Opt,A),Q'), 
    delta_join1(Q,(C,NotOpt,A),Q''), 
    NotOpt!=Opt.

% -------------------- Idea to Remove cases contained in others

% drop_delta(C,Q):- 
%     delta_join(Q,(C,_,_),Q'),
%     delta_join(Q,(C2,_,_),_),
%     C<C2,

%     % All conditions are same (contained)
%     % All Quccessors are contained
%     #false: delta_join(Q,(C,Opt,A),_), 
%             not delta_join(Q,(C2,Opt,A),_);
%     #false: delta_join(Q,(C,_,_),Q2), 
%             not delta_join(Q,(C2,_,_),Q2).



% -------------------- Keep new delta from new initial state joined

delta(N,C,Q'):- delta_join(Q,C,Q'), 
                not next_initial(_,Q),
                initial_state_new(N).
% #count{1,Q2:initial_state(Q2),Q>Q2}=0.


% delta_new()
% delta(Q,())

% % Conditions from F1
% delta_full(diamond(test(F1),F2),((CF1,CF2),OptF1,A),Q') :- 
%     state_full(diamond(test(F1),F2)), 
%     delta_full(F1,(CF1,OptF1,A),Q'),
%     delta_full(F2,(CF2,_,_),_).

% % Conditions from F2
% delta_full(diamond(test(F1),F2),((CF1,CF2),OptF2,A),Q') :- 
%     state_full(diamond(test(F1),F2)), 
%     delta_full(F2,(CF2,OptF2,A),Q'),
%     delta_full(F1,(CF1,_,_),_).



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
