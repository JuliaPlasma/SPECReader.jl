

"""
    field_line!(ẋ, t, x, SpecVol::SPECEquilibrium,lvol::Int=1)

In place field line tracing function given a `lvol`

TODO: Implement for multi-volume spec equilibria
"""
function field_line!(ẋ, t, x, SpecVol::SPECEquilibrium,lvol::Int=1)

    B1, B2, B3 = get_Bfield(x[1], x[2], t, SpecVol,lvol)

    ẋ[1] = B1 / B3
    ẋ[2] = B2 / B3

end






struct poin_data
    ψ :: Vector{Float64}
    θ :: Vector{Float64}
end

"""
    construct_grid(χ::Function,grid::Grid2D,z::Vector)
Constructs the backwards and forward planes for a given plane

Inputs:
- Field line ODE that returns ``[x,y]``
- GridType
- z values of planes to trace to

Outputs:
- ParallelGrid object (see [ParallelGrid](@ref))
"""
function construct_poincare(H::Function,x::Vector{T},y::Vector{T};N_trajs::Int=500,N_orbs::Int=100,circletransform=true) where T

    ζ₀ = 2π*collect(0:N_orbs/2)

    x₀ = rand(2,N_trajs)

    # Ensure things are within domains
    x₀[1,:] = (x[end] - x[1])*x₀[1,:] .+ x[1] #ψ
    x₀[2,:] = (y[end] - y[1])*x₀[2,:] .+ y[1] #θ

    function prob_fn(prob,i,repeat)
        remake(prob,u0=x₀[:,i])
    end

    # Construct the problem and solve the trajectories in parallel
    ζ = (0.0,N_orbs*π)
    P = ODEProblem(H,x₀[:,1],ζ)
    EP = EnsembleProblem(P,prob_func=prob_fn)

    # simf = solve(EP,Vern9(),EnsembleDistributed(),trajectories=N_trajs,saveat=ζ₀,abstol=1e-6,reltol=1e-6)
    simf = solve(EP,Tsit5(),EnsembleDistributed(),trajectories=N_trajs,saveat=ζ₀,reltol=1e-10)

    ζ = (0.0,-N_orbs*π)
    P = ODEProblem(H,x₀[:,1],ζ)
    EP = EnsembleProblem(P,prob_func=prob_fn)
    simb = solve(EP,Tsit5(),EnsembleDistributed(),trajectories=N_trajs,saveat=-ζ₀,reltol=1e-10)

    # Loop though outputs and store plane intersecetions
    # @show vcat(simf.u[1].u, simb.u[1].u[2:end])

    N_orbs += 1
    data = zeros(2,N_trajs*N_orbs)
    for i = 1:N_trajs
        u = vcat(simf.u[i].u, simb.u[i].u[2:end])
        if circletransform
            data[:,(i-1)*N_orbs+1:i*N_orbs] = mod.(hcat(u...),2π)
        else
            data[:,(i-1)*N_orbs+1:i*N_orbs] = hcat(u...)
        end
    end

    if y[1] == -π
        data[2,:] = rem2pi.(data[2,:],RoundNearest)
    end

    return poin_data(data[1,:],data[2,:])
end







