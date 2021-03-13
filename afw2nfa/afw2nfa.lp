nfa_initial_state(ID):-initial_state(ID).
nfa_state(0,ID):-nfa_initial_state(ID).

% delta(ID_NFA, (())nfa_state(ID_NFA,ID_AWF),delta(ID_AWF,(Case,Type,A),ID_NEXT).
delta_nfa(ID_NFA, (Case,Type,A), ID_NEXT):-  nfa_state(ID_NFA,ID_AWF),delta(ID_AWF,(Case,Type,A),ID_NEXT).

initial_state(0).
prop(10,"b").
prop(14,"a").
prop(16,"last").
state(0,diamond(sequence(test(box(star(top),prop(10))),top),prop(14))).
state(2,box(star(top),prop(10))).
state(1,prop(14)).
delta(0,(((1,0),1),out,16),2).
delta(0,(((1,0),1),out,16),1).
delta(0,(((1,0),1),in,10),true).
delta(2,((0,0),in,10),true).
delta(2,((1,0),in,10),true).
delta(2,((0,0),in,16),true).
delta(2,((1,0),out,16),2).
delta(1,(0,in,14),true).