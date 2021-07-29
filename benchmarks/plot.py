#!/usr/bin/env python
# libraries and data
import os
import math
import sys
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import itertools
import seaborn as sns
from pandas_ods_reader import read_ods
import tikzplotlib

import argparse

parser = argparse.ArgumentParser(description='Plot obs files from benchmark tool',formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("--stat", type=str, action='append',
        help="Status: choices,conflicts,cons,csolve,ctime,error,mem,memout,models,ngadded,optimal,restarts,status,time,timeout,vars,ptime" )
parser.add_argument("--approach", type=str, action='append',
        help="Approach to be plotted awf, asp, nc or dfa. Can pass multiple",required=True)
parser.add_argument("--env",type=str, default='asprilo',
        help="Name of environment, asprilo or elevator" )
parser.add_argument("--constraint", type=str, action='append',
        help="Contraint to be plotted, if non is passed all constraints will be plotted. Can pass multiple")
parser.add_argument("--horizon", type=int, action='append',
        help="Horizon to be plotted. Can pass multiple",required=True)
parser.add_argument("--models", type=int, default=1,
        help="Number of models computed in the benchmark with clingo -n" )
parser.add_argument("--prefix", type=str, default="",
        help="Prefix for output files" )
parser.add_argument("--plotmodels", default=False, action='store_true',
    help="When this flag is passed, the number of models in plotted")
parser.add_argument("--type", type=str, default="bar",
        help="Bar or table" )
parser.add_argument("--instance", type=str, default=None,
        help="The name of a single instance" )
parser.add_argument("--ignore_prefix",type=str, action='append',
        help="Prefix to ignore in the instances" )
parser.add_argument("--ignore_any",type=str, action='append',
        help="Any to ignore in the instances" )
parser.add_argument("--y", type=str, default=None,
        help="Name for the y axis" )
parser.add_argument("--x", type=str, default="Horizon",
        help="Name for the x axis" )
args = parser.parse_args()

#PARAMS
# handle_timeout = not args.ignore_timeout
# zero_timeout = args.zero_timeout

# Env
env = args.env

# Approaches
approaches = args.approach
n_approaches = len(args.approach)
approaches.sort()
if "nc" in approaches:
    approaches.remove("nc")
    approaches.append("nc")

# Horizon
horizons = args.horizon
horizons.sort()
h2idx = {h:i for i,h in enumerate(horizons)}

models = args.models

# Statistics
stats = args.stat + ["status"]
constraints = args.constraint

prefix = args.prefix
# plot_n_models = args.plotmodels

# Instances
single_instance = False
if args.instance:
    single_instance = True
    instance = args.instance
else:
    ignore_prefix = [] if args.ignore_prefix is None else args.ignore_prefix
    ignore_any = [] if args.ignore_any is None else args.ignore_any

summary = f"""
PLOT
    ENV: {env}
    APPROACHES: {approaches}
    HORIZONS : {horizons}
    STATS: {stats}
    CONSTRAINTS: {"ALL" if constraints is None else constraints}
"""

if single_instance:
    summary +=f"    ONLY INSTANCE: {instance}\n"
else:
    summary +=f"    IGNORE INSTANCE: {ignore_any} {ignore_prefix}\n"

print(summary)

# ------ Clean ods
def clean_df(df):
    
    all_stats = set(df.iloc[0][:])
    all_stats.remove('')
    all_stats=list(all_stats)
    n_all_stats = len(all_stats)
    #Drop min max median
    df.drop(df.columns[-3*n_all_stats:], axis=1, inplace=True) 
    
    #Rename columns
    all_constraints = df.columns[1:]
    all_constraints = [c.split("/")[-1] for i,c in enumerate(all_constraints) if i%n_all_stats==0]
    all_stats = df.iloc[0][1:n_all_stats+1]

    new_cols = ["{}--{}".format(c,p) for c,p in list(itertools.product(all_constraints, all_stats))]
    new_cols = ["instance-name"] + new_cols
    df.drop(df.index[0], inplace=True) #Remove unused out values
    df.drop(df.tail(9).index,inplace=True) #Remove last computed values
    df.columns = new_cols
    if args.constraint is None:
        constraints = all_constraints
    else:
        constraints = args.constraint

    required_colums = ["instance-name"] + [f"{c}--{s}" for c in constraints for s in stats]

    df = df.loc[:,df.columns.intersection(required_colums)]
    # Convert all to floats
    for i in range(1,len(df.columns)):
        df.iloc[:,i] = pd.to_numeric(df.iloc[:,i], downcast="float")

    
    ###### Handle rows (INSTANCES)
    
    #Choose selected instances
    all_instances = df['instance-name']
    if single_instance:
        instances_to_drop = [i for i,c in enumerate(all_instances) if c.find(instance)==-1 ]
        df.drop(df.index[instances_to_drop], inplace=True)
    else:
        instances_to_drop = [i for i,c in enumerate(all_instances) if any([ c.find(i)==0 for i in ignore_prefix])]
        df.drop(df.index[instances_to_drop], inplace=True)
        instances_to_drop = [i for i,c in enumerate(all_instances) if any([ c.find(i)!=-1 for i in ignore_any])]
        df.drop(df.index[instances_to_drop], inplace=True)

    #Rename
    def rename(i):
        return i.split("/")[1].split("_")[3]
    # def rename(i):
    #     return i.split("/")[1].split("_")[0]
    # def rename(i):
    #     return i[:-3]
    df['instance-name']=df['instance-name'].apply(rename)

    # print(df)
    return df


# -------- Read DFS
dfs = {}
last_df = None
for a in approaches:
    for h in horizons:
        path = f"results/{env}/{a}__h-{h}__n-{models}/{a}__h-{h}__n-{models}.ods"
        try:
            print(f"Reading path {path}")
            df = read_ods(path,1)
            df = clean_df(df)
            dfs.setdefault(a,{})[h]=df

            last_df = df
        except e:
            print("Error reading file {}".format(path))

            sys.exit(1)


# -------- Reorder dfs

fin_colums = last_df.columns
constraints = list(set([s.split('--')[0] for s in fin_colums[1:]]))
constraints.sort()
stats = list(set([s.split('--')[1] for s in fin_colums[1:]]))
stats.sort()
instances = last_df['instance-name']
dfs_per_cons = {}
for cons in constraints:
    for instance in instances:
        rows = []
        for s in stats:

            for h in horizons:
                row = [s,h]
                for a in approaches:
                    current_df = dfs[a][h]
                    current_row = current_df.loc[df['instance-name'] == instance]
                    current_col = f'{cons}--{s}'
                    row.append(current_row[current_col].item())

                rows.append(row)
        # print(rows)
        df_row = pd.DataFrame(rows, columns=["Stat","Horizon"]+approaches)
        
        #Edit horizon if unsat
        df_stat = df_row.loc[df_row['Stat'] == 'status']
        unsat_horizons = df_stat[df_stat[df_stat.columns[2]]==0]['Horizon'].tolist()
        df_row['Horizon'] = np.where(df_row['Horizon'].isin(unsat_horizons),df_row['Horizon'].astype(str)+"~",df_row['Horizon'])

        # # TIMEOUT set to NAN
        # print(df_row)
        # df_stat = df_row.loc[df_row['Stat'] == 'status']
        
        # for c in df_row.columns:
            # for row in df_row.index:
                
        # print(df_stat)
        # print(df_stat==2)
        # print(df_stat[df_stat==2['']])
        # bad_horizons = df_stat[df_stat[df_stat.columns[2]]==2]['Horizon'].tolist()

        # df_row.loc[df_stat==2,:]="holi"
        # print(bad_horizons)

        # unsat_horizons = df_stat[df_stat[df_stat.columns[2]]==2]['Horizon'].tolist()
        # print(unsat_horizons)
        
        df_row = df_row[df_row['Stat'] != "status"]

        #times to milli seconds
        is_time = df_row["Stat"].str.contains('time', regex=False)
        df_row.loc[is_time,approaches]=df_row.loc[is_time,approaches]*1000

        dfs_per_cons.setdefault(cons,{})[instance]= df_row



if args.type == "table":
    # -------- Save CVS
    for cons, v in dfs_per_cons.items():
        for ins, df in v.items():
            file_name_csv = f'plots/tables/{env}/{prefix}-{cons}-{ins}.csv'
            file_name_tex_csv = file_name_csv[:-3]+"tex"
            dir_name = os.path.dirname(file_name_csv)
            if not os.path.exists(dir_name): os.makedirs(dir_name)
            
            # Add mark to minimum value
            non_mc_approaches = [x for x in approaches if x!='nc']
            mins = df[non_mc_approaches].min(axis=1)
            min_mx=df[non_mc_approaches].astype(float).eq(mins,axis=0)
            for c in min_mx.columns:
                for row in df.index:
                    str_value = "\\color{red}{-}" if math.isnan(df.loc[row,c]) else str(f'{int(df.loc[row,c]):,}')
                    
                    # df.loc[row,c]= "\\textbf{\\color{blue}{"+str_value+"}}" if min_mx.loc[row,c] else str_value
                    df.loc[row,c]= str_value+"*" if min_mx.loc[row,c] else str_value

            formatted_stats = []
            def f_tex(x):
                if isinstance(x, np.floating):
                    return "\\color{black!60}{"+str(f'{int(x):,}')+"}"
                if x in stats:
                    if x in formatted_stats:
                        return ""
                    formatted_stats.append(x)
                    return '\\hline \\textbf{' +x+ '}'
                if type(x) is str and x[-1]== '~':
                    return '\\sout{'+x[:-1]+'}'
                if type(x) is str and x[-1]== '*':
                    return x
                if type(x) is int:
                    return x
                else:
                    return "\\color{black!60}{"+x+"}"
            
            headers = ["","H"]  + ["\\textbf{"+str(c)+"}" for c in df.columns[2:]]

            df.to_csv(file_name_csv,float_format='%.0f')
            tex_table = df.to_latex(
                index=False,
                caption=f"Table for constraint ``{cons}\" and instance ``{ins}\".",
                formatters=[f_tex]*len(df.columns), 
                escape=False, 
                header=headers,
                column_format='ll|'+'r'*len(non_mc_approaches)+'|r')

            f = open(file_name_tex_csv, "w")
            f.write(tex_table)
            f.close()
            print("Saved {}".format(file_name_csv))
            print("Saved {}".format(file_name_tex_csv))

elif args.type == "bar":
    approaches_colors = {
        "nc":"#C8F69B",
        "afw":"#FFB1AF",
        "dfa-mso":"#D6D4FF",
        "dfa-stm":"#B3EEFF",
        "nfa":"#FFCBA5",
        "nfa-afw":"#FFE2A5",
        "telingo":"#FFEEA5"
    }
    colors = [approaches_colors[a] for a in approaches]
    # -------- Plot
    for cons, v in dfs_per_cons.items():
        for ins, df in v.items():
            file_name_img = f'plots/img/{env}/{prefix}-{cons}-{ins}.png'
            dir_name = os.path.dirname(file_name_img)
            if not os.path.exists(dir_name): os.makedirs(dir_name)
            plotting_stats = [s for s in stats if s !="status"]
            for i, s in enumerate(plotting_stats):
                stats_row = df.loc[df['Stat'] == s]
                stats_row.plot(x="Horizon", y=approaches, kind="bar", color=colors)
                # stats_row.plot(x="Horizon", y=approaches, kind="bar", colormap="Set3")

            plt.title(f"{cons} ({ins})",  fontsize=12, fontweight=0)
            plt.xlabel(args.x)
            plt.xticks(rotation='horizontal')
            plt.ylabel(args.y)
            plt.ylim(bottom=0)

                    
            plt.savefig(file_name_img,dpi=300,bbox_inches='tight')
            print("Saved {}".format(file_name_img))
            plt.clf()
        