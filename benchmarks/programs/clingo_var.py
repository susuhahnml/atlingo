'''
Created on Jan 17, 2010
@author: Roland Kaminski
modified by: Javier
'''

import os
import re
import sys
import codecs

clingo_re = {
    "models"      : ("float",  re.compile(r"^(c )?Models[ ]*:[ ]*(?P<val>[0-9]+)\+?[ ]*$")),
    "optimal"      : ("float",  re.compile(r"^(c )?[ ]*Optimal[ ]*:[ ]*(?P<val>[0-9]+)\+?[ ]*$")),
    "choices"     : ("float",  re.compile(r"^(c )?Choices[ ]*:[ ]*(?P<val>[0-9]+)\+?[ ]*")),
    "time"        : ("float",  re.compile(r"^Real time \(s\): (?P<val>[0-9]+(\.[0-9]+)?)$")),
    "conflicts"   : ("float",  re.compile(r"^(c )?Conflicts[ ]*:[ ]*(?P<val>[0-9]+)\+?[ ]*")),
    "ctime"       : ("float",  re.compile(r"^(c )?Time[ ]*:[ ]*(?P<val>[0-9]+(\.[0-9]+)?)")),
    "csolve"      : ("float",  re.compile(r"^(c )?Time[ ]*:[ ]*[0-9]+(\.[0-9]+)?s[ ]*\(Solving:[ ]*(?P<val>[0-9]+(\.[0-9]+)?)")),
    "domain"      : ("float",  re.compile(r"^(c )?Choices[ ]*:[ ]*[0-9]+[ ]*\(Domain:[ ]*(?P<val>[0-9]+)")),
    "rules"        : ("float",  re.compile(r"^(c )?Rules[ ]*:[ ]*(?P<val>[0-9]+)")),
    "roriginal"      : ("float",  re.compile(r"^(c )?Rules[ ]*:[ ]*[0-9]+(\.[0-9]+)?[ ]*\(Original:[ ]*(?P<val>[0-9]+(\.[0-9]+)?)")),
    "rchoices"        : ("float",  re.compile(r"^(c )?  Choice [ ]*:[ ]*(?P<val>[0-9]+)")),
    "atoms"        : ("float",  re.compile(r"^(c )?Atoms[ ]*:[ ]*(?P<val>[0-9]+)")),
    "bodies"        : ("float",  re.compile(r"^(c )?Bodies[ ]*:[ ]*(?P<val>[0-9]+)")),
    "equiv"        : ("float",  re.compile(r"^(c )?Equivalences[ ]*:[ ]*(?P<val>[0-9]+)")),
    "vars"        : ("float",  re.compile(r"^(c )?Variables[ ]*:[ ]*(?P<val>[0-9]+)")),
    "cons"        : ("float",  re.compile(r"^(c )?Constraints[ ]*:[ ]*(?P<val>[0-9]+)")),
    "restarts"    : ("float",  re.compile(r"^(c )?Restarts[ ]*:[ ]*(?P<val>[0-9]+)\+?[ ]*")),
    "optimum"     : ("string", re.compile(r"^(c )?Optimization[ ]*:[ ]*(?P<val>(-?[0-9]+)( -?[0-9]+)*)[ ]*$")),
    "status"      : ("string", re.compile(r"^(s )?(?P<val>SATISFIABLE|UNSATISFIABLE|UNKNOWN|OPTIMUM FOUND)[ ]*$")),
    "interrupted" : ("string", re.compile(r"(c )?(?P<val>INTERRUPTED)")),
    "error"       : ("string", re.compile(r"^\*\*\* ERROR: (?P<val>.*)$")),
    "memerror"    : ("string", re.compile(r"^Maximum VSize (?P<val>exceeded): sending SIGTERM then SIGKILL")),
    "memerror2"   : ("string", re.compile(r"^\*\*\* ERROR: \((?P<val>.*)\): std::bad_alloc")),
    "mem"         : ("float",  re.compile(r"^Max\. virtual memory \(cumulated for all children\) \(KiB\): (?P<val>[0-9]+)")),
    "ground0"     : ("float",  re.compile(r"^(c )?First Ground[ ]*:[ ]*(?P<val>[0-9]+(\.[0-9]+)?)")),
    "groundN"     : ("float",  re.compile(r"^(c )?Next Ground[ ]*:[ ]*(?P<val>[0-9]+(\.[0-9]+)?)")),
    "max_length"  : ("float",  re.compile(r"^(c )?Max\. Length[ ]*:[ ]*(?P<val>[0-9]+)\+?[ ]*")),
    "sol_length"  : ("float",  re.compile(r"^(c )?Sol\. Length[ ]*:[ ]*(?P<val>[0-9]+)\+?[ ]*")),
    "calls"       : ("float",  re.compile(r"^(c )?Calls[ ]*:[ ]*(?P<val>[0-9]+)\+?[ ]*$")),
    "ngadded"     : ("float",  re.compile(r"total nogoods added:[ ]*(?P<val>[0-9]+)\+?[ ]*$")),
}


status_mapping = {"SATISFIABLE": 1, "UNSATISFIABLE": 0, "UNKNOWN": 2, "OPTIMUM FOUND": 3}

result   = []

def clingo(file_name):
    res     = { "time": ("float", 1200) }
    f = open(file_name,'r')
    for line in f.readlines():
        for val, reg in clingo_re.items():
            m = reg[1].search(line)
            if m:
                res[val] = (reg[0], float(m.group("val")) if reg[0] == "float" else m.group("val"))
    for key, val in res.items(): result.append((key, val[0], val[1]))
    f.close()
    return result



r = clingo("/Users/susana/School/Masters(Uni-Potsdam)/MasterCS/IM-ASP/atlingo/benchmarks/test_stat.txt")
for t in r:
    print(t)