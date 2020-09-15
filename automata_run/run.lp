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
node_run(state_id(ID),0,root) :- initial_state(ID).

% % %-------------------- Nodes in run auxiliary ------------------------

% If state S is in the run and it has a detla BD then BD follows in children
node_run_unfold(BD,T+1,node_run(state_id(ID),T,P)) :-  
        node_run(state_id(ID),T,P), 
        delta(ID, BD), T<=horizon.

% If boolean formula directly to one node
node_run(state_id(ID),T,P) :- node_run_unfold(pbf_state(ID),T,P).
node_run(true,T,P) :- node_run_unfold(pbf_true,T,P).
node_run(false,T,P) :- node_run_unfold(pbf_false,T,P).

% If boolean formula is AND both nodes are in run
node_run_unfold(B1,T,P) :- node_run_unfold(pbf_and(B1,B2),T,P).
node_run_unfold(B2,T,P) :- node_run_unfold(pbf_and(B1,B2),T,P).

% If boolean formula is OR al least on node is in run
1{node_run_unfold(B1,T,P); node_run_unfold(B2,T,P)}1 :- 
        node_run_unfold(pbf_or(B1,B2),T,P).

% % If boolean formula is DECIDE the runs depends on the holds predicate
node_run_unfold(B1,T,P) :- 
        node_run_unfold(pbf_if(V,B1,B2),T,P), 
        in_trace_at(V,T-1).

node_run_unfold(B2,T,P) :- 
        node_run_unfold(pbf_if(V,B1,B2),T,P), 
        not in_trace_at(V,T-1).


% %-------------------- Accepting runs ------------------------

degree(node_run(B,T,P),A) :-  
        #count{1,B',T':node_run(B',T',node_run(B,T,P))}=A, 
        node_run(B,T,P).

%Every node with degree A is accepted if all its children are accepted
accepting(node_run(state_id(ID),T,P)) :-  
        #count{1,B,T':accepting(node_run(B,T',node_run(state_id(ID),T,P)))}=A,
        A>=1,
        A==A',
        degree(node_run(state_id(ID),T,P),A'),
        node_run(state_id(ID),T,P).

% Accepted runs are those hitting true
accepting(node_run(true,T,P)) :- node_run(true,T,P).

%The the root node must be accepting
:- not accepting(node_run(_,0,root)).
:- node_run(false,N,P).


% #show run_node_at(N,T):node_run(N,T,_).
% #show id_map/2.
% #show holds/2.
% #show holds_map/2.
% #show node_run/3.
% #show initial_state/1.
% #show horizon/1.