%-------------------- Initial formula --------------------------
initial_state(F):-ldl(F).
%-------------------- Fish lander closure to define states ------
%
%       state(F,ID): The state labeld with formula F with id ID

%----------- Operators --------
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

%----------- Predicates -------- Asumes p() used and never p

state(P,"prop",ID,-1):-theory_function(ID,ID_O,ID_T),
theory_string(ID_O,P), not operator(P).
% Adds negation of all prop
state("~",P,ID,-1):-state(P,"prop",ID,-1).

%----------- Boolean, Top and Bottom -------- &true &false

bool(B,-1,ID,-1):-theory_function(ID,ID_O,ID_T),
theory_string(ID_O,"&"),
theory_tuple(ID_T,0,ID_B),
theory_string(ID_B,B).

% ------------ Dimond ----------

% ------ Unary Path (? *)
state(".<?",O,ID_F,ID_P):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,".<?"),
theory_tuple(ID_T,0,ID_P),
theory_tuple(ID_T,1,ID_F),
theory_function(ID_P,ID_PO,ID_PT),
theory_string(ID_PO,O), path_o(O).

% ------ Binary Path (;; +)
% ;; How to crate a formula for <p1><p2>F
state(".<?",O,ID_F,ID_P):-
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,".<?"),
theory_tuple(ID_T,0,ID_P),
theory_tuple(ID_T,1,ID_F),
theory_function(ID_P,ID_PO,ID_PT),
theory_string(ID_PO,O), path_o(O).


% ------- Special cases of generated states
% <p1+p2>F   =>    <p1>F    <p2>F
state(".<?",ID_PLHSO,ID_F,ID_PLHS):- 
state(".<?","+",ID_F,ID_P),
theory_function(ID_P,ID_PO,ID_PT),
theory_tuple(ID_PT,0,ID_PLHS),
theory_function(ID_PLHS,ID_PLHSO,_).

state(".<?",ID_PLHSO,ID_F,ID_PRHS):- 
state(".<?","+",ID_F,ID_P),
theory_function(ID_P,ID_PO,ID_PT),
theory_tuple(ID_PT,1,ID_PRHS),
theory_function(ID_PRHS,ID_PRHSO,_).


% <p1;;p2>F  =>   <p1><p2>F

% <p*>F  =>   <p><p*>F
state(".<?",ID_PLHSO,ID,ID_PLHS):- 
state(".<?","*",ID_F,ID_P),
theory_function(ID,ID_O,ID_T),
theory_string(ID_O,".<?"),
theory_tuple(ID_T,0,ID_P),
theory_tuple(ID_T,1,ID_F),
theory_function(ID_P,ID_PO,ID_PT),
theory_tuple(ID_PT,0,ID_PLHS),
theory_function(ID_PLHS,ID_PLHSO,_).



% %-------------------- Positive boolean formulas shape ------------
% %
% %       pbf(id(ID)): Positive boolean formula refering to state with id ID
% %       pbf(true): true (__final accepting state)
% %       pbf(false): false (invalid state)
% %       pbf(and(B1,B2)): B1 and B2 
% %       pbf(or(B1,B2)): B1 or B2 
% %       pbf(decide(V,B1,B2)): if V is true choose B1 if not choose B2 


% %-------------------- Transition function ------------------------
% %
% %       delta(S,B): The delta transition from state S is the
% %                    positive boolean formula B

%----- Prop
delta(state(P,"prop",ID,-1) ,pbf_decide(ID,pbf_true,pbf_false)):- 
state(P,"prop",ID,-1).

%----- Neg
delta(state("~",P,ID,-1) ,pbf_decide(ID,pbf_false,pbf_true)):- 
state("~",P,ID,-1).

%----- Dimond <P?>prop
delta(state(".<?","?",ID_F,ID_P),pbf_and(BF1,BF2)):-
state(".<?","?",ID_F,ID_P),

theory_function(ID_F,ID_FO,_),
theory_string(ID_FO,F_O),
delta(state(F_O,"prop",ID_F,-1),BF1),

theory_function(ID_P,ID_PO,ID_PT),
theory_tuple(ID_PT,0,ID_PLHS),
theory_function(ID_PLHS,ID_PLHSO,_),
theory_string(ID_PLHSO,PLHSO),
delta(state(PLHSO,"prop",ID_PLHS,-1),BF2).

%----- Dimond <P?> <P2>F2
delta(state(".<?","?",ID_F,ID_P),pbf_and(BF1,BF2):-
state(".<?","?",ID_F,ID_P),

theory_function(ID_F,ID_FO,ID_FT),
theory_string(ID_FO,F_O),
theory_tuple(ID_FT)
binary_o(F_O),

delta(state(F_O,FP_O,ID_F,-1),BF1),

theory_function(ID_P,ID_PO,ID_PT),
theory_tuple(ID_PT,0,ID_PLHS),
theory_function(ID_PLHS,ID_PLHSO,_),
theory_string(ID_PLHSO,PLHSO),
delta(state(PLHSO,"prop",ID_PLHS,-1),BF2).


%----- Dimond &true

%----- Dimond +

%----- Dimond ;;
delta(dimond(check(F1),F2),pbf(and(BF1,BF2))):- state(dimond(check(F1),F2)), 
                              delta(F1,BF1), 
                              delta(F2,BF2).

delta(dimond(skip,F),pbf(decide(__final,pbf(false),pbf(id(F))))):- state(dimond(skip,F)).
delta(dimond(choice(P1,P2),F),pbf(or(BF1,BF2))):- state(dimond(choice(P1,P2),F)),
                                                    delta(dimond(P1,F),BF1), 
                                                    delta(dimond(P2,F),BF2).
delta(dimond(sequence(P1,P2),F),B):- state(dimond(sequence(P1,P2),F)),
                                     delta(dimond(P1,dimond(P2,F)),B).


is_check(check(P)):-state(dimond(star(check(P)),F)).

delta(dimond(star(check(P)),F),B):- state(dimond(star(check(P)),F)), delta(F,B).

delta(dimond(star(P),F),pbf(or(BF,B))):- state(dimond(star(P),F)),
                             delta(dimond(P,dimond(star(P),F)),B),
                             delta(F,BF),
                             not is_check(P).

delta(box(check(F1),F2),pbf(or(BF1,BF2))):- state(box(check(F1),F2)), 
                                            delta(neg(F1),BF1), 
                                            delta(F2,BF2).

delta(box(skip,F),pbf(decide(__final,pbf(true),pbf(id(F))))):- state(box(skip,F)).
delta(box(choice(P1,P2),F),pbf(and(BF1,BF2))):- state(box(choice(P1,P2),F)),
                                                    delta(box(P1,F),BF1), 
                                                    delta(box(P2,F),BF2).
delta(box(sequence(P1,P2),F),B):- state(box(sequence(P1,P2),F)),
                                     delta(box(P1,box(P2,F)),B).

is_check(check(P)):-state(box(star(check(P)),F)).

delta(box(star(check(P)),F),B):- state(box(star(check(P)),F)), delta(F,B).

delta(box(star(P),F),pbf(and(BF,B))):- state(box(star(P),F)),
                             delta(F,BF),
                             delta(box(P,box(star(P),F)),B),
                             not is_check(P).
