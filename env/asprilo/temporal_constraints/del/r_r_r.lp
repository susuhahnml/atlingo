% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where the last tree moves of all robost
% % are moving right
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#program initial.

% :- not &del{(&true ;; ?move(robot(1),(1,0)) ).>? &true}.
% :- not &del{( &true ;; ?move(robot(1),(1,0)) ;; &true ;; ?move(robot(1),(1,0))).>? &true}.
:- not &del{( &true ;; ?move(robot(R),(1,0)) ;; &true ;; ?move(robot(R),(1,0))).>? &true}, robot(R).
