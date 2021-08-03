#include "../right_left_up_down.lp".
:- not &del{ *( &true ;; ?move(robot(R),UP)) ;;
             *( &true ;; ?move(robot(R),RIGHT)) ;; 
             *( &true ;; ?wait(robot(R))) .>? (&true.>* &false) },
    robot(R), right(RIGHT), up(UP).