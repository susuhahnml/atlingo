% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where robots move horizontally and then vertically
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% :- not &del{
%     (
%         * ( &true ;; ( ? move_horizontally(robot(R)) + ? wait(robot(R)))) ;; 
%         * ( &true ;; ( ? move_vertically(robot(R)) + ? wait(robot(R)))) 
%     ) .>?
%     (&true.>* &false)   }, robot(R).


% :- not &del{
%        (* ( ( ? no_move_vertically(robot(R)) ) ;; &true ))  .>? 
%         ( (* &true ) .>* no_move_horizontally(robot(R)) )
% }, robot(R).

% :- not &del{
%        &true .>? (* ( ( ? no_move_vertically(robot(R)) ) ;; &true ))  .>? 
%         ( (* &true ) .>* no_move_horizontally(robot(R)) )
% }, robot(R).

:- not &del{
       (* ( ( ? no_move_vertically(robot(R)) ) ;; &true ))  .>? 
        ( (* &true ) .>* no_move_horizontally(robot(R)) )
}, robot(R).

% :- not &del{
%        (* ( ( ? no_move_vertically(robot(1)) ) ;; &true ))  .>? 
%         ( (* &true ) .>* no_move_horizontally(robot(1)) )
% }.