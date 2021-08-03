:- not &del{    &true ;; ?move(1) ;;
                *( 
                   &true ;; ? ~move(1) ;; ?move ;;   %Move another disk
                   &true ;; ?move(1)     %Move disk 1
                ) ;;  
                * (&true ;; ? ~move ) % Dont move
              .>? 
              &true .>* &false %Final state
            }.
             