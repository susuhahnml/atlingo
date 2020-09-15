% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where robots move horizontally and then vertically
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :- not &del{
%     *(&true ;; ((? move_right(robot(N))) + (? move_up(robot(N))) + (? wait(robot(N))) )) +
%     *(&true ;; ((? move_left(robot(N))) + (? move_up(robot(N))) + (? wait(robot(N))) ))
%     .>?
%     (&true.>* &false) }, robot(N).

:- not &del{
    *(&true ;; ? no_move_right(robot(N))) +
    *(&true ;; ? no_move_left(robot(N))) .>?
    (&true.>* &false) }, robot(N).

:- not &del{
    *(&true ;; ? no_move_down(robot(N))) +
    *(&true ;; ? no_move_up(robot(N))) .>?
    (&true.>* &false) }, robot(N).