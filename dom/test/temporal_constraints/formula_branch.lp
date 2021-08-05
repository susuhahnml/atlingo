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
%                .>? &t
%             }.

% :- not &del{ p }.


% :- not &del{ ? ((* &t) .>* b) +  ? (&t .>? a) .>? &t }.


:- not &del{ ? ((* &t) .>* ? b ;; &t .>? b) +  ? (&t .>? ?a ;; ?c ;; &t .>? a) .>? &true }.
