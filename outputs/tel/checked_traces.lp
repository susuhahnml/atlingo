Answer: 1
holds(8,0).
holds(3,1).
holds(14,1).
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(14,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
node_run_unfold(pbf_id(4),1,node_run(id(4),0,root)).
node_run(id(4),1,node_run(id(4),0,root)).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(14,pbf_false,pbf_id(4))),2,node_run(id(4),1,node_run(id(4),0,root))).
node_run_unfold(pbf_decide(14,pbf_false,pbf_id(4)),1,node_run(id(4),0,root)).
node_run_unfold(pbf_true,2,node_run(id(4),1,node_run(id(4),0,root))).
node_run_unfold(pbf_decide(3,pbf_true,pbf_false),2,node_run(id(4),1,node_run(id(4),0,root))).
node_run(true,2,node_run(id(4),1,node_run(id(4),0,root)))
SATISFIABLE

Models       : 1
Calls        : 1
Time         : 0.010s (Solving: 0.00s 1st Model: 0.00s Unsat: 0.00s)
CPU Time     : 0.009s
