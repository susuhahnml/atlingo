clingo version 5.4.0
Reading from afw2nfa/afw2nfa.lp
Solving...
Answer: 1
prop(9,"b").
 prop(13,"a").
 prop(15,"last").
 initial_state_nfa(1).
 state_nfa(0,()).
 state_nfa(1,(0,())).
 state_nfa(2,(1,())).
 state_nfa(4,(2,())).
 state_nfa(6,(1,(2,()))).
 final_state_nfa(0).
 delta_nfa(0,(0,in,true),0).
 delta_nfa(1,(1,out,15),6).
 delta_nfa(4,(1,out,15),4).
 delta_nfa(6,((0,1),out,15),4).
 delta_nfa(6,((0,1),in,13),4).
 delta_nfa(1,(0,out,15),2).
 delta_nfa(1,(0,in,9),2).
 delta_nfa(4,(0,in,9),0).
 delta_nfa(2,(0,in,13),0).
 delta_nfa(6,((0,0),in,13),0).
 delta_nfa(6,((0,0),in,9),0).

SATISFIABLE

Models       : 1
Calls        : 1
Time         : 0.046s (Solving: 0.00s 1st Model: 0.00s Unsat: 0.00s)
CPU Time     : 0.046s
