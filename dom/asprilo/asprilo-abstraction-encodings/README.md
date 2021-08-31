# Asprilo Abstraction Encodings

Encodings for planning with abstraction in asprilo.


## Md Test Instances

Directory `./instances/md` contains a set of
[Md](https://github.com/potassco/asprilo/blob/develop/docs/specification.md#domain-md-destinations-for-domain-m)
test instances, further categorized with respect to
layout structure (`gridword`,`structured`) and
size (grid dimensions, number of blocked grid nodes, number of robots)

### Howto use with M Encodings

To solve an Md test instance with a regular M-encoding,
such as our [standard M encoding](https://github.com/potassco/asprilo-encodings/tree/master/m/encoding.lp),
you may augment (or convert) the instance with corresponding facts (shelves, orders, products) expected by the M domain:
This can be achieved by adding the augmentation encoding
[`./misc/augment-md-to-m.lp`](https://github.com/potassco/asprilo/blob/develop/misc/augment-md-to-m.lp)
from the asprilo suite to your (otherwise regular) clingo call.
For example, to solve the instance
`./instances/md/gridworld/x10_y10_n100_r10/x10_y10_n100_r10_s10_ps1_pr10_u10_o10_l10_N001.lp` with our standard M encoding,
you can run

``` bash
clingo \
    --out-ifs='\n' \
    --out-atomf='%s.' \
    -c horizon=10 \
    $ENCODINGS/m/encoding.lp \
    $ASPRILO/misc/augment-md-to-m.lp \
    ./instances/md/gridworld/x10_y10_n100_r10/x10_y10_n100_r10_s10_ps1_pr10_u10_o10_l10_N001.lp
```

where

- `$ENCODINGS` is an environment variable that holds the path to your downloaded (or cloned)
  [development branch of asprilo-encodings](https://github.com/potassco/asprilo-encodings/tree/develop)
- `$ASPRILO` is an environment variable that holds the path to your downloaded (or cloned)
  [development branch of asprilo](https://github.com/potassco/asprilo/tree/develop)


## Directory Structure

- `./encodings` contains ASP encodings for planning with abstraction
- `./instances` contains example/test instances
- `./asprilo-encodings` contains our [standard-asprilo-encodings](https://github.com/potassco/asprilo-encodings) as submodule


