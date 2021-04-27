right((1,0)).
left((-1,0)).
up((0,-1)).
down((0,1)).

:- not &del{
           *(  *(&true ;; ?waits(robot(R))) ;;
           
               (  *(&true ;; (?move(robot(R),RIGHT))) + 
                  *(&true ;; (?move(robot(R),LEFT)))
               ) ;; 
               *(&true ;; ?move(robot(R),UP) ) ;; 

              &true ;; ?pickup_atlingo(robot(R)) ;;  %Pickup

               (  *(&true ;; (?move(robot(R),RIGHT))) + 
                  *(&true ;; (?move(robot(R),LEFT)))
               ) ;; 
               *(&true ;; ?move(robot(R),UP) ) ;; 

              &true ;; ?process_atlingo(robot(R));; ?waits(robot(R)) ;; %Deliver 

               (  *(&true ;; (?move(robot(R),RIGHT))) + 
                  *(&true ;; (?move(robot(R),LEFT)))
               ) ;; 
                  *(&true ;; ?move(robot(R),DOWN) ) ;; 
               
               &true ;; ?putdown_atlingo(robot(R))) %Move putdown shelve
		   ;; *(&true ;; ?waits(robot(R))) %End with waiting
        .>? &true.>* &false }, 
   robot(R), up(UP), right(RIGHT), left(LEFT), down(DOWN).