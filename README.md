# ASP encodings to translate temporal logics into Alternating Automatons 

## Temporal Logics


##### **TEL** (Linear Temporal Logic over finite traces) $LTL_f$

- Theory defining the syntax [tel/theory.lp](./tel/theory.lp) 
- Translation into an Alternating Automaton [tel/automaton.lp](./tel/automaton.lp)
  - Uses numbers from reified output as ids
- Instance example of a *tel* formula[tel/instance_formula.lp](./tel/instance_formula.lp)

##### **DEL** (Linear Dynamic Logic over finite traces) $LDL_f$

- Theory defining the syntax [del/theory.lp](./tel/theory.lp) 
- Translation into an Alternating Automaton [del/automaton.lp](./del/automaton.lp)
  - Uses nested predicates as ids
- Instance example of a *del* formula[del/instance_formula.lp](./del/instance_formula.lp)


## Scripts

#### Check Trace

Checks if a given trace is accepted by a temporal formula.

```
$ scripts/check_trace.sh tel <path/to/formula> <path/to/trace>
```

The trace must be specified using the syntax `&trace{holds(p(),T)}.` Indicating that predicate p holds at time step T. All predicates must have parenthesis. See an example in [trace.lp](./trace.lp).

![Diag](/img/diag-validate.png)

#### Find Traces

Generates all the possible traces for a given formula

```
$ scripts/find_traces.sh tel <path/to/formula>
```
![Diag](/img/diag-generate.png)
