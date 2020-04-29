
holds(true,N):-holds(__final,N).
holds(true, N-1):-holds(true,N),N>0.


% %-------------------- Nodes in run ------------------------
% %
% %       node_run(S,T,P): The run has a node representing state S
% %                        for time step T with parent P
% %                  S: id(ID) - the state id is ID
% %                     true - branch reached true => valid run
% %                     false - branch reached fals => invalid run



node_run(id(F),0,root):-initial_state(F).%Strat in root state



% % %-------------------- Nodes in run auxiliary ------------------------

% If state S is in the run and it has a detla BD then BD follows in children
node_run_aux(BD,T+1,node_run(id(S),T,P)):- node_run(id(S),T,P), delta(S, BD).

% If boolean formulas directly to one node
node_run(id(S),T,P):-node_run_aux(pbf(id(S)),T,P).
node_run(true,T,P):-node_run_aux(pbf(true),T,P).
node_run(false,T,P):-node_run_aux(pbf(false),T,P).

% If boolean formulas is AND both nodes are in run
node_run_aux(B1,T,P):-node_run_aux(pbf(and(B1,B2)),T,P).
node_run_aux(B2,T,P):-node_run_aux(pbf(and(B1,B2)),T,P).

% If boolean formulas is OR al least on node is in run
1{node_run_aux(B1,T,P); node_run_aux(B2,T,P)}1:-node_run_aux(pbf(or(B1,B2)),T,P).

% If boolean formulas is DECIDE only holds runs will open
node_run_aux(B1,T,P):-node_run_aux(pbf(decide(V,B1,B2)),T,P), holds(V,T-1).
node_run_aux(B2,T,P):-node_run_aux(pbf(decide(V,B1,B2)),T,P), not holds(V,T-1).


% %-------------------- Accepting runs ------------------------

arity(node_run(B,T,P),A):- #count{1,B',T':node_run(B',T',node_run(B,T,P))}=A, node_run(B,T,P).

%Every node with arity A is accepted if all its children are accepted
accepting(node_run(id(ID),T,P)):- #count{1,B,T':accepting(node_run(B,T',node_run(id(ID),T,P)))}=A,
                                  A>=1,
                                  A==A',
                                  arity(node_run(id(ID),T,P),A'),
                                  node_run(id(ID),T,P).

accepting(node_run(true,T,P)):-node_run(true,T,P).

%The the root as the node must be accepting
:- not accepting(node_run(_,0,root)).
:- node_run(false,N,P).

