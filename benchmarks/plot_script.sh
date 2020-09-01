# Analye conflicts and choices
# TODO try with higher horizon and more instances


# #Verify same models
# python plot.py --approach proj-afw  --approach proj-afw_del --approach proj-asp --prefix="proj-6"  --horizon 6 --models 0 --table --stat models --handle_timeout

# python plot.py --approach proj-afw  --approach proj-afw_del --approach proj-asp --prefix="proj-7"  --horizon 7 --models 0 --table --stat models --handle_timeout


python plot.py --approach afw  --approach afw_del --approach asp --prefix="choices-6"  --horizon 6 --models 0 --table --stat choices --handle_timeout

python plot.py --approach afw  --approach afw_del --approach asp --prefix="choices-7"  --horizon 7 --models 0 --table --stat choices --handle_timeout

python plot.py --approach afw  --approach afw_del --approach asp --prefix="conflicts-7"  --horizon 7 --models 0 --table --stat conflicts --mean --handle_timeout


python plot.py --approach afw --approach asp --approach afw_del --prefix="time-7-"  --horizon 7  --stat ctime --stat csolve --models 0 --handle_timeout --y="time (sec)"

python plot.py --approach afw_del --prefix="scale"  --horizon 20 --horizon 25 --horizon 30 --horizon  35  --stat ctime --models 1 --y="time (sec)" --mean --group --plot_type=line  --approach afw


python plot.py --approach afw --approach asp --approach afw_del --prefix="final-vars"  --horizon 35  --stat vars --models 1 --handle_timeout 

python plot.py --approach afw --approach asp --approach afw_del --prefix="final-atoms"  --horizon 35  --stat atoms --models 1 --handle_timeout 