% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Run:
% %     Computes runs for a trace
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#include "./trace.lp". %Last holds in horizon and true holds in all time steps


node(ID,0) :- initial_state(ID).

possible_case(Case,S) :- delta(S,(Case,_,_),_).
1{select_case(Case,S,T):possible_case(Case,S)}1 :- node(S,T),S!=true,T<=horizon.

node(S',T+1) :- select_case(Case,S,T), delta(S,(Case,_,_),S').

:- select_case(Case,S,T), delta(S,(Case,in,A),_), not in_trace_at(A,T).
:- select_case(Case,S,T), delta(S,(Case,out,A),_), in_trace_at(A,T).


in_trace_at(true,0..horizon).

#show holds_map/2.
% #show node/2.
% #show select_case/3.
% #show select_case/3.
% #show node/2.
% #show delta/2.
% #show initial_state/1.
% #show horizon/1.