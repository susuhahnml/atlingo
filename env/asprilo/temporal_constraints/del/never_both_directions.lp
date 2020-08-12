% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where robots move horizontally and then vertically
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- not &del{
    &true ;;
    *(((? move(robot(R), RIGHT)) + (? move(robot(R), UP)) + (? wait(robot(R))) ) ;; &true) + 
    % *((? move(robot(R), RIGHT) + ? move(robot(R), DOWN) + ? wait(robot(R)) ) ;; &true) + 
    *(((? move(robot(R), LEFT)) + (? move(robot(R), UP)) + (? wait(robot(R))) ) ;; &true) 
    % *((? move(robot(R), RIGHT) + ? move(robot(R), DOWN) + ? wait(robot(R)) ) ;; &true)   
    .>?
    (&true.>* &false) }, 
    
    RIGHT=(1,0), LEFT=(-1,0), UP=(0,-1), DOWN=(0,1), robot(R).