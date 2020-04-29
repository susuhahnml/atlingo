Answer: 1
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(200,1).
node_run_unfold(pbf_decide(3,pbf_true,pbf_false),1,node_run(id(4),0,root))
Answer: 2
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(3,0).
holds(200,1).
node_run_unfold(pbf_decide(3,pbf_true,pbf_false),1,node_run(id(4),0,root))
Answer: 3
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(3,1).
holds(200,1).
node_run_unfold(pbf_decide(3,pbf_true,pbf_false),1,node_run(id(4),0,root))
Answer: 4
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(3,0).
holds(3,1).
holds(200,1).
node_run_unfold(pbf_decide(3,pbf_true,pbf_false),1,node_run(id(4),0,root))
Answer: 5
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(200,1).
node_run_unfold(pbf_decide(200,pbf_false,pbf_id(4)),1,node_run(id(4),0,root))
Answer: 6
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(3,0).
holds(200,1).
node_run_unfold(pbf_decide(200,pbf_false,pbf_id(4)),1,node_run(id(4),0,root))
Answer: 7
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(3,1).
holds(200,1).
node_run_unfold(pbf_decide(200,pbf_false,pbf_id(4)),1,node_run(id(4),0,root))
Answer: 8
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(3,0).
holds(3,1).
holds(200,1).
node_run_unfold(pbf_decide(200,pbf_false,pbf_id(4)),1,node_run(id(4),0,root))
Answer: 9
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(200,0).
node_run_unfold(pbf_decide(3,pbf_true,pbf_false),1,node_run(id(4),0,root))
Answer: 10
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(3,0).
holds(200,0).
node_run_unfold(pbf_decide(3,pbf_true,pbf_false),1,node_run(id(4),0,root))
Answer: 11
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(200,0).
node_run_unfold(pbf_decide(200,pbf_false,pbf_id(4)),1,node_run(id(4),0,root))
Answer: 12
node_run(id(4),0,root).
node_run_unfold(pbf_or(pbf_decide(3,pbf_true,pbf_false),pbf_decide(200,pbf_false,pbf_id(4))),1,node_run(id(4),0,root)).
holds(3,0).
holds(200,0).
node_run_unfold(pbf_decide(200,pbf_false,pbf_id(4)),1,node_run(id(4),0,root))
SATISFIABLE

Models       : 12
Calls        : 1
Time         : 0.010s (Solving: 0.00s 1st Model: 0.00s Unsat: 0.00s)
CPU Time     : 0.010s
