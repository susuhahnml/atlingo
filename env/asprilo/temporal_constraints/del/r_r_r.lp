% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where the last tree moves of all robost
% % are moving right
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- not &del{(?move(robot(X),(1,0)) ;; &true ;; ?move(robot(X),(1,0))).>? &true}, robot(X).
