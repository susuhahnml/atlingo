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
% :- not &del{  ( * ( (?p ;; &true) + (?q ;; &true ;; ?r)) ;; (?c + (?d ;; &true))) .>? ?(* &true ;; ?q .>* p) .>? a}.

% :- not &del{ (*(&true ;; ?p) ;; ?b ;; *(&true ;; ?q)) .>? &true .>* &false }.

% :- not &del{ * &true .>* 
%             ?p ;; &true .>*  
%                *( ? ~ q;; &true) .>? 
%                (?a + ?b + ?c) 
%                .>? &true
%             }.

% :- not &del{ p }.


% :- not &del{ ? ((* &true) .>* b) +  ? (&true .>? a) .>? &true }.


:- not &del{ ? ((* &true) .>* ? b ;; &true .>? b) +  ? (&true .>? ?a ;; ?c ;; &true .>? a) .>? &true }.
