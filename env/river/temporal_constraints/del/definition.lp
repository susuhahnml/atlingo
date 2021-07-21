:- not &del{ at(X,r)}, 
    thing(X).

% Cant be in both sides at the same time
:- not &del{ * &true .>*  ? at(X,S) .>* ~ at(X,S') }, 
    thing(X), side(S), side(S'), S!=S'.
% Cant be in none of the sides
:- not &del{ * &true .>*  ? ~ at(X,S) .>* at(X,S') }, 
    thing(X), side(S), side(S'), S!=S'.


% Boat always moves except last step
:- not &del{ * &true .>* ?take(boat) + ?(&true .>* &false) .>? &true}.

% Can only take things that are on your side
:- not &del{ * &true .>* ?take(X) .>* ?at(boat,S) ;; ?at(X,S) .>? &true }, 
    thing(X), side(S).

% Cant take more than one thing
:- not &del{ * &true .>*  ?take(X) ;; ?take(Y) .>* &false }, 
    thing(X), thing(Y), X!=boat, Y!=boat, X<Y.


% Consecuence of taking
:- not &del{ * &true .>*  ?take(X) ;; ?at(X,S) .>* &true .>? at(X,S') }, 
    thing(X), side(S), side(S'), S!=S'.


% Inertia
:- not &del{ * &true .>*  ? ~take(X) ;; ?at(X,S) .>* &true .>? at(X,S) }, 
    thing(X), side(S).

% Conditions for eating
:- not &del{ * &true .>*  ? at(f,S);; ?at(c,S) .>* at(boat,S)}, side(S).
:- not &del{ * &true .>*  ? at(c,S);; ?at(g,S) .>* at(boat,S)}, side(S).


% Goal
:- not &del{ * &true .>?  ? at(c,l);; ?at(g,l) .>? at(f,l) }.
