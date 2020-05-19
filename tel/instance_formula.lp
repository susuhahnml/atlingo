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


:- not &tel{a(b(1),c())}.
% :- not &del{a+b.>?b}.
% :- &tel{a()&b()}.
% &trace{holds(b(),0)}.
% &trace{holds(b(),1)}.
% &trace{holds(last(),1)}.