Answer: 1
node_run(id(box(sequence(check(prop(5)),top),prop(12))),0,root).
node_run(id(prop(12)),1,node_run(id(box(sequence(check(prop(5)),top),prop(12))),0,root)).
node_run(true,2,node_run(id(prop(12)),1,node_run(id(box(sequence(check(prop(5)),top),prop(12))),0,root)))
SATISFIABLE

Models       : 1
Calls        : 1
Time         : 0.015s (Solving: 0.00s 1st Model: 0.00s Unsat: 0.00s)
CPU Time     : 0.015s
