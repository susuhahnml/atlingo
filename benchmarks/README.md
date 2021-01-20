# Benchmarks

For the benchmarking we use the benchmarking tool as a submodule installed. We provide a set of useful commands and scripts. 

The files found in [./benchmarks/programs](../benchmarks/programs) correspond to our particular approach and are copied to the submodule folder to be used by the tool. A especial treatment of the scripts was needed to account for the preprocessing of each instance.

We use the following scripts to automatize the jobs for the benchmarks in the cluster.

##### [./run_bm.sh](./run_bm.sh) 
- Generates run-script by duplicates the master-run-script and replacing special parameters.
- Calls `./bgen` to generate benchmarking scripts from the benchmarking tool.
- Runs the start files for each instance. Such files will make a call to slurm for adding a process to the queue with `sbatch`.
- Waits for the users slurm queue to be empty.
- Checks output for errors.
- Calls `./beval` to scrap the stats to a xml file
- Checks output for errors, if an error was found then shows the output with the internal error.
- Calls `./bgen` to generate the .ods file with all results.
- Cleans output
- All results are saved in [./results](./results) inside the folder corresponding to the environment

##### [./batch_all.sh](./batch_all.sh) 
- Cleans environment.
- Makes a series of calls to `./run_bm.sh` with different parameters.
- Gathers result summary
- Sends email to notify that evaluation finished.

##### [./compute_all_ods.sh](./compute_all_ods.sh) 
- Computes all the .ods files from the results


## Plots

A python plot script was created matching the patterns from our personalized benchmarks. 
This script takes the precalculated .ods results and generates images, tables and tikz files. 

```shell
$ python plot.py -h

  --plot_type 
                        Plot type, bar or line (default: bar)
  --stat                Status: choices,conflicts,cons,csolve,ctime,error,mem,
                        memout,models,ngadded,optimal,restarts,status,time,tim
                        eout,vars (default: None)
  --approach            Approach to be plotted awf, asp, nc or dfa. Can pass
                        multiple (default: None)
  --constraint 
                        Contraint to be plotted, if non is passed all
                        constraints will be plotted. Can pass multiple
                        (default: None)
  --horizon HORIZON     Horizon to be plotted. Can pass multiple (default:
                        None)
  --models MODELS       Number of models computed in the benchmark with clingo
                        -n (default: 1)
  --prefix PREFIX       Prefix of output files (default: )
  --plotmodels          When this flag is passed, the number of models in
                        plotted (default: False)
  --group               When this flag is passed, instances are grouped
                        (default: False)
  --mean                When this flag is passed, only average will be
                        computed per instance.Necessary for no-constraint
                        (default: False)
  --bars                When this flag is passed, will print bar for one
                        approach with all times (default: False)
  --y Y                 Name of the y axis (default: None)
  --ignore_timeout      If passed the timeouts will not be ploted like dots
                        (default: False)
  --zero_timeout        If passed the timeouts will be ploted with 0 (default:
                        False)
  --tikz                If passed tikz file will be saved (default: False)
  --table               If passed a csv with information file will be saved
                        (default: False)
  --ignore_prefix       Prefix to ignore in the instances (default: None)
  --ignore_any          Any to ignore in the instances (default: None)
```

