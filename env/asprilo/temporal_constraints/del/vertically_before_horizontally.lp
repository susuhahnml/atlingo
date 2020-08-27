% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where robots move horizontally and then vertically
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% :- not &del{
%     (
%         * ( &true ;; ( ? move_vertically(robot(R)) + ? wait(robot(R)))) ;; 
%         * ( &true ;; ( ? move_horizontally(robot(R)) + ? wait(robot(R)))) 
%     ) .>?
%     (&true.>* &false)   }, robot(R).

:- not &del{
       (* ( ( ? no_move_horizontally(robot(R)) ) ;; &true ))  .>? 
        ( (* &true ) .>* no_move_vertically(robot(R)) )
}, robot(R).