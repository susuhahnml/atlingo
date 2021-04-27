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