#!/usr/bin/env python
# libraries and data
import sys
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import itertools
import seaborn as sns
from pandas_ods_reader import read_ods

import argparse

parser = argparse.ArgumentParser(description='Plot obs files from benchmark tool')
parser.add_argument("--stat", type=str, default="time",
        help="Status: time, choice, conflicts or models" )
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
parser.add_argument("--avarage", default=False, action='store_true',
    help="When this flag is passed, only average will be computed per instance.Necessary for no-constraint")

args = parser.parse_args()

#PARAMS
approaches = args.approach
horizons = args.horizon
models = args.models
out_value = args.stat
plot_n_models = args.plotmodels
group_instances = args.group
constraints = args.constraint
avarage = args.avarage
prefix = args.prefix


assert not 'nc' in approaches or avarage and constraints is None, 'No constraint only with average'
assert not plot_n_models or not avarage, "Only avarage or models ploted"

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
# print(set(dfs[0].iloc[0][:]))
# print(dfs[0].iloc[0][:])
n_out_options = len(set(dfs[0].iloc[0][:]))-1


def clean_df(df):
    #Drop min max median
    df.drop(df.columns[-3*n_out_options:], axis=1, inplace=True) 
    
    #Rename columns
    cols = df.columns[1:]
    cols = [c.split("/")[-1] for i,c in enumerate(cols) if i%n_out_options==0]
    params = df.iloc[0][1:n_out_options+1]
    # print(params)
    new_cols = ["{}-{}".format(c,p) for c,p in list(itertools.product(cols, params))]
    new_cols = ["instance-name"] + new_cols
    df.drop(df.index[0], inplace=True) #Remove unused out values
    df.drop(df.tail(9).index,inplace=True) #Remove last computed values
    # print(df.columns)
    # print(new_cols)
    df.columns = new_cols

    for i in range(1,len(df.columns)):
        df.iloc[:,i] = pd.to_numeric(df.iloc[:,i], downcast="float")
    
    ###### Handle rows (INSTANCES)
    
    #Rename instances with shorter name
    df.iloc[:,0]=df.iloc[:,0].apply(lambda x: "{}-{}-{}".format(x.split('/')[0][0],x.split('/')[1] , x[-5:-3]))

    if group_instances:
        df['instance-group']=df['instance-name'].apply(lambda x: x.split('-0')[0])
        df = df.groupby(['instance-group'], as_index=False).mean()
        df['instance-name'] = df['instance-group']
    
    #Order instances by complexity TODO!!! Why error?????
    def instance_complexity(s):
        s = s.split('-')[1]
        s = s.split('_')
        x,y,r = (int(s[0][1:]),int(s[1][1:]),int(s[2][1:]))
        return x*y + r
    df['instance-value'] = df['instance-name'].apply(instance_complexity)
    df = df.sort_values(by=['instance-value'], ascending=True)
    df = df.reset_index(drop=True)
    
    #Select columns based on out-value
    if constraints is None:
        selected_cols = ["{}-{}".format(col,out_value) for col in cols]
    else:
        selected_cols = ["{}-{}".format(col,out_value) for col in constraints]
    
    #Save models for plotting
    if constraints is None:
        selected_cols_models = ["{}-{}".format(col,'models') for col in cols]
    else:
        selected_cols_models = ["{}-{}".format(col,'models') for col in constraints]


    df_models = df[['instance-name']+selected_cols_models]
    selected_cols = ['instance-name'] + selected_cols
    df =df[selected_cols]

    #Remove unnecessary output in column name
    df.columns = [x.replace('-{}'.format(out_value),'') for x in  selected_cols]
    df_models.columns = [x.replace('-{}'.format(out_value),'') for x in  selected_cols]


    if avarage:
        df['mean'] = df.loc[:, df.columns != 'instance-name'].mean(axis = 1)
        df= df[["instance-name","mean"]]
    
    return df, df_models

cleaned_dfs_tuple = [clean_df(df) for df in dfs]
cleaned_dfs = [t[0] for t in cleaned_dfs_tuple]
cleaned_dfs_models = [t[1] for t in cleaned_dfs_tuple]

columns = cleaned_dfs[0].columns[1:]
instances = cleaned_dfs[0]['instance-name']
n_columns = len(columns)

for column in columns:
    for i, df in enumerate(cleaned_dfs):
        plt.plot(instances, df[column], linewidth=1, alpha=1, label=approaches[i],zorder=-1)
        if plot_n_models:
            color = '#811515'
            plt.scatter(instances, df[column], color=color,s=1,alpha=1,zorder=1,label='#models')
            for i, txt in enumerate(cleaned_dfs_models[i][column]):
                if int(txt)==0:
                    plt.annotate(int(txt), (instances[i], df[column][i]),fontsize=7,color=color)
        # plt.tight_layout()
        # Add legend
    plt.legend(loc=2, ncol=2)    
    # Add titles
    plt.title(column.replace('_',' '),  fontsize=12, fontweight=0)
    plt.xticks(rotation='vertical')
    plt.xlabel("Instance")
    plt.ylabel(out_value)

    file_name = 'plots/{}{}-{}.png'.format(prefix,out_value,column)
    plt.savefig(file_name,dpi=700,bbox_inches='tight')
    print("Saved {}".format(file_name))
    plt.clf()
