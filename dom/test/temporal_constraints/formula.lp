% :- not &del{ ?a .>* (* &t .>? ~a) }.
% :- not &del{  ? (* &t .>* b(1)) .>? (&t .>? a) }.
% :- not &del{ * &t .>* ?a + ?b .>? &t }.
% :- not &del{ ?a ;; &t .>* b }.
% :-not &del{  &t ;; &t .>? p}.
% :- not &del{ &t }.
% :- not &del{ ?a ;..>* b }.
% :- not &del{ &false }.
% :- not &del{ * &t .>? p}.
% :- not &del{  ? (* &t .>? p) ;; &t .>? q }.
% :- not &del{  ? (* &t .>? p) ;; &t .>? q }.
% :- not &del{  ( * ( (?p ;; &t) + (?q ;; &t ;; ?r)) ;; (?c + (?d ;; &t))) .>? ?(* &t ;; ?q .>* p) .>? a}.

% :- not &del{ (*(&t ;; ?p) ;; ?b ;; *(&t ;; ?q)) .>? &t .>* &false }.

% :- not &del{ * &t .>* 
%             ?p ;; &t .>*  
%                *( ? ~ q;; &t) .>? 
%                (?a + ?b + ?c) 
%                .>? &true
%             }.

% :- not &del{ p }.


% :- not &del{  ? (* &t .>* b) ;; &t .>? a }.

% :- not &del{  ? (* &t .>* b) ;; ?(* &t .>? ~b) ;; &t .>? a }.


% :- not &del{ * &t .>* ?p ;; ?q .>? &true}.


% :- not &del{  ? (&t .>* &false) ;; ? (?p ;; &t .>? q ) .>? &true}. %Empty
% :- not &del{  ? (&t .>* &false) ;; ?p .>? &true}. %Not Empty
% :- not &del{  ? (?p ;; &t ;; ?p ;; &t .>? &t .>* &false ) ;; ? (?p ;; &t .>? &t .>* &false ) .>? &true}. %Empty problematic because of last

:- not &del{  ? (?p ;; &t ;; ? ~q ;; &t .>? &t .>* &false ) ;; ? (?p ;; &t ;; ?q ;; &t .>? &t .>* &false ) .>? &true}. %Empty
