# # Basic operation

using SPECReader

# First we'll read in the SPEC output file

speceq = SPECEquilibrium("test/data/G3V01L0Fi.002.sp.h5")

# We can get the Fourier modes of the boundary of the equilibrium,

specbound = get_boundary(speceq)

# note that we also have the ability to read the boundary directly from the file if that's all we're interested in,

ReadBoundary("test/data/G3V01L0Fi.002.sp.h5")

# The Fourier components of the axis can be obtained with,

specaxis = get_axis(speceq)

# Given a point ``(s,\theta,\zeta)`` in the logical coordinates, we can recover the real-space coordinates,

RZ = get_RZ(0.0, 0.0, 0.0, speceq)

# To get the boundary in R-Z coordinates we can just use list comprehension, the last input to the function is the
# volume number, so we can use the `NumberofVolumes` to get the boundary,

boundary = [get_RZ(1.0, θ, ζ, speceq, speceq.NumberofVolumes) for θ in 0:2π/100:2π, ζ in 0:2π/100:2π]

# Conversely, we can attempt to recover the logical coordinates of a real-space coordinate,

stz = find_sθζ(RZ, 0.0, speceq, 1)

# note that this requires a nonlinear solve, if the coordinate cannot be found in the domain ``[-1,1]\times[0,2\pi)^2\times[1,l_{max}]``,
#  (where ``l_{max}`` is the maximum number of volumes), then the method will try a number of initial conditions before returning.
