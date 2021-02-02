% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Run:
% %     Computes runs for a trace
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#include "./trace.lp". %Define last time step of the trace 

% %-------------------- Nodes in run ------------------------
% %
% %       node_run(S,T,P): The run has a node representing state S
% %                        for time step T with parent P
% %                  S: state_id(ID) - the state id is ID
% %                     true - branch reached true => valid run
% %                     false - branch reached fals => invalid run

%Strat in root state
node(ID,0) :- initial_state(ID).


1{select_case(Case,S,T):case(Case,S)}1:-node(S,T),S!=true,T<=horizon.

:-select_case(Case,S,T), delta(S,(Case,in,A),_), not in_trace_at(A,T).
:-select_case(Case,S,T), delta(S,(Case,out,A),_), in_trace_at(A,T).

node(S',T+1):-select_case(Case,S,T), delta(S,(Case,_,_),S').

:- node(false,_).

in_trace_at(true,0..horizon).
% {in_trace_at(ID,0..horizon)} :- prop_id(ID).
% % %-------------------- Nodes in run auxiliary ------------------------

% % If state S is in the run and it has a detla BD then BD follows in children
% node_run_unfold(BD,T+1,node_run(state_id(ID),T,P)) :-  
%         node_run(state_id(ID),T,P), 
%         delta(ID, BD), T<=horizon.

% % If boolean formula directly to one node
% node_run(state_id(ID),T,P) :- node_run_unfold(pbf_state(ID),T,P).
% node_run(true,T,P) :- node_run_unfold(pbf_true,T,P).%Maybe can comment out
% % node_run(false,T,P) :- node_run_unfold(pbf_false,T,P).
% :- node_run_unfold(pbf_false,T,P).

% % If boolean formula is AND both nodes are in run
% node_run_unfold(B1,T,P) :- node_run_unfold(pbf_and(B1,B2),T,P).
% node_run_unfold(B2,T,P) :- node_run_unfold(pbf_and(B1,B2),T,P).

% % If boolean formula is OR al least on node is in run
% 1{node_run_unfold(B1,T,P); node_run_unfold(B2,T,P)}1 :- 
%         node_run_unfold(pbf_or(B1,B2),T,P).

% % % If boolean formula is DECIDE the runs depends on the holds predicate
% node_run_unfold(B1,T,P) :- 
%         node_run_unfold(pbf_if(V,B1,B2),T,P), 
%         in_trace_at(V,T-1).

% node_run_unfold(B2,T,P) :- 
%         node_run_unfold(pbf_if(V,B1,B2),T,P), 
%         not in_trace_at(V,T-1).



% %-------------------- Accepting runs ------------------------


% is_state_node(node_run(state_id(ID),T,P)):-node_run(state_id(ID),T,P).

% % Every state-node is accepted if all its children are accepted
% accepting(P) :-  
%         #count{1,B:accepting(node_run(B,T,P));-1,C:node_run(C,T,P)}>=0,
%         is_state_node(P).


% % Accepted runs are those hitting true
% accepting(node_run(true,T,P)) :- node_run(true,T,P).

% %The the root node must be accepting
% :- not accepting(node_run(_,0,root)).



% #show run_node_at(N,T):node_run(N,T,_).
% #show id_map/2.
% #show holds/2.
#show holds_map/2.
% #show select_case/3.
% #show node/2.
% #show delta/2.
% #show initial_state/1.
% #show horizon/1.