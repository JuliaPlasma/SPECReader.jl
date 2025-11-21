# # Generating Poincaré sections

using GLMakie
using SPECReader


speceq = SPECEquilibrium("test/data/G3V01L0Fi.002.sp.h5")

# The Poincaré data is not loaded into `SPECEquilibrium` object and must be loaded seperately or computed.
# To load the Poincaré you can use

ReadPoincare(speceq)

# or by filename if you haven't loaded the equilibrium first,

ReadPoincare("testing/data/G3V01L0Fi.002.sp.h5")

# Alternatively, to compute a Poincaré on the ``\zeta=0`` plane we can call,

poincare = construct_poincare(speceq; ζ₀=0.0)

# This returns a `PoincarePlane` object which can be plotted easily,

scatter(poincare.ψ, poincare.θ, markersize=3.0)
