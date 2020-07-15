% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where the last tree moves of all robost
% % are moving right
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- not &del{* (?move(robot(X),(1,0)) ;; &true;; ? ~ move(robot(X),(1,0));; &true).>? &true .>* &false}, robot(X).

% :- not &del{?move(robot(X),(1,0)) ;; &true;; ? wait(robot(X));; &true ;; * (?move(robot(X),(1,0)) ;; &true;; ? wait(robot(X))) .>? (&true .>* &false)}, robot(X).

% :- not &del{&true}.
