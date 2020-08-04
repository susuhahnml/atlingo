#!/usr/bin/env python
# libraries and data
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import itertools
import seaborn as sns
from pandas_ods_reader import read_ods

#PARAMS
approaches = ['afw','no_constraint']
horizon = 15
models = 1
out_value = 'time'
plot_n_models = False
group_instances = False
constraints = None #All
# constraints = ['horizontal_before_vertical']
avarage = False

base_path = "benchmarks/benchmark-tool/results/results_{}__h-{}.ods"
files = [base_path.format(a,horizon) for a in approaches]
dfs = [read_ods(f,1) for f in files]
n_out_options = len(set(dfs[0].iloc[0][:]))-1

print(n_out_options)


#plot every option
#plot number of models



def clean_df(df):
    df.drop(df.columns[-3*n_out_options:], axis=1, inplace=True) #Drop min max median
    
    cols = df.columns[1:]
    cols = [c.split("/")[-1] for i,c in enumerate(cols) if i%n_out_options==0]
    params = df.iloc[0][1:n_out_options+1]


    new_cols = ["{}-{}".format(c,p) for c,p in list(itertools.product(cols, params))]
    new_cols = ["instance-name"] + new_cols
    df.drop(df.index[0], inplace=True)


    df.drop(df.tail(9).index,inplace=True)
    # print(new_cols[-2*n_out_options]+new_cols[-1*n_out_options])
    df.columns = new_cols
    df.iloc[:,0]=df.iloc[:,0].apply(lambda x: "{}-{}".format(x.split('/')[0] , x[-5:-3]))
    for i in range(1,len(df.columns)):
        df.iloc[:,i] = pd.to_numeric(df.iloc[:,i], downcast="float")

    return df,cols

clean_dfs = []
for df in dfs:
    d, c = clean_df(df)
    if constraints is None:
        selected_cols = ["{}-{}".format(col,out_value) for col in c]
    else:
        selected_cols = ["{}-{}".format(col,out_value) for col in constraints]
    selected_cols = ['instance-name'] + selected_cols
    d =d[selected_cols]
    d = d.sort_values(by=['instance-name'], ascending=False)
    
    if group_instances:
        d['instance-group']=d['instance-name'].apply(lambda x: x.split('-')[0])
        print(d)
        d = d.groupby(['instance-group'], as_index=False).mean()
        d['instance-name'] = d['instance-group']
        d = d.sort_values(by=['instance-name'], ascending=False)

    clean_dfs.append(d)
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