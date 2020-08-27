# Analye conflicts and choices
# TODO try with higher horizon and more instances

python plot.py --approach afw  --approach afw_del --approach asp --approach nc --prefix="choices-"  --horizon 6 --models 0 --table --stat choices --mean

python plot.py --approach afw  --approach afw_del --approach asp --approach nc --prefix="conflicts-"  --horizon 6 --models 0 --table --stat conflicts --mean
