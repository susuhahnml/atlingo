initial_state(8).
prop_id(3).
prop_id(6).
state(3).
state(6).
state(4).
state(7).
state(8).
delta(3,pbf_if(3,pbf_true,pbf_false)).
delta(6,pbf_if(6,pbf_true,pbf_false)).
id_map(0,"tel").
id_map(3,"a").
id_map(2,">").
id_map(6,"b").
id_map(5,">?").
id_map(1,"&").
id_map(7,(">?","b","a")).
id_map(4,(">","a")).
id_map(8,("&",(">","a"),(">?","b","a"))).
last_id(9).
id_map(9,"last").
delta(4,pbf_if(9,pbf_false,pbf_state(3))).
delta(7,pbf_or(pbf_if(3,pbf_true,pbf_false),pbf_and(pbf_if(6,pbf_true,pbf_false),pbf_if(9,pbf_false,pbf_state(7))))).
delta(8,pbf_and(pbf_if(9,pbf_false,pbf_state(3)),pbf_or(pbf_if(3,pbf_true,pbf_false),pbf_and(pbf_if(6,pbf_true,pbf_false),pbf_if(9,pbf_false,pbf_state(7)))))).
