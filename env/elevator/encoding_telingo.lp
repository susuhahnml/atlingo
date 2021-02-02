#program always.

{wait; up; down; serve} = 1 :- not &final.
:- up,   at(X), not floor(X+1).
:- down, at(X), not floor(X-1).

at(X+1):- 'up,   'at(X).
at(X-1):- 'down, 'at(X).
at(X)  :- 'at(X), not 'up, not 'down.
served(X):-at(X),serve.
called(X):- 'called(X), not served(X).

:- called(X), &final.

ready :- called(X), at(X).

#program initial.

% :- not &del{ up .>? down }.
:- not &del{ *( (*up + *down) ;; ?ready ;; serve)
	 ;; *wait .>? &final }.