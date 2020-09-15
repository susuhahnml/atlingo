% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Robots can only move up or down and left or right
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#include "../right_left_up_down.lp".

:- not &tel{ (>* (~ move(robot(N), R))) |  (>* (~ move(robot(N), L))) }, right(R), left(L), robot(N).
:- not &tel{ (>* (~ move(robot(N), U))) |  (>* (~ move(robot(N), D))) }, up(U), down(D), robot(N).