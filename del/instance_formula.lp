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


:- not &del{* (?a() ;; &true) .>? (&true .>* &false)}.
% :- not &del{(&true .>* &false)}.
% :- not &del{?a() ;; &true .>*c()}.