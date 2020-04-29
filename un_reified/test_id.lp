#script (python)
def new_id(t): 
    t=str(t)[1:-1]
    ids={
        "t":100,
        "f":200,
        "str":300
    }
    ids[t] = ids[t]+1
    return ids[t]
#end.

path_o(";;").
path_o("+").
path_o("?").
path_o("*").
unary_o("~").
unary_o("&").
binary_o(".<?").
binary_o(".<*").
operator(O):-binary_o(O).
operator(O):-path_o(O).
operator(O):-unary_o(O).


{theory_string(@new_id("str"),"~")}.
:-theory_string(ID1,S),theory_string(ID2,S), ID1<ID2.
:- not theory_string(_,"~").


prop_id(ID):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,P), not operator(P).

%Create a Not for each prop
theory_tuple(@new_id("t"),0,ID):-prop_id(ID).
theory_function(@new_id("f"),IDNOTO,ID_T):-prop_id(ID),theory_tuple(ID_T,0,ID), not theory_tuple(ID_T,1,_), theory_string(IDNOTO,"~").



pending_tuple(@new_id("t"),ID,(ID_PLHS,ID_F),ID_O) :- 
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,".<?"),
theory_tuple(ID_T,0,ID_P),
theory_tuple(ID_T,1,ID_F),
theory_function(ID_P,ID_PO,ID_PT),
theory_string(ID_PO,"+"),
theory_tuple(ID_PT,0,ID_PLHS).

pending_tuple(@new_id("t"),ID,(ID_PRHS,ID_F),ID_O) :- 
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,".<?"),
theory_tuple(ID_T,0,ID_P),
theory_tuple(ID_T,1,ID_F),
theory_function(ID_P,ID_PO,ID_PT),
theory_string(ID_PO,"+"),
theory_tuple(ID_PT,1,ID_PRHS).




% Create pending functions
theory_tuple(NEW_T,0,ID_PHS) :- 
pending_tuple(NEW_T,ID,(ID_PHS,ID_F),ID_O).

theory_tuple(NEW_T,1,ID_F) :- 
pending_tuple(NEW_T,ID,(ID_PHS,ID_F),ID_O).

theory_tuple(NEW_T) :- 
pending_tuple(NEW_T,ID,(ID_PHS,ID_F),ID_O).

theory_function(@new_id("f"),ID_O,NEW_T):-
pending_tuple(NEW_T,ID,(ID_PHS,ID_F),ID_O).




theory_string(0,"del").
theory_string(3,"a").
theory_tuple(0).
theory_function(4,3,0).
theory_string(5,"b").
theory_string(6,"6").
theory_string(7,"7").
theory_string(8,"8").
theory_string(9,"9").
theory_function(6,5,0).
theory_string(2,"+").
theory_tuple(1).
theory_tuple(1,0,4).
theory_tuple(1,1,6).
theory_function(7,2,1).