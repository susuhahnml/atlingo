% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Clean up:
% %     Keep reachable states and map to ids
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -------------------- Define reachable states
reachable(F) :- initial_state_full(F).
reachable(S') :- delta_full(S,_,S'), reachable(S).

% -------------------- Assign ids to states
initial_state(0).
state(0,S) :- initial_state_full(S).
state(1+N,S) :- 
    state_full(S), reachable(S), not initial_state_full(S), 
    #count{1,S': state_full(S'), S>S', reachable(S'), not initial_state_full(S')}=N.

% -------------------- Keep deltas for reachable states
delta_reachable(ID,(Case,Opt,A),ID') :- delta_full(S,(Case,Opt,A),S'), state(ID,S), state(ID',S').
delta_reachable(ID,(Case,Opt,A),true) :- delta_full(S,(Case,Opt,A),true), state(ID,S).

% -------------------- Remove contradicting cases: (C,in,A) and (C,out,A)
drop_delta(Case,S):- 
    delta_reachable(S,(Case,Opt,A),S'), 
    delta_reachable(S,(Case,NotOpt,A),S''), 
    NotOpt!=Opt.

% Assign numbers to cases
delta(S,(N,Opt,A),S'):- delta_reachable(S,(Case,Opt,A),S'), not drop_delta(Case,S), 
                #count{Case': Case'>Case, delta_reachable(S,(Case',_,_),_), not drop_delta(Case',S)}=N.

% -------------------- Remove cases for irelevat atoms using binary resolution 
% delta(S,C,S'):-delta_reachable(S,C,S').

% drop_delta_atom(Case1,A,S) :-
%     delta_reachable(S,(Case1,OptA,A),S'),
%     delta_reachable(S,(Case2,NotOptA,A),S'),
%     OptA!=NotOptA,
%     #count{OptB,B:delta_reachable(S,(Case2,OptB,B),S'),not delta_reachable(S,(Case1,OptB,B),S'),B!=A}=0,
%     #count{OptB,B:not delta_reachable(S,(Case2,OptB,B),S'), delta_reachable(S,(Case1,OptB,B),S'),B!=A}=0.
