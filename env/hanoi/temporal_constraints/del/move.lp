% Has the last step free to do anything...

:- not &del{     &true ;; %One step tp start in time 1
                *( ?move(1) ;; &true ;;   %Move disk 1
                    ? ~move(1) ;; ?move ;; &true   %Move another disk
                ) ;;  
                * (? ~move ;; &true)  % Dont move
                % ;; ?move(1) 
              .>? 
              &true .>* &false %Final state
            }.
