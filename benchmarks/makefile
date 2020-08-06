plots:
	python plot.py $(ARGS)
clean-results:
	rm -rf ./results/*
clean-plots:
	rm -rf ./img/*
clean-runscripts:
	rm -rf ./cluster_script__*.sh
	rm -rf ./runscripts/_asprio_*__*
ods:
	./compute_all_ods.sh
clean-slurm:
	rm -rf slurm_out/out.*
	rm -rf slurm_out/err.*
clean-gen-out:
	rm -rf ./benchmark-tool/output/*
clean-all:
	make clean-plots
	make clean-runscripts
	make clean-slurm
	make clean-gen-out
