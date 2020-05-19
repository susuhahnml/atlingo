%-------------------- Initial formula --------------------------
initial_state(ID):-
theory_atom(ID_A,ID_O,ID_E),
theory_string(ID_O,"tel"),
theory_element(ID_E,ID_T,_),
theory_tuple(ID_T,0,ID).
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

state(P,"prop",ID,-1) :- theory_function(ID,ID_O,ID_T),
                         theory_string(ID_O,P), not operator(P).
            
% &tel{P()>?c()}        :- theory_function(ID,ID_O,ID_T),
%                           theory_string(ID_O,P),
%                           theory_tuple(ID_T),

%                           theory_tuple(ID_T,0,ID_0),  % all arguments
%                           theory_tuple(ID_T,1,ID_1),
%                           ...

%                           theory_function(ID_0,ID_O0,_), %Get the name of the function of each argument
%                           theory_string(ID_O0,A0),

%                           theory_function(ID_1,ID_O1,_),
%                           theory_string(ID_O1,A1),
%                           ...

%                           %Further nested arguments
