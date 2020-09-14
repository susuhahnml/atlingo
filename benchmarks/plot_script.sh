# Analye conflicts and choices
# TODO try with higher horizon and more instances


# #Verify same models
# python plot.py --approach proj-afw  --approach proj-afw_del --approach proj-asp --prefix="proj-5"  --horizon 6 --models 0 --table --stat models --handle_timeout

# python plot.py --approach proj-afw  --approach proj-afw_del --approach proj-asp --prefix="proj-7"  --horizon 7 --models 0 --table --stat models --handle_timeout

# # Analize conflicts and choices
# python plot.py --approach afw  --approach afw_del --approach asp --approach nc --prefix="conflicts-7"  --horizon 7 --models 0 --table --stat conflicts --mean --ignore_prefix structured/x10 

# python plot.py --approach afw  --approach afw_del --approach asp --approach nc --prefix="choices-7"  --horizon 7 --models 0 --table --stat choices --mean  --ignore_prefix structured/x10 

# Analize times

python plot.py --approach afw --approach asp --approach afw_del --prefix="time-7"  --horizon 7  --stat ctime --models 0 --y="time (sec)" --mean --ignore_prefix structured/x10  --approach nc --tikz

# python plot.py --approach afw --approach afw_del --prefix="time-8-"  --horizon 8  --stat ctime --models 0 --y="time (sec)" --mean --ignore_prefix structured/x10 


# Analize size

# python plot.py --approach afw --approach asp --approach afw_del --prefix="vars"  --horizon 7  --stat vars --models 0 --approach nc --ignore_prefix structured/x10 --mean

# python plot.py --approach afw --approach asp --approach afw_del --prefix="atoms"  --horizon 7  --stat atoms --models 0 --approach nc --ignore_prefix structured/x10 --mean

python plot.py --approach afw --approach asp --approach afw_del --prefix="rules-bodies-20"  --horizon 20  --stat rules --models 1 --approach nc  --stat bodies --mean --tikz --group


# Analize scalability of del and tel

python plot.py --approach afw_del --prefix="scale"  --horizon 20 --horizon 25 --horizon 30 --horizon  35  --stat ctime --models 1 --y="time (sec)" --mean --group --plot_type=line  --approach afw  --tikz


############################## #Analize grid 


# Analize conflicts and choices
python plot.py --approach grid-afw  --approach grid-afw_del --approach grid-asp --approach grid-nc --prefix="grid-conflicts-5"  --horizon 5 --models 0 --table --stat conflicts --mean

python plot.py --approach grid-afw  --approach grid-afw_del --approach grid-asp --approach grid-nc --prefix="grid-choices-5"  --horizon 5 --models 0 --table --stat choices --mean  --ignore_prefix structured/x10 

# Analize times

# python plot.py --approach grid-afw --approach grid-asp --approach grid-afw_del --prefix="grid-time-5-"  --horizon 5  --stat ctime --models 0 --y="time (sec)" --ignore_prefix structured/x10  --approach grid-nc


# Analize size

# python plot.py --approach grid-afw --approach grid-asp --approach grid-afw_del --prefix="grid-vars"  --horizon 5  --stat vars --models 0 --approach grid-nc --ignore_prefix structured/x10 --mean

# python plot.py --approach grid-afw --approach grid-asp --approach grid-afw_del --prefix="grid-atoms"  --horizon 5  --stat atoms --models 0 --approach grid-nc --ignore_prefix structured/x10 --mean

# python plot.py --approach grid-afw --approach grid-asp --approach grid-afw_del --prefix="grid-rules-bodies"  --horizon 5  --stat rules --models 0 --approach grid-nc  --stat bodies  --ignore_prefix structured/x10 --mean --tikz



# Analize scalability of del and tel

# python plot.py --approach grid-afw_del --prefix="grid-scale"  --horizon 20 --horizon 25 --horizon 30 --horizon  35  --stat ctime --models 1 --y="time (sec)" --mean --group --plot_type=line  --approach grid-afw  --tikz


# python plot.py --approach grid-afw --approach grid-afw_del --prefix="time-7"  --horizon 4  --stat ctime --models 0 --y="time (sec)" --mean  --approach grid-nc --approach grid-asp




# python plot.py --approach afw_del --prefix="time-one-model"  --horizon 30  --stat ctime --models 1 --y="time (sec)" --mean --group --approach afw  --approach nc --approach asp







# python plot.py --approach grid-afw --approach grid-asp --approach grid-afw_del --prefix="grid-time-5-"  --horizon 5  --stat ctime --models 0 --y="time (sec)" --ignore_prefix structured/x10  --approach grid-nc

# python plot.py --approach afw --approach asp --approach afw_del --prefix="models-7"  --horizon 7  --stat models --models 0 --y="models" --mean --ignore_prefix structured/x10  --approach nc --tikz


# python plot.py --approach afw --approach afw_del --prefix="stime"  --horizon 20  --stat ctime --stat csolve --models 1 --y="time (sec)" --mean --ignore_prefix structured/x10


#  python plot.py --approach grid-afw  --approach grid-afw_del --approach grid-asp --approach grid-nc --prefix="grid-conflicts-status-5"  --horizon 5 --models 0 --table --stat conflicts --stat status

#  python plot.py --approach grid-afw  --approach grid-afw_del --approach grid-asp --approach grid-nc --prefix="grid-choices-status-5"  --horizon 5 --models 0 --table --stat choices --stat status