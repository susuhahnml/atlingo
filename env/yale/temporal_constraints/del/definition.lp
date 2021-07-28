:- not &del{alive}.
:- not &del{~loaded}.

% Single action per timepoint
:- not &del{ * &true .>* ?load .>* ~shoot}.
:- not &del{ * &true .>* ?shoot.>* ~load}.

% Efect of shoot
:- not &del{ * &true .>* ?shoot ;; ?loaded ;; &true .>* ~alive}.
:- not &del{ * &true .>* ?shoot ;; &true .>* ~loaded}.

% Efect of load
:- not &del{ * &true .>* ?load ;; &true .>* loaded}.

% Intertia
:- not &del{ * &true .>* ? ~alive ;; &true .>* ~alive}.
:- not &del{ * &true .>* ? alive ;; ? ~shoot + ? ~loaded ;; &true .>* alive}.
:- not &del{ * &true .>* ? ~loaded ;; ? ~load  ;; &true .>* ~loaded}.


% force dead
:- not &del{ * &true .>* ?( &true .>* &false) .>* ~alive }.
% force never load
:- not &del{ * &true .>* ~load }.