#!/usr/bin/python
# -*- coding: utf-8 -*- 
import argparse
import copy
import os
import sys
import networkx as nx
import pygraphviz as pgv        
import clingo
import itertools
import pdb
import subprocess
from pystructures.automata import AFW
from pystructures.ldlf import LDLfFormula
parser = argparse.ArgumentParser(description='Viz automata')

parser.add_argument('--constraint', help='Constaint name',required=True)
parser.add_argument('--env_app', help='Env app: atlingo, test, elevator...',required=True)
parser.add_argument('--app', help='App: afw, dfa, nfa',required=True)
parser.add_argument('--instance', help='Instance name',required=True)
parser.add_argument('--instance_path', help='Instance path',required=True)
parser.add_argument('--labels', action='store_const', const=True)
parser.add_argument('--latex', action='store_const', const=True)

args = parser.parse_args()
constraint=args.constraint
env_app=args.env_app
app=args.app
instance=args.instance
instance_path=args.instance_path
labels= args.labels
latex= args.latex


command = 'make translate APP=afw LOGIC=del CONSTRAINT={} ENV_APP={} INSTANCE={}'.format(constraint,env_app,instance_path) 
print(command)
subprocess.check_output(command.split())
constraint_path = "env/{}/temporal_constraints/del/{}.lp".format(env_app,constraint)

afw_automata_path = "outputs/{}/afw/del/{}/{}/afw_automata.lp".format(env_app,constraint,instance)
automata_path = "outputs/{}/{}/del/{}/{}/{}_automata.lp".format(env_app, app,constraint,instance,app)

afw = AFW.from_lp(files = [afw_automata_path])

if app=="afw":
    automaton = afw
elif app in ["dfa-mso","dfa-stm"]:
    ldlfformulas = LDLfFormula.from_lp(files=[constraint_path])
    print(constraint_path)
    automaton = ldlfformulas[0].dfa(translation=args.app.split('-')[1])
elif app=="nfa":
    automaton = afw.to_nfa()

png_path = "outputs/{}/{}/del/{}/{}/{}_automata".format(env_app, app,constraint,instance,app)

automaton.save_png(file=png_path,labels=labels,latex=latex)
if(latex):
    automaton.to_tex(file=png_path+".tex",labels=labels)
            