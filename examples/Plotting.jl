# # An example of reading in a file

using SPECreader
using GLMakie

# for this short example we'll read and plot

# First we'll read in the SPEC output file

speceq = SPECEquilibrium("test/data/G3V01L0Fi.002.sp.h5")

# We can get the Fourier modes of the boundary of the equilibrium,

f, ax, sc = plotboundary(speceq)

plotaxis!(ax, speceq)

f
