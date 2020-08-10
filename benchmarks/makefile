copy-programs:
	cp -r programs/compute* benchmark-tool/programs
	cp -r programs/runsolver-3.4.0 benchmark-tool
clean-results:
	rm -rf ./results/*
clean-plots:
	rm -rf ./img/*
clean-runscripts:
	rm -rf ./cluster_script__*.sh
	rm -rf ./runscripts/runscript_asprilo_*__*
clean:
	make clean-plots
	make clean-runscripts
plots:
	python plot.py $(ARGS)
ods:
	./compute_all_ods.sh
