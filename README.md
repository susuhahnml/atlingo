# ASP encodings to translate temporal logics into Alternating Automatons 

## Temporal Logics


##### **TEL** (Linear Temporal Logic over finite traces) LTLf

- Theory defining the syntax [tel/theory.lp](./tel/theory.lp) 
- Translation into an Alternating Automaton [tel/automaton.lp](./tel/automaton.lp)
  - Uses numbers from reified output as ids
- Instance example of a *tel* formula[tel/instance_formula.lp](./tel/instance_formula.lp)

##### **DEL** (Linear Dynamic Logic over finite traces) LDLf

- Theory defining the syntax [del/theory.lp](./del/theory.lp) 
- Translation into an Alternating Automaton [del/automaton.lp](./del/automaton.lp)
  - Uses nested predicates as ids
- Instance example of a *del* formula[del/instance_formula.lp](./del/instance_formula.lp)


## Automaton

The shared encodings for both temporal logics are the following:

- Definition of a run [run.lp](run.lp) 
  - This encoding will generate all accepted runs.
- Validation of traces validates if a given trace is accepted[trace_validator.lp](trace_validator.lp)
- Generation of traces, used to find all possible traces[trace_finder.lp](trace_finder.lp)



## Scripts

Replace `<tel>` by `<del>` in the commands to use dynamic formulas.

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
