# ASP encodings to translate temporal logics into Alternating Automatons 

This project contains the encodings to transform temporal logic formulas into alternating automatons. 
We work with two different types of formulas:
- **TEL** (Linear Temporal Logic over finite traces) LTLf [tel](./tel) 
-  **DEL** (Linear Dynamic Logic over finite traces) LDLf [del](./del) 

 We will use in this document `del` as an example but it can be substituted by `tel`.


- **Theory** defining the syntax for the formulas [del/theory.lp](./del/theory.lp) 
- **Translation** into an Alternating Automaton [del/automaton.lp](./del/automaton.lp)
- **Instance Encodings** using temporal formulas in an integrity constraint [temporal_constraints](./temporal_constraints) . Can only be used with the form:
```
:- not &del{<formula here>}, <additional atoms>.
```

Temporal constraints are passed tru `gringo` along with the theory definition to unfold their structure. They are saved in its reified format to be handeled by the automaton construction.


- **Runs** of the automaton are generated and checked using the encoding in [run.lp](./run.lp).

## Usage

We give some options to handle, generate and validate traces. The files for each of these options are found in [./traces_transformations/](./traces_transformations/).

### Generation of traces

[./traces_transformations/trace_generator.lp](./traces_transformations/trace_generator.lp)

This encoding will generate possible traces making each atom possibily true at any instant. 
It requires also the use of the encoding [trace_last_generator](./traces_transformations/trace_last_generator.lp) to enforce a last timestep.


1. Construct the reified format.

Example:
```shell
$ gringo temporal_constraints/del_simple_robot_move.lp del/theory.lp --output=reify > reified_outputs/del/instance_generation.lp
```

2. Use the reified output (generated in step 1) and the automaton transformation to generate valid traces the trace. One stable model per accepted run for every possible trace will be generated.

```shell
$ clingo reified_outputs/del/instance_generation.lp del/automaton.lp run.lp traces_transformations/trace_generator.lp
```



### Validation of traces using theory atoms

[./traces_transformations/trace_generator.lp](./traces_transformations/trace_generator.lp)

Using theory atoms we define a trace and check if it is accepted by the automaton. The trace needs to be included in the reification of the formula to share ids.  The trace must also have the last time step explicitly. 

1. Construct the reified format including the trace as theory atoms and the theory to define them.

Example:
```shell
$ gringo temporal_constraints/del_simple_robot_move.lp del/theory.lp traces_transformations/theory_traces/{trace_instances/trace_movements.lp,trace_theory.lp} --output=reify > reified_outputs/del/instance_theory_trace.lp
```

2. Use the reified output (generated in step 1) and the automaton transformation to validate the trace. One stable model per accepted run will be generated
 
Example:
```shell
$ clingo reified_outputs/del/instance_theory_trace.lp del/automaton.lp run.lp traces_transformations/theory_traces/trace_validator.lp
```

### Asprilo Traces

[./traces_transformations/asprilo_traces.lp](./traces_transformations/asprilo_traces.lp)

Transforms the atoms `move` and `pickup` of asprilo into `holds` relationship used by automaton. This allows the automaton to check plans during the computation.


1. Construct the reified format including the asprilo example and the asprilo `.init.lp` encoding for the grounding.

Example:
```shell
$ gringo temporal_constraints/del_simple_robot_move_asprilo.lp del/theory.lp env/asprilo-encodings/{examples/x4_y4_n16_r2_s3_ps1_pr2_u4_o2_N1.lp,input.lp} --output=reify > reified_outputs/del/instance_asprilo.lp
```

2. Use the reified output (generated in step 1), the automaton transformation, the asprilo dynamics and the example same example to generate plans following the temporal constraints.

Example:
```shell
$ clingo reified_outputs/del/instance_asprilo.lp del/automaton.lp run.lp traces_transformations/asprilo_traces.lp env/asprilo-encodings/m/{action-M.lp,goal-M.lp,output-M.lp} env/asprilo-encodings/examples/x4_y4_n16_r2_s3_ps1_pr2_u4_o2_N1.lp -c horizon=8 --outf=0 -V0 --out-atomf=%s. | head -n1 | viz
```

<!-- 


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
![Diag](/img/diag-generate.png) -->
