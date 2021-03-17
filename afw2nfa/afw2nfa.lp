

% ------- States

% Power set of afw states
bin(ID,2**(ID)):-state(ID,S).
number_states(N):-#count{ID:state(ID,_)}=N.
state_nfa_set(0..2**N-1):- number_states(N).

state_nfa_set(X,N):- state_nfa_set(X), X-B>=0, bin(N,B), number_states(N).
state_nfa_set(X,N):- state_nfa_set(X), X-T-B>=0, bin(N,B), 
                     #sum{B':state_nfa_set(X,N'),bin(N',B'),N'>N}=T.

% Size of the set
state_nfa_set_size(X,D):- state_nfa_set(X), #count{N: state_nfa_set(X,N)}=D.

% Assign an idex D to every element in the set
state_nfa_set_indexed(X,N,D) :- state_nfa_set(X,N), 
                                #count{N': state_nfa_set(X,N'), N<N'}=D.

% Initial is set containing only initial afw
% initial_state_nfa(X):- state_nfa_set(X), state_nfa_set(X,ID), 
%                         initial_state(ID), 
%                         #count{ID': state_nfa_set(X,ID'), ID'!=ID}=0. 
initial_state_nfa(1).

% Use only reacheble
state_nfa_reachable(X):-initial_state_nfa(X).


% ------- Transitions

% Base, start checking cases for index 0
delta_nfa_set(X,C,0,(T,P),N'):- delta(N,(C,T,P),N'), 
                                state_nfa_set_indexed(X,N,0), 
                                state_nfa_reachable(X). 

% Checking cases for next index
delta_nfa_set(X,(C,CT),B+1,(T,P),N'):- delta_nfa_set(X,CT,B,_,_), 
                                       delta(N,(C,T,P),N'), 
                                       state_nfa_set_indexed(X,N,B+1), 
                                       state_nfa_reachable(X).
% Adding cases for already computed index
delta_nfa_set(X,(C,CT),B+1,(T,P),N'):- delta_nfa_set(X,CT,B,(T,P),N'), 
                                       delta(N,(C,_,_),_), 
                                       state_nfa_set_indexed(X,N,B+1), 
                                       state_nfa_reachable(X).

% Keep only delta with all cases at the last index
delta_nfa_set_final(X,(C,T,P),N'):- state_nfa_set_size(X,D), 
                                    delta_nfa_set(X,C,D-1,(T,P),N').


delta_nfa(X,(C,T,P),X') :- delta_nfa_set_final(X,(C,T,P),_);
                            #sum{B: bin(ID,B), delta_nfa_set_final(X,(C,_,_),ID) }=X'.

% Set new reacheble states
state_nfa_reachable(X'):-state_nfa_reachable(X),delta_nfa(X,_,X').




% ------- Cleanup

% Assign a label to the states
state_nfa_reachable(X,(),0):- initial_state_nfa(X).
state_nfa_reachable(X',(),0):-state_nfa_reachable(X,(),0), delta_nfa(X,_,X').

state_nfa_reachable(X,(S_N,S_O),D+1):-state_nfa_set_indexed(X,S_N,D),      
                            state_nfa_reachable(X,S_O,D).

% Keep labels when finsied
state_nfa(X,L):-state_nfa_reachable(X,L,T), state_nfa_set_size(X,T).

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
% #show state_nfa_set/2.
% #show state_nfa_set/3.
% #show delta_nfa_set/5.
% #show delta_nfa_set/3.

#show state_nfa/2.
#show initial_state_nfa/1.
#show delta_nfa/3.
#show prop/2.
#show final_state_nfa/1.

