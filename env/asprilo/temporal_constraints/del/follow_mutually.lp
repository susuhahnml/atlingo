% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where the last tree moves of all robost
% % are moving right
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- not &del{(* &true) .>? (
    ?following(robot(X),robot(Y)) ;; &true ;; ?following(robot(Y),robot(X)) ;; &true ;; 
    ?following(robot(X),robot(Y)) ;; &true ;; ?following(robot(Y),robot(X)) ;; &true ;; 
    ?following(robot(X),robot(Y)) ;; &true ;; ?following(robot(Y),robot(X)) ;; &true 

% *(?following(robot(X),robot(Y)) ;; &true) ;; 

% ?following(robot(Y),robot(X)) ;; &true ;; 

% *(?following(robot(Y),robot(X)) ;; &true)

.>? &true)}, robot(X), robot(Y), Y!=X.
% :- not &del{(* &true) .>? (?move_d(robot(X)) ;; &true ;; ?move_d(robot(X)) ;; &true).>? (*(&true).>* ( move_v(robot(X)) + ?move_h(robot(X))) .>* &false)}, robot(X).
