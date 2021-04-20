% right((1,0)).
% left((-1,0)).
% up((0,-1)).
% down((0,1)).

right((1,0)).
left((-1,0)).
up((0,-1)).
down((0,1)).

:- not &del{
           *( *(&true ;; ?move_atlingo(robot(R))) ;; %Move towards shelve
              *(&true ;; ?pickup_atlingo(robot(R))) ;;  %Pickup
              *(&true ;; ?move_atlingo(robot(R))) ;;  %Move towards pick station
              &true ;; ?process_atlingo(robot(R));; ?waits(robot(R)) ;; %Deliver 
              *(&true ;; ?move_atlingo(robot(R)));; %Move to dropping place
               &true ;; ?putdown_atlingo(robot(R))) %Move putdown shelve
		   ;; *(&true ;; ?waits(robot(R))) %End with waiting
        .>? &true.>* &false }, 
   robot(R).


:- not &del{ * &true .>* % Always
            ?move(robot(R),D_R) ;; &true .>*  %Goining right implies 
               *( ? ~ move(robot(R),D_L);; &true) .>? % Not going left
               (?pickup_atlingo(robot(R)) + ?process_atlingo(robot(R)) + ?putdown_atlingo(robot(R))) %Until can change
               .>? &true
            
            },
            robot(R),right(D_R),left(D_L).

:- not &del{ * &true .>* % Always
            ?move(robot(R),D_L) ;; &true .>*  %Goining right implies 
               *( ? ~ move(robot(R),D_R);; &true) .>? % Not going left
               (?pickup_atlingo(robot(R)) + ?process_atlingo(robot(R)) + ?putdown_atlingo(robot(R))) %Until can change
               .>? &true
            
            },
            robot(R),right(D_R),left(D_L).

:- not &del{ * &true .>* 
            ?move(robot(R),D_U) ;; &true .>*  
               *( ? ~ move(robot(R),D_D);; &true) .>? 
               (?pickup_atlingo(robot(R)) + ?process_atlingo(robot(R)) + ?putdown_atlingo(robot(R))) 
               .>? &true
            
            },
            robot(R),up(D_U),down(D_D).

:- not &del{ * &true .>* 
            ?move(robot(R),D_D) ;; &true .>*  
               *( ? ~ move(robot(R),D_U);; &true) .>? 
               (?pickup_atlingo(robot(R)) + ?process_atlingo(robot(R)) + ?putdown_atlingo(robot(R))) 
               .>? &true
            
            },
            robot(R),up(D_U),down(D_D).