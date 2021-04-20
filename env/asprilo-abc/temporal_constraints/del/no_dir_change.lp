right((1,0)).
left((-1,0)).
up((0,-1)).
down((0,1)).

:- not &del{ * &true .>* 
            ?move(robot(R),D_R) ;; &true .>*  
               *( ? ~ move(robot(R),D_L);; &true) .>? 
               (?pickup_atlingo(robot(R)) + ?process_atlingo(robot(R)) + ?putdown_atlingo(robot(R))) 
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