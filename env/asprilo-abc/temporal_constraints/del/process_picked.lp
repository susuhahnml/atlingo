:- not &del{
      (* &true) .>* % Always
      ?pickup(robot(R),shelf(S)) .>* %If picks up
      *(&true ;; ?move_atlingo(robot(R)) + ?waits(robot(R))) %Move or wait
      ;; ?process_atlingo(robot(R),shelf(S)) .>? %Untill process
      &true},
   robot(R), shelf(S).