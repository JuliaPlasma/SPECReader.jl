# # Plotting

using SPECReader
using GLMakie

# For this short example we'll read and plot. Note that the plotting functions are part of an extension and use [Makie](https://docs.makie.org/stable/) recipes.

# First we'll read in the SPEC output file

speceq = SPECEquilibrium("test/data/G3V01L0Fi.002.sp.h5")

# We can plot the boundary in 3D,

f, ax, sc = plotboundary(speceq)

# Then we can add the axis to the plot,

plotaxis!(ax, speceq)

f
