# Analye conflicts and choices
# TODO try with higher horizon and more instances


# #Verify same models
# python plot.py --approach proj-afw  --approach proj-afw_del --approach proj-asp --prefix="proj-6"  --horizon 6 --models 0 --table --stat models --handle_timeout

# python plot.py --approach proj-afw  --approach proj-afw_del --approach proj-asp --prefix="proj-7"  --horizon 7 --models 0 --table --stat models --handle_timeout

# Analize conflicts and choices
python plot.py --approach afw  --approach afw_del --approach asp --approach nc --prefix="conflicts-7"  --horizon 7 --models 0 --table --stat conflicts --mean --ignore_prefix structured/x10 

python plot.py --approach afw  --approach afw_del --approach asp --approach nc --prefix="choices-7"  --horizon 7 --models 0 --table --stat choices --mean  --ignore_prefix structured/x10 

# Analize times

python plot.py --approach afw --approach asp --approach afw_del --prefix="time-7-"  --horizon 7  --stat ctime --models 0 --y="time (sec)" --mean --ignore_prefix structured/x10  --approach nc

python plot.py --approach afw --approach afw_del --prefix="time-8-"  --horizon 8  --stat ctime --models 0 --y="time (sec)" --mean --ignore_prefix structured/x10 


# Analize size

python plot.py --approach afw --approach asp --approach afw_del --prefix="vars"  --horizon 7  --stat vars --models 0 --approach nc --ignore_prefix structured/x10 

python plot.py --approach afw --approach asp --approach afw_del --prefix="atoms"  --horizon 7  --stat atoms --models 0 --approach nc --ignore_prefix structured/x10 

python plot.py --approach afw --approach asp --approach afw_del --prefix="rules-bodies"  --horizon 7  --stat rules --models 0 --approach nc  --stat bodies  --ignore_prefix structured/x10

python plot.py --approach afw --approach asp --approach afw_del --prefix="costraints"  --horizon 7  --stat cons --models 0 --approach nc --ignore_prefix structured/x10 



# Analize scalability of del and tel

python plot.py --approach afw_del --prefix="scale"  --horizon 20 --horizon 25 --horizon 30 --horizon  35  --stat ctime --models 1 --y="time (sec)" --mean --group --plot_type=line  --approach afw  --ignore_timeout 





# python plot.py --approach grid-afw --approach grid-afw_del --prefix="time-7-"  --horizon 4  --stat ctime --models 0 --y="time (sec)" --mean  --approach grid-nc --approach grid-asp