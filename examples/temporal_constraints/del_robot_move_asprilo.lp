% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where the last tree moves of all robost
% % are moving right
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- not &del{(* &true) .>? (?move(robot(X),(1,0)) ;; &true ;; ?move(robot(X),(1,0)) ;; &true ;; ?move(robot(X),(1,0))).>? (&true.>* &false)}, robot(X).
