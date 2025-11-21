# SPECreader

[![Static Badge](https://img.shields.io/badge/docs-dev-blue)](https://juliaplasma.github.io/SPECReader.jl/dev/)
[![CI](https://github.com/JuliaPlasma/SPECReader.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaPlasma/SPECReader.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/github/Spiffmeister/SPECreader/graph/badge.svg?token=3RMCT7EJPC)](https://codecov.io/github/Spiffmeister/SPECreader)

This package is for reading and manipulating output from the [Stepped Pressure Equilibrium Code](https://github.com/PrincetonUniversity/SPEC) (SPEC).

To add:
```julia
] add SPECReader
```


## Example

Given the output file `G1V02L0Fi.001.sp.h5` it can be read by (this file is located in the `test` directory),

```julia
using SPECReader

speceq = SPECEquilibrium("test/data/G1V02L0Fi.001.sp.h5")
```





## Plotting

There are some WIP plotting routines using [Makie](https://docs.makie.org/stable/) recipes. See the documentation for an example.
