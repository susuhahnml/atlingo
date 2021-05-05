% --------------  Assert no branching and no contradictions -------------- %
error_branching :- delta(ID,(C,T1,P1),ID_NEXT1), 
                   delta(ID,(C,T2,P2),ID_NEXT2), 
                   ID_NEXT1 != ID_NEXT2,
                   ID_NEXT2 != true,
                   ID_NEXT1 != true. 

error_contradiction :- delta(ID,(C,T1,P),_), 
                        delta(ID,(C,T2,P),_), 
                        T1!=T2.

% :- error_contradiction.
% :- error_branching.

% --------------  Find reachable states that do not expect 'last' -------------- %

reachable_state(ID) :- initial_state(ID).


reachable_state(ID_NEXT) :- reachable_state(ID);
                            delta(ID,(C,T,P),ID_NEXT);
                            prop(PROP_LAST,"last");

                            #false :delta(ID,(C,in,PROP_LAST),_);
                            
                            #false :delta(ID,(C,T2,P2),ID_NEXT2), 
                                              ID_NEXT2!=true, 
                                              ID_NEXT2!=ID_NEXT.

% --------------  Check if true or final from reachable states when maybe 'last'-------------- %

%Hit true at any point
sat :- reachable_state(true). 

%Hit final state without excluding last
sat :- reachable_state(ID), 
       delta(ID,(C,T,P),ID_NEXT),
       final_state(ID_NEXT),
       prop(PROP_LAST,"last"),
       #false: delta(ID,(C,out,PROP_LAST),_).

%Hit trues without excluding last
sat :- reachable_state(ID);
       delta(ID,(C,T,P),true);
       prop(PROP_LAST,"last");
       #false: delta(ID,(C,out,PROP_LAST),_);
       #false: delta(ID,(C,_,_),ID_NEXT),ID_NEXT!=true.

% unsat :- not sat.
% :- not sat.

#show not_empty: sat.
#show empty: not sat.
#show unsat/0.
#show error_branching/0.
#show error_contradiction/0.