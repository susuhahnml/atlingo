holds(ID,T):-theory_string(ID_H,"holds"),
theory_function(_,ID_H,ID_T),
theory_tuple(ID_T,0,ID),
theory_tuple(ID_T,1,ID_N),
theory_number(ID_N,T).

#show holds/2.
