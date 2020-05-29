%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The trace must be expressed using:
%   &trace{holds(p(),T)}. 
% Indicating that predicate p holds in timestep T
% 
% Note: Parenthesis are required in all predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

&trace{holds(move(robot(1)),0)}.
&trace{holds(move(robot(1)),1)}.
&trace{holds(pickup(robot(1),1),2)}.
&trace{holds(last(),3)}.
