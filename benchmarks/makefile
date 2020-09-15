copy-programs:
	cp -r programs/compute* benchmark-tool/programs
	cp -r programs/runsolver-3.4.0 benchmark-tool
	cp programs/clingo.py benchmark-tool/src/benchmarktool/resultparser
clean-results:
	rm -rf ./results/*
clean-plots:
	rm -rf ./plots/img/*
	rm -rf ./plots/tables/*
	rm -rf ./plots/tikz/*
clean-runscripts:
	rm -rf ./cluster_script__*.sh
	rm -rf ./runscripts/runscript_asprilo_*__*
clean-output:
	rm -rf benchmark-tool/output/*
clean-dfa:
	(cd ../../stage_asp_gitlab ; make clean)
clean:
	rm -rf fault_runsolver.txt
	make clean-plots
	make clean-runscripts
	make clean-output
	make clean-dfa
plots:
	python plot.py $(ARGS)
ods:
	./compute_all_ods.sh
clean-instances:
	rm -rf ./asprilo_instances/structured/*
	rm -rf ./asprilo_instances/gridworld/*
small-instances:
	cp -r ../env/asprilo/asprilo-abstraction-encodings/instances/md/structured/x7_y6_r4 ./asprilo_instances/structured
medium-instances:
	cp -r ../env/asprilo/asprilo-abstraction-encodings/instances/md/structured/x10_y6_r10 ./asprilo_instances/structured
large-instances:
	cp -r ../env/asprilo/asprilo-abstraction-encodings/instances/md/structured/x10_y9_r20 ./asprilo_instances/structured
	cp -r ../env/asprilo/asprilo-abstraction-encodings/instances/md/structured/x10_y10_r20 ./asprilo_instances/structured
	cp -r ../env/asprilo/asprilo-abstraction-encodings/instances/md/structured/x10_y12_r20 ./asprilo_instances/structured
all-instances:
	make medium-instances
	make small-instances
	make large-instances
all-grid:
	cp -r ../env/asprilo/asprilo-abstraction-encodings/instances/md/gridworld/x4_y4_n12_r4 ./asprilo_instances/gridworld
	cp -r ../env/asprilo/asprilo-abstraction-encodings/instances/md/gridworld/x4_y4_n16_r4 ./asprilo_instances/gridworld
	cp -r ../env/asprilo/asprilo-abstraction-encodings/instances/md/gridworld/x5_y5_n20_r5 ./asprilo_instances/gridworld
	cp -r ../env/asprilo/asprilo-abstraction-encodings/instances/md/gridworld/x5_y5_n25_r5 ./asprilo_instances/gridworld