%Keep reachable states

reachable(F):-initial_state(F).
unfold_reachable(BF):-delta_all(S,BF), reachable(S).

reachable(S):-unfold_reachable(pbf_state(S)).
unfold_reachable(BF1):-unfold_reachable(pbf_if(C,BF1,BF2)).
unfold_reachable(BF2):-unfold_reachable(pbf_if(C,BF1,BF2)).
unfold_reachable(BF1):-unfold_reachable(pbf_and(BF1,BF2)).
unfold_reachable(BF2):-unfold_reachable(pbf_and(BF1,BF2)).
unfold_reachable(BF1):-unfold_reachable(pbf_or(BF1,BF2)).
unfold_reachable(BF2):-unfold_reachable(pbf_or(BF1,BF2)).

state(S):-delta_all(S,BF),reachable(S).
delta(S,BF):-delta_all(S,BF),reachable(S).


% state(S):-state_all(S).
% delta(S,BF):-delta_all(S,BF).