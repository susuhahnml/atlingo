:- not &del{alive}.
:- not &del{~loaded}.
    
:- not &del{ * &true .>* ?load .>* ~shoot}.
:- not &del{ * &true .>* ?shoot.>* ~load}.

:- not &del{ * &true .>* ?shoot ;; ?loaded ;; &true .>* ~alive}.
:- not &del{ * &true .>* ?shoot ;; &true .>* ~loaded}.

:- not &del{ * &true .>* ?load ;; &true .>* loaded}.

:- not &del{ * &true .>* ? ~alive ;; &true .>* ~alive}.
:- not &del{ * &true .>* ? alive ;; ? ~shoot + ? ~loaded ;; &true .>* alive}.
:- not &del{ * &true .>* ? ~loaded ;; ? ~load  ;; &true .>* ~loaded}.


% force dead
:- not &del{ * &true .>* ?( &true .>* &false) .>* ~alive }.
% force never load
% :- not &del{ * &true .>* ~load }.