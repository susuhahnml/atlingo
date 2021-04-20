% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where the last tree moves of all robost
% % are moving right
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- not &del{*(

    ?move_v(robot(R)) ;; &true ;; *(?no_move(robot(R)) ;; &true) ;; 
    ?move_h(robot(R)) ;; &true ;; *(?no_move(robot(R)) ;; &true) )
     
    .>? &true .>* &false}

, robot(R).

% :- not &del{*(

%     ?move_h(robot(R)) ;; &true ;; 
%     ?move_v(robot(R)) ;; &true)
     
%     .>? &true .>* &false}

% , robot(R).

% :- not &del{*(

%     ?move_h(robot(R)) ;; &true ;; 
%     ?move_v(robot(R)) ;; &true)
     
%     .>? *(?no_move(robot(R));; &true).>? &true .>* &false}

% , robot(R).

% :- not &del{*(

%     ?move_h(robot(R)) ;; &true ;; 
%     ?move_v(robot(R)) ;; &true)
     
%     .>? &true}

% , robot(R).
