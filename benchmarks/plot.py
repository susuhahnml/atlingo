#!/usr/bin/env python
# libraries and data
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import itertools
import seaborn as sns
from pandas_ods_reader import read_ods

#PARAMS
approaches = ['afw']
# approaches = ['afw']
horizon = 25
models = 1
out_value = 'time'
plot_n_models = True
group_instances = True
constraints = None #All
# constraints = ['horizontal_before_vertical']
avarage = False

assert not 'no_constraint' in approaches or avarage and constraints is None, 'No constraint only with average'
assert not plot_n_models or not avarage, "Only avarage or models ploted"

base_path = "benchmarks/benchmark-tool/results/results_{}__h-{}__n-{}.ods"
files = [base_path.format(a,horizon,models) for a in approaches]
dfs = [read_ods(f,1) for f in files]
n_out_options = len(set(dfs[0].iloc[0][:]))-1


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
    df.iloc[:,0]=df.iloc[:,0].apply(lambda x: "{}-{}-{}".format(x.split('/')[0][0],x.split('/')[1] , x[-5:-3]))

    if group_instances:
        df['instance-group']=df['instance-name'].apply(lambda x: x.split('-0')[0])
        df = df.groupby(['instance-group'], as_index=False).mean()
        df['instance-name'] = df['instance-group']
        df = df.sort_values(by=['instance-name'], ascending=False)
    
    #Order instances by complexity TODO!!! Why error?????
    df = df.sort_values(by=['instance-name'], ascending=False)
    
    
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
                plt.annotate(int(txt), (instances[i], df[column][i]),fontsize=7,color=color)
        # plt.tight_layout()
        # Add legend
    plt.legend(loc=2, ncol=2)    
    # Add titles
    plt.title(column.replace('_',' '),  fontsize=12, fontweight=0)
    plt.xticks(rotation='vertical')
    plt.xlabel("Instance")
    plt.ylabel(out_value)

    file_name = 'benchmarks/img/{}-{}.png'.format(out_value,column)
    plt.savefig(file_name,dpi=700,bbox_inches='tight')
    print("Saved {}".format(file_name))
    plt.clf()


# # Make a data frame
# approaches = ['asp1','asp2']
# # approaches = ['dfa','afw']
# # approaches = ['dfa','afw','asp2']
# approach_df = []
# for a in approaches:
#     df = pd.read_csv('benchmarks/benchmarks-results/results_{}.csv'.format(a))
#     approach_df.append(clean_df(df))
# yellow = {15:'#F3F55F',
#     # 25:'#FFEE00',
#     25:'#E7C803',
#     40:'#E7C803',
#     80:'#BCA300'
#     }
# blue= {15:'#96DBED',
#     # 25:'#42AFDB',
#     25:'#455AE2',
#     40:'#455AE2',
#     80:'#0E1BA8'
#     }
# green = {15:'#A7DAA4',
#     # 25:'#73C571',
#     25:'#268C3E',
#     40:'#268C3E',
#     80:'#034D09'
#     }
# red = {15:'#F3AEAE',
#     # 25:'#FE6B6B',
#     25:'#FF2D2D',
#     40:'#FF2D2D',
#     80:'#CC0000'
#     }

# lines =   {15:'-',25:':',40:'-',80:':','all':'-'}
# colors = [yellow,green]
# # colors = [blue,yellow,green,red]

# out_values = ['time','choices','conflicts']
# # out_values = ['time']
# all_labels_from1= approach_df[0][1]

# base_labels_general = set([s.split('_h_')[0] for s in all_labels_from1])
# nb_plots= len(base_labels_general)
# for out_value in out_values:
#     base_labels = base_labels_general.copy()
    
#     num=0
#     # fig, axs = plt.subplots(nb_plots, sharex=True)

#     for i in range(0,len(all_labels_from1)):
#     # for i in range(0,1):
#         column_base = "".join(all_labels_from1[i].split('_h_')[0])
#         if not column_base in base_labels:
#             continue
#         else:
#             base_labels.remove(column_base)
#         for ap_idx, (df,columns) in enumerate(approach_df):
#             column_full_name=columns[i]
#             approach_name = column_full_name.split('-')[-1]
#             cols_all_h = [c for c in columns if c.split('_h_')[0] == column_base]
#             for column in cols_all_h:
#                 plot_unsat=True
#                 try:
#                     h = int(column.split('_h_')[1].split('-')[0])
#                 except:
#                     plot_unsat = False
#                     h='all'
#                 num= num +1

#                 label = "{}-{}".format(approach_name,h) if plot_unsat else approach_name
#                 new_models = 1-df[column+'-models']
#                 new_models[ new_models==0 ] = np.nan
#                 only_on_unsat = new_models*df[column+'-{}'.format(out_value)]
#                 plt.plot(df['instance-name'], df[column+'-{}'.format(out_value)], lines[h],marker='', linewidth=1, alpha=1, label=label, color=colors[ap_idx][40],zorder=-1)
#                 if plot_unsat and label!="median":
#                     plt.scatter(df['instance-name'], only_on_unsat, color='r',s=1,alpha=1,zorder=1)
#             # plt.tight_layout()
#             # Add legend
#         plt.legend(loc=2, ncol=2)    
#         # Add titles
#         plt.title(column_base,  fontsize=12, fontweight=0)
#         plt.xticks(rotation='vertical')
#         plt.xlabel("Instance")
#         plt.ylabel(out_value)

#         file_name = 'benchmarks/img/asp/{}-{}.png'.format(out_value,column_base)
#         plt.savefig(file_name,dpi=700,bbox_inches='tight')
#         print("Saved {}".format(file_name))
#         plt.clf()