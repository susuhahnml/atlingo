

% ------- States

bin(ID,2**(ID)):-state(ID,S).
number_states(N):-#count{ID:state(ID,_)}=N.
state_nfa_set(0..2**N-1):- number_states(N).

state_nfa_set(X,N):- state_nfa_set(X), X-B>=0, bin(N,B), number_states(N).
state_nfa_set(X,N):- state_nfa_set(X), X-T-B>=0, bin(N,B), #sum{B':state_nfa_set(X,N'),bin(N',B'),N'>N}=T.
state_nfa_set_size(X,D):- state_nfa_set(X), #count{N: state_nfa_set(X,N)}=D.

initial_state_nfa(X):- state_nfa_set(X), state_nfa_set(X,ID), initial_state(ID), #count{ID': state_nfa_set(X,ID'), ID'!=ID}=0.

state_nfa_reachable(X):-initial_state_nfa(X).


% ------- Transitions

state_nfa_set(X,N,D) :- state_nfa_set(X,N), #count{N': state_nfa_set(X,N'), N<N'}=D.

delta_nfa_set(X,C,0,(T,P),N'):- delta(N,(C,T,P),N'), state_nfa_set(X,N,0), state_nfa_reachable(X). %Base

delta_nfa_set(X,(C,CT),B+1,(T,P),N'):- delta_nfa_set(X,CT,B,_,_), delta(N,(C,T,P),N'), state_nfa_set(X,N,B+1), state_nfa_reachable(X).

delta_nfa_set(X,(C,CT),B+1,(T,P),N'):- delta_nfa_set(X,CT,B,(T,P),N'), delta(N,(C,_,_),_), state_nfa_set(X,N,B+1), state_nfa_reachable(X).

delta_nfa_set(X,(C,T,P),N'):- state_nfa_set_size(X,D), delta_nfa_set(X,C,D-1,(T,P),N').


state_nfa_reachable(X'):-state_nfa_reachable(X),delta_nfa_full(X,_,X').



delta_nfa_full(X,(C,T,P),X') :- delta_nfa_set(X,(C,T,P),_);
                                state_nfa_set(X');
                             #false: not delta_nfa_set(X,(C,_,_),N_IN), state_nfa_set(X',N_IN),N_IN!=true;
                            state_nfa_set(X',N'):delta_nfa_set(X,(C,_,_),N'),N'!=true.

% ------- Cleanup

state_nfa_reachable(X,(),0):- initial_state_nfa(X).
state_nfa_reachable(X',(),0):-state_nfa_reachable(X,(),0),delta_nfa_full(X,_,X').

state_nfa_reachable(X,(S_N,S_O),D+1):-state_nfa_set(X,S_N,D),      
                            state_nfa_reachable(X,S_O,D).

state_nfa(X,L):-state_nfa_reachable(X,L,T), state_nfa_set_size(X,T).

delta_nfa_reachable(ID,(Case,Opt,A),ID') :- delta_nfa_full(ID,(Case,Opt,A),ID'), state_nfa(ID,_), state_nfa(ID',_).

delta_nfa(ID,(Case,Opt,A),ID') :- delta_nfa_reachable(ID,(Case,Opt,A),ID').
                    
% Use ids for cases
% delta_nfa(ID,(N,Opt,A),ID') :- delta_nfa_reachable(ID,(Case,Opt,A),ID'), 
%                     #count{Case': Case'>Case, delta_nfa_reachable(ID,(Case',_,_),_)}=N.

delta_nfa(ID,(0,in,true),ID) :-  state_nfa(ID,()).
final_state_nfa(ID) :-  state_nfa(ID,()).

% initial_state(0).
% prop(9,"b").
% prop(13,"a").
% prop(15,"last").
% state(0,diamond(sequence(test(diamond(star(top),prop(9))),top),prop(13))).
% state(2,diamond(star(top),prop(9))).
% state(1,prop(13)).
% delta(2,(1,out,15),2).
% delta(0,(1,out,15),2).
% delta(0,(1,out,15),1).
% delta(0,(0,out,15),1).
% delta(0,(0,in,9),true).
% delta(2,(0,in,9),true).
% delta(1,(0,in,13),true).

% #show state_nfa_reachable/1.
% #show state_nfa_reachable/3.
% #show state_nfa_set/3.
% #show delta_nfa_set/5.
% #show delta_nfa_set/3.

#show state_nfa/2.
#show initial_state_nfa/1.
#show delta_nfa/3.
#show prop/2.
#show final_state_nfa/1.

