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


% :- not &del{  ? (* &true .>* b) ;; &true .>? a }.

% :- not &del{  ? (* &true .>* b) ;; ?(* &true .>? ~b) ;; &true .>? a }.


% :- not &del{ * &true .>* ?p ;; ?q .>? &true}.


% :- not &del{  ? (&true .>* &false) ;; ? (?p ;; &true .>? q ) .>? &true}. %Empty
% :- not &del{  ? (&true .>* &false) ;; ?p .>? &true}. %Not Empty
% :- not &del{  ? (?p ;; &true ;; ?p ;; &true .>? &true .>* &false ) ;; ? (?p ;; &true .>? &true .>* &false ) .>? &true}. %Empty problematic because of last

:- not &del{  ? (?p ;; &true ;; ? ~q ;; &true .>? &true .>* &false ) ;; ? (?p ;; &true ;; ?q ;; &true .>? &true .>* &false ) .>? &true}. %Empty
