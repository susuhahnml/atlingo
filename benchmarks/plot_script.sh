python plot.py --approach afw --approach asp --approach afw_del --prefix="time-7"  --horizon 7  --stat ctime --models 0 --y="time (sec)" --mean --ignore_prefix structured/x10  --approach nc --tikz

python plot.py --approach afw --approach asp --approach afw_del --prefix="rules-bodies-20"  --horizon 20  --stat rules --models 1 --approach nc  --stat bodies --mean --tikz --group


python plot.py --approach afw_del --prefix="scale"  --horizon 20 --horizon 25 --horizon 30 --horizon  35  --stat ctime --models 1 --y="time (sec)" --mean --group --plot_type=line  --approach afw  --tikz

python plot.py --approach grid-afw  --approach grid-afw_del --approach grid-asp --approach grid-nc --prefix="grid-conflicts-5"  --horizon 5 --models 0 --table --stat conflicts --mean

python plot.py --approach grid-afw  --approach grid-afw_del --approach grid-asp --approach grid-nc --prefix="grid-choices-5"  --horizon 5 --models 0 --table --stat choices --mean  --ignore_prefix structured/x10 
