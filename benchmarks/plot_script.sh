# Analye conflicts and choices
# TODO try with higher horizon and more instances

python plot.py --approach afw  --approach afw_del --approach asp --approach nc --prefix="choices-"  --horizon 6 --models 0 --table --stat choices --mean

python plot.py --approach afw  --approach afw_del --approach asp --approach nc --prefix="conflicts-"  --horizon 6 --models 0 --table --stat conflicts --mean


python plot.py --approach proj-afw  --approach proj-afw_del --approach proj-asp --prefix="proj-models"  --horizon 7 --models 0 --table --stat models --mean --table



python plot.py --approach afw --approach asp --approach afw_del --prefix="time-g-models-"  --horizon 6  --stat ctime --stat csolve --models 0 --group
python plot.py --approach afw --approach asp --approach afw_del --prefix="time-g-models-"  --horizon 7  --stat ctime --stat csolve --models 0 --group