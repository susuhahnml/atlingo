% :- not &del{ ?a .>* (* &true .>? ~a) }.
% :- not &del{  ? (* &true .>* b(1)) .>? (&true .>? a) }.
% :- not &del{ * &true .>* ?a + ?b .>? &true }.
% :- not &del{ ?a ;; &true .>* b }.
% :-not &del{  &true ;; &true .>? p}.
% :- not &del{ &true }.
% :- not &del{ ?a ;..>* b }.
% :- not &del{ &false }.
% :- not &del{ * &true .>? p}.
% :- not &del{  ? (* &true .>? p) ;; &true .>? q }.
% :- not &del{  ? (* &true .>? p) ;; &true .>? q }.
% :- not &del{  * ( ?p  + ?q ;; &true) .>? q }.

:- not &del{ (*(?p ;; &true) + *(?q ;; &true)) .>? &true }.