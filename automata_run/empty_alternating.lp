
error_contradiction :- delta(ID,(C,T1,P),_), 
                        delta(ID,(C,T2,P),_), 
                        T1!=T2.

state_accpet(true).

case_accept(S,C) :- delta(S,(C,_,_),_); 
                    state_accpet(S'): delta(S,(C,_,_),S').


state_accpet(S) :- case_accept(S,_).


not_empty :- state_accpet(S): initial_state(S), not error_contradiction.
empty :- not not_empty, not error_contradiction.

#show empty/0.
#show not_empty/0.