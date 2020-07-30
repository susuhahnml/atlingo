#!/usr/bin/env python
# libraries and data
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import itertools
import seaborn as sns

N_OUT = 5

def clean_df(df):
    cols = df.columns[1:]
    cols = [c.split("/")[-1] for i,c in enumerate(cols) if i%N_OUT==0]
    params = df.iloc[0][1:N_OUT+1]

    new_cols = ["{}-{}".format(c,p) for c,p in list(itertools.product(cols, params))]
    new_cols = ["instance-name"] + new_cols
    df.drop(df.index[0], inplace=True)

    df.drop(df.tail(9).index,inplace=True)
    df.columns = new_cols
    df.iloc[:,0]=df.iloc[:,0].apply(lambda x: "{}-{}".format(x.split('/')[0] , x[-5:-3]))
    for i in range(1,len(df.columns)):
        df.iloc[:,i] = pd.to_numeric(df.iloc[:,i], downcast="float")

    return df,cols

# Make a data frame
approach_df = []
df2 = pd.read_csv('benchmarks/benchmarks-results/results_dfa_full.csv')
approach_df.append(clean_df(df2))
df = pd.read_csv('benchmarks/benchmarks-results/results_alternating_full.csv')
approach_df.append(clean_df(df))
# df2 = pd.read_csv('benchmarks/benchmarks-results/results_asp.csv')
# approach_df.append(clean_df(df2))
# df = pd.read_csv('benchmarks/benchmarks-results/results_asp2.csv')
# approach_df.append(clean_df(df))
# style
# create a color palette
out_values = ['time','choices']
for out_value in out_values:
 
    # multiple line plot
    num=0

    for i in range(0,len(approach_df[0][1])):
    # for i in range(0,1):
        plt.style.use('seaborn-dark-palette')
        palette = plt.get_cmap('Set1')
        for df,columns in approach_df:
            column=columns[i]
            
            num= num +1

            new_models = 1-df[column+'-models']
            new_models[ new_models==0 ] = np.nan
            only_on_unsat = new_models*df[column+'-{}'.format(out_value)]
            plt.scatter(df['instance-name'], only_on_unsat, color='r')

            plt.plot(df['instance-name'], df[column+'-{}'.format(out_value)], marker='', linewidth=1, alpha=0.9, label=column.split('-')[-1])
            # plt.tight_layout()
            # Add legend
        plt.legend(loc=2, ncol=2)    
        # Add titles
        column_base = "".join(approach_df[0][1][i].split('-')[:-1])
        plt.title("Ploting {} for {}".format(column_base,out_value),  fontsize=12, fontweight=0)
        plt.xticks(rotation='vertical')
        plt.xlabel("Instance")
        plt.ylabel(out_value)

        file_name = 'benchmarks/img/{}-{}.png'.format(out_value,column_base)
        plt.savefig(file_name,dpi=700,bbox_inches='tight')
        print("Saved {}".format(file_name))
        plt.clf()