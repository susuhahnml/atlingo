% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where the last tree moves of robot 1 
% % are moving right
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- not &del{(* &true) .>? (?move(robot(1),(1,0)) ;; &true ;; ?move(robot(1),(1,0)) ;; &true ;; ?move(robot(1),(1,0))).>? (&true.>* &false)}.

&show{move/1}.
