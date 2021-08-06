% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Clean up:
% %     Keep reachable states and map to ids
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -------------------- Define reachable states
reachable(F) :- initial_state_full(F).
reachable(Q') :- delta_full(Q,_,Q'), reachable(Q), Q'!=bottom.

% -------------------- Assign ids to states
state(0,Q) :- initial_state_full(Q), #count{1,Q':initial_state_full(Q'),Q'<Q}=0.
state(1+N,Q) :- 
    state_full(Q), reachable(Q), not state(0,Q), 
    #count{1,Q': state_full(Q'), Q>Q', reachable(Q'), not state(0,Q')}=N.

initial_state(ID):-initial_state_full(F),state(ID,F).

% -------------------- Remove contradicting cases: (C,in,A) and (C,out,A)
drop_delta(C,Q):- 
    delta_full(Q,(C,Opt,A),Q'), 
    delta_full(Q,(C,NotOpt,A),Q''), 
    NotOpt!=Opt.

drop_delta(C,Q):- 
    delta_full(Q,(C,_,_),bottom). 

% -------------------- Keep deltas for reachable states
delta_reachable(ID,(C,Opt,A),ID') :- delta_full(Q,(C,Opt,A),Q'), state(ID,Q), state(ID',Q'), not drop_delta(C,Q).
delta_reachable(ID,(C,Opt,A),null) :- delta_full(Q,(C,Opt,A),null), state(ID,Q), not drop_delta(C,Q).


% Assign numbers to cases
% delta(Q,(N,Opt,A),Q'):- delta_reachable(Q,(C,Opt,A),Q'), not drop_delta(C,Q), 
%                 #count{C': C'>C, delta_reachable(Q,(C',_,_),_), not drop_delta(C',Q)}=N.

delta(Q,(C,Opt,A),Q'):- delta_reachable(Q,(C,Opt,A),Q'), not drop_delta(C,Q).



% -------------------- Remove cases for irelevat atoms using binary resolution 
% delta(Q,C,Q'):-delta_reachable(Q,C,Q').

% drop_delta_atom(C1,A,Q) :-
%     delta_reachable(Q,(C1,OptA,A),Q'),
%     delta_reachable(Q,(C2,NotOptA,A),Q'),
%     OptA!=NotOptA,
%     #count{OptB,B:delta_reachable(Q,(C2,OptB,B),Q'),not delta_reachable(Q,(C1,OptB,B),Q'),B!=A}=0,
%     #count{OptB,B:not delta_reachable(Q,(C2,OptB,B),Q'), delta_reachable(Q,(C1,OptB,B),Q'),B!=A}=0.
