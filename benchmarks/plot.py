#!/usr/bin/env python
# libraries and data
import sys
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import itertools
import seaborn as sns
from pandas_ods_reader import read_ods

yellow = ['#F3F55F','#E7C803','#BCA300']
blue= ['#96DBED','#455AE2','#0E1BA8']
green = ['#A7DAA4','#268C3E','#034D09']
red = ['#F3AEAE','#FF2D2D','#CC0000']
purple = ['#F6CDF0','#F883E7','#C223AB']
colors = [blue,yellow,purple,green,red]
loc = ['lower right','lower left','upper right']

import argparse

parser = argparse.ArgumentParser(description='Plot obs files from benchmark tool')
parser.add_argument("--stat", type=str, action='append',
        help="Status: choices,conflicts,cons,csolve,ctime,error,mem,memout,models,ngadded,optimal,restarts,status,time,timeout,vars" )
parser.add_argument("--approach", type=str, action='append',
        help="Approach to be plotted awf, asp, nc or dfa. Can pass multiple",required=True)
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
parser.add_argument("--group", default=False, action='store_true',
    help="When this flag is passed, instances are grouped")
parser.add_argument("--mean", default=False, action='store_true',
    help="When this flag is passed, only average will be computed per instance.Necessary for no-constraint")
parser.add_argument("--bars", default=False, action='store_true',
    help="When this flag is passed, will print bar for one approach with all times")
parser.add_argument("--y", type=str, default=None,
        help="Name for the y axis" )
parser.add_argument("--handle_timeout", action='store_true', default=False,
        help="If passed the timeouts will be ploted like dots and no value will be added" )
parser.add_argument("--ignore_prefix",type=str, action='append',
        help="Prefix to ignore in the instances" )
args = parser.parse_args()

#PARAMS
handle_timeout = args.handle_timeout
approaches = args.approach
horizons = args.horizon
models = args.models
out_value = args.stat
plot_n_models = args.plotmodels
group_instances = args.group
constraints = args.constraint
mean = args.mean
prefix = args.prefix
ignore_prefix = args.ignore_prefix
if ignore_prefix is None:
    ignore_prefix = []
if args.y is None:
    args.y="-".join(args.stat)

approaches.sort()

# assert not 'nc' in approaches or mean and constraints is None, 'No constraint only with average'
assert not plot_n_models or not mean, "Only mean or models ploted"
assert not plot_n_models or not group_instances, "Only plot or group"

approaches = ["{}__h-{}".format(a,h) for a,h in list(itertools.product(approaches, horizons))]
base_path = "results/{}__n-{}/{}__n-{}.ods"
files = [base_path.format(a,models,a,models) for a in approaches]
dfs = []

for f in files:
    try:
        dfs.append(read_ods(f,1))
    except:
        print("Error reading file {}".format(f))
        print("Make sure the file exists".format(f))
        sys.exit(1)
out_options = set(dfs[0].iloc[0][:])
out_options.remove('')
out_options=list(out_options)
n_out_options = len(out_options)

def clean_df(df):
    #Drop min max median
    df.drop(df.columns[-3*n_out_options:], axis=1, inplace=True) 
    
    #Rename columns
    cols = df.columns[1:]
    cols = [c.split("/")[-1] for i,c in enumerate(cols) if i%n_out_options==0]
    params = df.iloc[0][1:n_out_options+1]
    new_cols = ["{}-{}".format(c,p) for c,p in list(itertools.product(cols, params))]
    new_cols = ["instance-name"] + new_cols
    df.drop(df.index[0], inplace=True) #Remove unused out values
    df.drop(df.tail(9).index,inplace=True) #Remove last computed values
    df.columns = new_cols

    for i in range(1,len(df.columns)):
        df.iloc[:,i] = pd.to_numeric(df.iloc[:,i], downcast="float")
    
    ###### Handle rows (INSTANCES)
    
    #Rename instances with shorter name
    instances = df['instance-name']
    instances_to_drop = [i for i,c in enumerate(instances) if any([ c.find(i)==0 for i in ignore_prefix])]
    df.drop(df.index[instances_to_drop], inplace=True)
    df.iloc[:,0]=df.iloc[:,0].apply(lambda x: "{}-{}-{}".format(x.split('/')[0][0],x.split('/')[1] , x[-5:-3]))

    if group_instances:
        df['instance-group']=df['instance-name'].apply(lambda x: x.split('-0')[0])
        df = df.groupby(['instance-group'], as_index=False).mean()
        df['instance-name'] = df['instance-group']
        df.drop(['instance-group'], axis=1, inplace=True) 

    
    #Order instances by complexity
    def instance_complexity(s):
        s = s.split('-')[1]
        s = s.split('_')
        x,y,r = (int(s[0][1:]),int(s[1][1:]),int(s[2][1:]))
        return x*y + r
    df['instance-value'] = df['instance-name'].apply(instance_complexity)
    df = df.sort_values(by=['instance-value'], ascending=True)
    df = df.reset_index(drop=True)
    df.drop(['instance-value'], axis=1, inplace=True) 

    for a in out_options:
        col_name = 'mean-'+a
        is_a = [x.split('-')[-1]==a for x in df.columns]
        df[col_name] = df.loc[:,is_a].mean(axis = 1)

    return df

cleaned_dfs = [clean_df(df) for df in dfs]
all_cols = list(itertools.chain(*[d.columns for d in cleaned_dfs]))
columns = set([s.split('-')[0] for s in all_cols])
columns.remove('instance')
if 'without_constraint' in columns and (not approaches[0][:2]=='nc'):
    columns.remove('without_constraint')

if mean:
    columns = ['mean']
else:
    columns.remove('mean')
columns = list(columns)
instances = cleaned_dfs[0]['instance-name']
n_columns = len(columns)
n_instances = len(instances)
x_instances = np.arange(len(instances))  # the label locations
width = 0.35  # the width of the bars
for column in columns:
    old_col = column
    for i, df in enumerate(cleaned_dfs):
        if approaches[i][:2]=="nc":
            column="mean"
        plots_approach = []
        # if handle_timeout:
        timed_out = df[column + '-timeout'].copy()
        timed_out.loc[timed_out!=1] = np.nan
        timed_out.loc[timed_out==1] = 0
        s = plt.scatter(x_instances-(width*(i-1)/2),timed_out,edgecolors='black',color=colors[i][0],s=4,linewidths=0.5,zorder=10, clip_on=False)
        for i_out,out in enumerate(out_value):
            col_plt = df[column + '-'+out]
            if handle_timeout: col_plt.loc[df[column + '-timeout']==1]=0
            plots_approach.append(plt.bar(x_instances-(width*(i-1)/2), col_plt, alpha=1, label='{} ({})'.format(approaches[i],out),width=width-0.5,color=colors[i][i_out]))
        space = 1-0.02-i*(0.07*len(out_value))
        legend = plt.legend(handles = plots_approach,loc='upper left',bbox_to_anchor=(1, space))    
        # Add the legend manually to the current Axes.
        ax = plt.gca().add_artist(legend)
        column = old_col

    
    # Add titles
    plt.ylim(bottom=0)
    plt.title(column.replace('_',' '),  fontsize=12, fontweight=0)
    plt.xticks(x_instances,instances,rotation='vertical')
    plt.xlabel("Instance")
    plt.ylabel(args.y)
    
    #Change color of instance based on status
    df=cleaned_dfs[0]
    if not group_instances:
        for idx,i  in enumerate(plt.gca().get_xticklabels()):
            #{"SATISFIABLE": 1, "UNSATISFIABLE": 0, "UNKNOWN": 2, "OPTIMUM FOUND": 3}
            if df[column+'-'+'status'][idx]==0:
                i.set_color("gray")
            # elif df[column+'-'+'status'][idx]==2:
            #     i.set_color("grey")

    # file_name = 'plots/{}{}-{}.png'.format(prefix,"-".join(out_value),column)
    file_name = 'plots/{}-{}.png'.format(prefix,column)
    plt.savefig(file_name,dpi=300,bbox_inches='tight')
    print("Saved {}".format(file_name))
    plt.clf()
