% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where robots move horizontally and then vertically
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- not &tel{(~ move_vertically(robot(R)) ) >? (>* ~ move_horizontally(robot(R))) }, robot(R).

% :- not &tel{(no_move_vertically(robot(R)) ) >? (>* no_move_horizontally(robot(R))) }, robot(R).
