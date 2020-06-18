# ASP encodings to translate temporal logics into Alternating Automatons 

This project contains the encodings to transform temporal logic formulas into alternating automatons which allow validation and generation of traces.
We work with two different types of formulas:
- **TEL** (Linear Temporal Logic over finite traces) LTLf
-  **DEL** (Linear Dynamic Logic over finite traces) LDLf

We will use in this document `del` as an example but it can be substituted by `tel`.

We think of this approach in two steps:
1.  Generation of a declarative representation of an automaton from a theory atom representing a temporal formula, with files in [formula_to_automaton](./formula_to_automaton).
2.  Using a declarative representation of an automaton to check if a trace is accepted by generating all valid runs  with files in [automata_run](./automata_run). This process has two options.
    1. The trace is explicitly provided via facts, or an external encoding (such as asprilo). 
    2. Traces are generated using a choice rule, thus computing all valid traces for a given horizon.

We now explain the encodings used and provide examples.

## 1. Formula to automaton

### Step 1.1: Reification of theory atom

#### Requires:

- **Temporal formula in an integrity constraint** such as [del_robot_move](./examples/temporal_constraints/del_robot_move.lp) with format:
```
:- not &del{<formula here>}, <additional atoms>.
```

- **Theory definition** defining the syntax for the formulas [del/theory.lp](./formula_to_automaton/del/theory.lp).

Temporal constraints are passed tru `gringo` along with the theory definition to unfold their structure. They are saved in its reified format to represent the syntax tree that will by the automaton construction.

Example:
```shell
$ gringo examples/temporal_constraints/del_robot_move.lp formula_to_automaton/del/theory.lp --output=reify > output_reified_formulas/del/formula_1.lp
```

### Step 1.2: Translation of reified formula to automaton representation

We transform the formula to an automaton with the file [automata.lp](./formula_to_automaton/automata.lp).

#### Requires:

- **Last propostion** We define the proposition for the last step using [last_prop.lp](./formula_to_automaton/last_prop.lp)
- **Atomic propositions** Gather all atomic propositions used in the formula from the reified output with [propositional_atoms.lp](./formula_to_automaton/propositional_atoms.lp)
- **States** Compute the states of the automaton. This process depends on the type of logic we use. [del/states.lp](./formula_to_automaton/del/states.lp).
- **Delta** Compute the transition function. This process depends on the type of logic we use. [del/delta.lp](./formula_to_automaton/del/delta.lp).
- **Map** Create a mapping from ids used in the reification with [id_map.lp](./formula_to_automaton/id_map.lp). This is used in the traces and for visualization.

The representation is the saved inside [output_automata_facts](./output_automata_facts)

Example:
```shell
$ clingo output_reified_formulas/del/formula_1.lp formula_to_automaton/automata.lp --outf=0 -V0 --out-atomf=%s. | head -n1 | tr ". " ".\n"  > output_automata_facts/del/automata_1.lp
```

## 2. Runs of the automaton

To compute the runs for an automaton we require a trace defining which atomic propositions hold in what instant. Given the trace, all accepted runs for the automaton are computed using [run.lp](./automata_run/run.lp). 

The trace can be obtain in two ways:

1.  It is generated using a choice rule [trace_generator.lp](./automata_run/trace_generator.lp)

Example generating traces of maximum length 3:
```shell
$ clingo output_automata_facts/del/automata_1.lp automata_run/run.lp automata_run/trace_generator.lp -c horizon=3
```


1.  It is explicitly defined, this option requires a definition of the mapping, see example [example](./examples/traces/asprilo_trace_mapping.lp), and either an explicit trace like [trace](./examples/traces/asprilo_trace_explicit_valid_1.lp) or an encoding passed generating the traces.

Example explicit valid trace:
```shell
$ clingo output_automata_facts/del/automata_1.lp automata_run/run.lp examples/traces/asprilo_trace_mapping.lp examples/traces/asprilo_trace_explicit_valid_1.lp -c horizon=6
```

Example explicit invalid trace:
```shell
$ clingo output_automata_facts/del/automata_1.lp automata_run/run.lp examples/traces/asprilo_trace_mapping.lp examples/traces/asprilo_trace_explicit_invalid.lp -c horizon=6
```

Example parallel to asprilo encoding:
```shell
$ clingo output_automata_facts/del/automata_1.lp automata_run/run.lp examples/traces/asprilo_trace_mapping.lp env/asprilo-encodings/m/{action-M.lp,goal-M.lp,output-M.lp} env/asprilo-encodings/input.lp env/asprilo-encodings/examples/x4_y4_n16_r2_s3_ps1_pr2_u4_o2_N1.lp -c horizon=8
```



*Note: This process obtains one stable model per accepted run. When multiple traces are given, each will generate the corresponding runs.* 

*Note: The last time step is generated with a choice rule before the given horizon. Therefore many traces might be considered.*


## Further integration with asprilo

Use other predicates as part of constraint by including them in the reification.

Example:
```shell
$ gringo examples/temporal_constraints/del_robot_move_asprilo.lp formula_to_automaton/del/theory.lp env/asprilo-encodings/{examples/x4_y4_n16_r2_s3_ps1_pr2_u4_o2_N1.lp,input.lp} --output=reify > output_reified_formulas/del/formula_2.lp
```

Perform step 1.2 normally.

Example:
```shell
$ clingo output_reified_formulas/del/formula_2.lp formula_to_automaton/automata.lp --outf=0 -V0 --out-atomf=%s. | head -n1 | tr ". " ".\n"  > output_automata_facts/del/automata_2.lp
```

Use a pipeline with the visualization with the same example.

```shell
$ clingo output_automata_facts/del/automata_2.lp automata_run/run.lp examples/traces/asprilo_trace_mapping.lp env/asprilo-encodings/m/{action-M.lp,goal-M.lp,output-M.lp} env/asprilo-encodings/input.lp env/asprilo-encodings/examples/x4_y4_n16_r2_s3_ps1_pr2_u4_o2_N1.lp -c horizon=8 --outf=0 -V0 --out-atomf=%s. | head -n1 | viz
```
