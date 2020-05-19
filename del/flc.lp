%-------------------- Initial formula --------------------------
initial_state(F):-
theory_atom(ID_A,ID_O,ID_E),
theory_string(ID_O,"del"),
theory_element(ID_E,ID_T,_),
theory_tuple(ID_T,0,ID),
f(ID,F).
%-------------------- Fish lander closure to define states ------
%
%       state(F,ID): The state labeld with formula F with id ID
operator(";;").operator("+").
operator("?").operator("*").operator("~").operator("&").
operator(".>?").
operator(".>*").

f(I,prop(I)) :- theory_function(I,N,_), theory_string(N,Name), not operator(Name).
% Paths
f(I,top) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"&"),
    theory_tuple(T,0,L),
    theory_string(L,"true").
f(I,bottom) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"&"),
    theory_tuple(T,0,L),
    theory_string(L,"false").
f(I,check(FL)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"?"),
    theory_tuple(T,0,L),
    f(L,FL).
f(I,neg(FL)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"~"),
    theory_tuple(T,0,L),
    f(L,FL).
f(I,sequence(FL,FR)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,";;"),
    theory_tuple(T,0,L),
    theory_tuple(T,1,R),
    f(L,FL), f(R,FR).
f(I,choice(FL,FR)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"+"),
    theory_tuple(T,0,L),
    theory_tuple(T,1,R),
    f(L,FL), f(R,FR).
f(I,star(FL)) :-                                                        
    theory_function(I,N,T), 
    theory_string(N,"*"),
    theory_tuple(T,0,L),
    f(L,FL).

% Formulas
f(I,diamond(FL,FR)) :-
    theory_function(I,N,T),
    theory_string(N,".>?"),
    theory_tuple(T,0,L),
    theory_tuple(T,1,R),
    f(L,FL), f(R,FR).
    
formula(prop(ID)) :- f(_,prop(ID)).
formula(neg(F)) :- f(_,neg(F)).
formula(top) :- f(_,top).
formula(bottom) :- f(_,bottom).
formula(diamond(FL,FR)) :- f(_,diamond(FL,FR)).

subformula(F,F):-formula(F).
subformula(F,neg(prop(ID))):-subformula(F,prop(ID)).
subformula(F,diamond(X,Z)):-subformula(F,diamond(choice(X,Y),Z)).
subformula(F,diamond(Y,Z)):-subformula(F,diamond(choice(X,Y),Z)).
subformula(F,diamond(X,diamond(Y,Z))):-subformula(F,diamond(sequence(X,Y),Z)).
subformula(F,diamond(X,diamond(star(X),Z))):-subformula(F,diamond(star(X),Z)).
subformula(F,Z):-subformula(F,diamond(_,Z)).

flc(F):-subformula(_,F).
% #show flc/1.
% #show subformula/2.