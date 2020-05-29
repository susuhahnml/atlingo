%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Must include a temporal formula with format:
%   :- not &tel{...}.
% Based on the theory decribed in file ./teory
%
% The trace must be expressed using:
%   &trace{holds(p(),T)}. 
% Indicating that predicate p holds in timestep T
% 
% Note: Parenthesis are required in all predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

robot(1).
% robot(2).
shelf(1).
direction((1,0)).
direction((0,1)).
% move(robot(R),D,T).
% #show occurs(object(robot,R), action(pickup, ()     ), T) :  pickup(robot(R),_,T).
% #show occurs(object(robot,R), action(putdown,()     ), T) : putdown(robot(R),_,T)
% :- &del{* (?in(X,(1,1));; &true) .>? &true }, robot(X).
% :- &del{(?move(robot(X),(1,0)) ;; &true ;; ?move(robot(X),(0,1)) ;; &true) .>? (&true .>? pickup(robot(X),S))},robot(X),shelf(S).
:- &del{(?move(robot(X),(1,0)) ;; &true ;; ?move(robot(X),(0,1)) ;; &true) .>? pickup(robot(X),S)},robot(X),shelf(S).
% :- &del{(?move(robot(X),(1,0));; &true) .>? &true},robot(X).
% :- &del{* (?move(X,1) ;; &true ;; ?move(X,0) ;; &true) .>? (&true .>? carries(X,S))},robot(X),shelf(S).
% :- not &del{* (?a() ;; &true) .>? (&true .>* &false)}.
% :- not &del{(&true .>* &false)}.
% :- not &del{?a() ;; &true .>*c()}.