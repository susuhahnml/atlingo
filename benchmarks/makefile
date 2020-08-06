plots:
	python plot.py $(ARGS)
clean-results:
	rm -rf ./benchmark-tool/results/*
	rm -rf ./benchmark-tool/scripts_asprilo_*
clean-plots:
	rm -rf ./img/*
clean-runscripts:
	rm -rf ./cluster_script__*.sh
	rm -rf ./benchamark-tool/runscripts/_asprio_*__*
ods:
	./compute_all_ods.sh
clean-slurm:
	rm -rf slurm_out/out.*
	rm -rf slurm_out/err.*
clean-all:
	make clean-results
	make clean-plots
	make clean-runscripts
	make clean-slurm
