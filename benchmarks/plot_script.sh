# python plot.py --approach afw --approach asp --approach afw --prefix="time-7"  --horizon 7  --stat ctime --models 0 --y="time (sec)" --mean --ignore_prefix structured/x10  --approach nc --tikz

# python plot.py --approach afw --approach asp --approach afw --prefix="rules-bodies-20"  --horizon 20  --stat rules --models 1 --approach nc  --stat bodies --mean --tikz --group


# python plot.py --approach afw --prefix="scale"  --horizon 20 --horizon 25 --horizon 30 --horizon  35  --stat ctime --models 1 --y="time (sec)" --mean --group --plot_type=line  --approach afw  --tikz

# python plot.py --approach grid-afw  --approach grid-afw --approach grid-asp --approach grid-nc --prefix="grid-conflicts-5"  --horizon 5 --models 0 --table --stat conflicts --mean

# python plot.py --approach grid-afw  --approach grid-afw --approach grid-asp --approach grid-nc --prefix="grid-choices-5"  --horizon 5 --models 0 --table --stat choices --mean  --ignore_prefix structured/x10 



# python plot.py --approach nc --approach afw --prefix="elevator-5-models" --models 0 --table --stat models --env elevator --horizon 8 --horizon 9 --horizon 10 --horizon 11 --horizon 12 --plot_type=line --ignore_any=7 --ignore_any=9

# python plot.py --approach nc --approach afw --prefix="elevator-5-choices" --models 0 --table --stat choices --env elevator --horizon 8 --horizon 9 --horizon 10 --horizon 11 --horizon 12 --plot_type=line --ignore_any=7 --ignore_any=9

# python plot.py --approach nc --approach afw --prefix="elevator-5-cons" --models 0 --table --stat cons --env elevator --horizon 8 --horizon 9 --horizon 10 --horizon 11 --horizon 12 --plot_type=line --ignore_any=7 --ignore_any=9

# 5 floors
# python plot.py --approach nc  --approach afw --approach telingo --approach dfa --approach nfa --prefix="elevator-models-5" --models 0 --table --stat models --env elevator --horizon 8 --horizon 9 --horizon 10 --horizon 11 --horizon 12 --plot_type=line --ignore_any=7 --ignore_any=9 --ignore_any=11

# python plot.py --approach nc  --approach afw --approach telingo --approach dfa --approach nfa  --prefix="elevator-choices-5" --models 0 --table --stat choices --env elevator --horizon 8 --horizon 9 --horizon 10 --horizon 11 --horizon 12 --plot_type=line --ignore_any=7 --ignore_any=9 --ignore_any=11

# python plot.py --approach nc  --approach afw --approach telingo --approach dfa --approach nfa  --prefix="elevator-cons-5" --models 0 --table --stat cons --env elevator --horizon 8 --horizon 9 --horizon 10 --horizon 11 --horizon 12 --plot_type=line --ignore_any=7 --ignore_any=9 --ignore_any=11

# # 7 floors

# python plot.py --approach nc  --approach afw --approach telingo --approach dfa --approach nfa  --prefix="elevator-models-7" --models 0 --table --stat models --env elevator --horizon 11 --horizon 12 --horizon 13 --horizon 14 --horizon 15 --plot_type=line --ignore_any=5 --ignore_any=9 --ignore_any=11

# python plot.py --approach nc  --approach afw --approach telingo --approach dfa --approach nfa  --prefix="elevator-choices-7" --models 0 --table --stat choices --env elevator --horizon 11 --horizon 12 --horizon 13 --horizon 14 --horizon 15 --plot_type=line --ignore_any=5 --ignore_any=9 --ignore_any=11

# python plot.py --approach nc  --approach afw --approach telingo --approach dfa --approach nfa  --prefix="elevator-cons-7" --models 0 --table --stat cons --env elevator --horizon 11 --horizon 12 --horizon 13 --horizon 14 --horizon 15 --plot_type=line --ignore_any=5 --ignore_any=9 --ignore_any=11

# # 9 floors
python plot.py --approach nc  --approach afw --approach telingo --approach dfa --approach nfa --prefix="elevator-models-9" --models 0 --table --stat models --env elevator --horizon 14 --horizon 15 --horizon 16 --horizon 17 --horizon 18 --plot_type=line --ignore_any=5 --ignore_any=7 --ignore_any=11

python plot.py --approach nc  --approach afw --approach telingo --approach dfa --approach nfa --prefix="elevator-choices-9" --models 0 --table --stat choices --env elevator --horizon 14 --horizon 15 --horizon 16 --horizon 17 --horizon 18 --plot_type=line --ignore_any=5 --ignore_any=7 --ignore_any=11

python plot.py --approach nc  --approach afw --approach telingo --approach dfa --approach nfa --prefix="elevator-cons-9" --models 0 --table --stat cons --env elevator --horizon 14 --horizon 15 --horizon 16 --horizon 17 --horizon 18 --plot_type=line --ignore_any=5 --ignore_any=7 --ignore_any=11


# 11 floors
# python plot.py --approach nc  --approach afw --approach telingo --approach dfa --approach nfa --prefix="elevator-models-11" --models 0 --table --stat models --env elevator --horizon 17 --horizon 18 --horizon 19 --horizon 20 --horizon 21 --plot_type=line --ignore_any=5 --ignore_any=7 --ignore_any=9

# python plot.py --approach nc  --approach afw --approach telingo --approach dfa --approach nfa --prefix="elevator-choices-11" --models 0 --table --stat choices --env elevator --horizon 17 --horizon 18 --horizon 19 --horizon 20 --horizon 21 --plot_type=line --ignore_any=5 --ignore_any=7 --ignore_any=9

# python plot.py --approach nc --approach afw --prefix="elevator-cons-11" --models 0 --table --stat cons --env elevator --horizon 17 --horizon 18 --horizon 19 --horizon 20 --horizon 21 --plot_type=line --ignore_any=5 --ignore_any=7 --ignore_any=9


# python plot.py --approach nc --approach afw --prefix="elevator-9-models" --models 0 --table --stat models --env elevator --horizon 14 --horizon 15 --horizon 16 --horizon 17 --horizon 18 --plot_type=line --ignore_any=5 --ignore_any=7

# python plot.py --approach nc --approach afw --prefix="elevator-9-choices" --models 0 --table --stat choices --env elevator --horizon 14 --horizon 15 --horizon 16 --horizon 17 --horizon 18 --plot_type=line --ignore_any=5 --ignore_any=7

# python plot.py --approach nc --approach afw --prefix="elevator-9-cons" --models 0 --table --stat cons --env elevator --horizon 14 --horizon 15 --horizon 16 --horizon 17 --horizon 18 --plot_type=line --ignore_any=5 --ignore_any=7