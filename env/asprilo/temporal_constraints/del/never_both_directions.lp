% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where robots move horizontally and then vertically
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- not &del{
    *(&true ;; ((? move_right(robot(N))) + (? move_up(robot(N))) + (? wait(robot(N))) )) +
    *(&true ;; ((? move_left(robot(N))) + (? move_up(robot(N))) + (? wait(robot(N))) ))
    .>?
    (&true.>* &false) }, robot(N).
