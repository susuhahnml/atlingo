:- not &del{     &true ;; %One step tp start in 1
                *( ?move(1) ;; &true ;;   %Move disk 1
                    ? ~smallestfree(D) + 
                    (? smallestfree(D) ;; ?move(D)) ;; &true   %Move another disk
                ) ;;  
                * (? ~move ;; &true) % Dont move
              .>? 
              &true .>* &false %Final state
            },
            disk(D), D!=1.