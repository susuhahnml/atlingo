% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where robots move horizontally and then vertically
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- not &tel{(~ move_v(robot(R)) ) >? (>* ~ move_h(robot(R))) }, robot(R).