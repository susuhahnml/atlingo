% robot is associated with destination of same id

:- not position(robot(R),C,horizon), position(destination(R),C).
