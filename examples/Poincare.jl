using GLMakie
using SPECreader


speceq = SPECEquilibrium("test/data/G3V01L0Fi.002.sp.h5")

# The Poincar\'e data is not loaded into SPECEquilibrium object and must be loaded seperately or computed.
# To load the Poincar\'e you can use
# ```julia
# ReadPoincare(speceq)
# ```
# or by filename if you haven't loaded the equilibrium first,
# ```julia
# ReadPoincare("testing/data/G3V01L0Fi.002.sp.h5")
# ```
# Alternatively, to compute a Poincar\'e on the ``\\zeta=0`` plane we can call,

poincare = construct_poincare(speceq)

# By default this will compute a Poincar\'e section at ``\\zeta=0``. This returns a `PoincarePlane` object which can be plotted easily,

scatter(poincare.ψ, poincare.θ, markersize=3.0)
