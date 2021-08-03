#include "input.lp".

destination(D)                 :- init(object(dest,D), value(at,    _)).

isDestination(destination(D))  :- destination(D).

position(destination(D),(X,Y)) :- init(object(destination,D), value(at,(X,Y))).
