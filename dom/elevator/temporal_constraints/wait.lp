% :- not &del{ *( (*(?up ;; &true) + *(?down ;; &true)) ;; ?ready;; ?serve;; &true)
% :- not &del{ ( *(?up ;; &true) ;; ?serve ;; &true ;; ?down ;; &true ;; ?down ;; &true ;; ?down ;; &true ;; ?down ;; &true ;; ?serve ;; &true) .>? &true .>* &false}.
:- not &del{ * &true .>? wait}.