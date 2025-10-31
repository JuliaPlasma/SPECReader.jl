"""
    SPECreader

Julia version of the SPEC-field-reader by Zhisong Qu https://github.com/zhisong/SPEC-field-reader
"""
module SPECreader

using HDF5: h5open, read
using LinearAlgebra: norm
using StaticArrays
using NonlinearSolve: NonlinearProblem, solve
using Optim: optimize
using OrdinaryDiffEq: ODEProblem, solve, EnsembleProblem, EnsembleThreads, Tsit5, remake

# Data Structures
include("DataStructs.jl")
# reading in HDF5
include("BasisFunctions.jl")
# Metrics
include("Geometry.jl")
include("Fields.jl")
# Fields
# Basis functions for SPEC geometry
include("Useful.jl")

include("plotting.jl")


export SPECEquilibrium
export ReadBoundary, ReadPoincare

export get_boundary, get_axis
export get_RZ, find_sθζ

export get_Bfield
export field_line!

export construct_poincare


export plotboundary, plotboundary!
export plotaxis, plotaxis!

end
