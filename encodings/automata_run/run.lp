% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Run:
% %     Computes runs for a trace
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#include "./trace.lp". %Last holds in horizon and true holds in all time steps


node(ID,0) :- initial_state(ID).

possible_case(C,Q) :- delta(Q,(C,_,_),_).
1{select_case(C,Q,T):possible_case(C,Q)}1 :- node(Q,T),T<=lambda-1.

node(Q',T+1) :- select_case(C,Q,T), delta(Q,(C,_,_),Q'), Q'!=true.

:- select_case(C,Q,T), delta(Q,(C,in,A),_), not trace(A,T), A!=true.
:- select_case(C,Q,T), delta(Q,(C,out,A),_), trace(A,T), A!=true.

:- node(ID,lambda), not final_state(ID).

% #show holds_map/2.
% #show trace/2.
% #show node/2.
% #show select_case/3.
% #show select_case/3.
% #show node/2.
% #show delta/2.
% #show initial_state/1.
% #show horizon/1.