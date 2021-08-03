right((1,0)).
left((-1,0)).
up((0,-1)).
down((0,1)).

:- not &del{
           *(  *(&true ;; ?waits(robot(R))) ;; %Waits before starting sequence
           
               (  *(&true ;; (?move(robot(R),RIGHT))) + %Move horizonatally in one direction
                  *(&true ;; (?move(robot(R),LEFT)))
               ) ;; 
               *(&true ;; ?move(robot(R),UP) ) ;; %Move up

              &true ;; ?pickup_atlingo(robot(R)) ;;  %Pickup

               (  *(&true ;; (?move(robot(R),RIGHT))) + %Move horizonatally in one direction
                  *(&true ;; (?move(robot(R),LEFT)))
               ) ;; 
               *(&true ;; ?move(robot(R),UP) ) ;; %Move up

              &true ;; ?process_atlingo(robot(R));; ?waits(robot(R)) ;; %Deliver 

               (  *(&true ;; (?move(robot(R),RIGHT))) + %Move horizonatally in one direction
                  *(&true ;; (?move(robot(R),LEFT)))
               ) ;; 
                  *(&true ;; ?move(robot(R),DOWN) ) ;; %Move down
               
               &true ;; ?putdown_atlingo(robot(R))) %Move putdown shelve
		   ;; *(&true ;; ?waits(robot(R))) %End with waiting
        .>? &true.>* &false }, 
   robot(R), up(UP), right(RIGHT), left(LEFT), down(DOWN).


%   < * (wait* ;; (right* + left*) ;; up* ;; pickup ;; (right* + left*) ;; up* ;; deliver ;; (right* + left*) ;; down* ;; putdown) > L