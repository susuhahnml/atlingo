#include "trace_last_generator.lp".

holds(I,T):-move(R,D,T),id_to_pred(move(R,D),I).
% holds(I,T):-pickup(R,S,T),id_to_pred(pickup(R,S),I).

holds_automaton(P,T):-holds(I,T),id_to_pred(P,I).

#show holds_automaton/2.
% #show pickup/3.


id_to_pred(move(robot(R),(X,Y)),I):-
theory_string(ISR,"robot"),
theory_number(INR,R),
theory_tuple(ITR),
theory_tuple(ITR,0,INR),
theory_function(IR,ISR,ITR),
theory_number(IY,Y),
theory_number(IX,X),
theory_tuple(ITD),
theory_tuple(ITD,0,IX),
theory_tuple(ITD,1,IY),
theory_sequence(ISD,tuple,ITD),
theory_string(IM,"move"),
theory_tuple(ITM),
theory_tuple(ITM,0,IR),
theory_tuple(ITM,1,ISD),
theory_function(I,IM,ITM).


% id_to_pred(pickup(robot(R),shelf(S)),I):-
% theory_string(ISR,"robot"),
% theory_number(INR,R),
% theory_tuple(ITR),
% theory_tuple(ITR,0,INR),
% theory_function(IR,ISR,ITR),


% theory_string(ISS,"shelf"),
% theory_number(INS,S),
% theory_tuple(ITS),
% theory_tuple(ITS,0,INS),
% theory_function(IS,ISS,ITR),
% theory_string(IP,"pickup"),
% theory_tuple(ITP),
% theory_tuple(ITP,0,IR),
% theory_tuple(ITP,1,IS),
% theory_function(I,IP,ITP).


% #const horizon = 4.
% #const new_last_id = 200.
% time(0..horizon).

% %Define theory_string for last
% theory_string(new_last_id+1,"last").
% theory_function(new_last_id,new_last_id+1,-1).


% % Last can hold at any instant
% {holds(new_last_id,T)}:-time(T).
% %Any step could be the last
% :- #count{1,T:holds(new_last_id,T),time(T)}!=1.
% %Nothing can hold after last
% :-holds(new_last_id,T),holds(P,T'),T'>T,prop_id(P).
