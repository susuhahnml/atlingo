#include "../right_left_up_down.lp".
:- not &tel{ > (move(robot(R),UP) >? (move(robot(R),RIGHT) >? >* wait(robot(R)))) }, robot(R), right(RIGHT), up(UP).
