

"""
    field_line!(ẋ, t, x, SpecVol::SPECEquilibrium,lvol::Int=1)

In place field line tracing function given a `lvol`

TODO: Implement for multi-volume spec equilibria
"""
function field_line!(ẋ, t, x, SpecVol::SPECEquilibrium, lvol::Int=1)

    B1, B2, B3 = get_Bfield(x[1], x[2], t, SpecVol, lvol)

    ẋ[1] = B1 / B3
    ẋ[2] = B2 / B3

end






struct PoincarePlane
    ψ::Vector{Float64}
    θ::Vector{Float64}
    ζ::Float64
end

"""
    construct_poincare(SpecVol::SPECEquilibrium; N_trajs::Int=500, N_orbs::Int=100, circletransform=false)

Constructs a Poincar\'e section at a given ζ₀ position.

TODO: Multiple Poincar\'e sections.
"""
function construct_poincare(SpecVol::SPECEquilibrium; ζ₀=0.0, N_trajs::Int=500, N_orbs::Int=100, circletransform=false)

    ζ_slices = 2π * collect(0:N_orbs/2) .+ ζ₀

    x₀ = rand(2, N_trajs)

    x_lims = [-1.0, 1.0]
    y_lims = [0.0, 2π]

    # Ensure things are within domains
    x₀[1, :] = (x_lims[end] - x_lims[1]) * x₀[1, :] .+ x_lims[1] #ψ
    x₀[2, :] = (y_lims[end] - y_lims[1]) * x₀[2, :] .+ y_lims[1] #θ
    choose_vol = rand(1:SpecVol.NumberofVolumes, N_trajs)

    # Function for moving to the next initial condition
    function prob_fn(prob, i, repeat)
        remake(prob, u0=x₀[:, i], p=[choose_vol[i]])
    end

    # params = [1]

    # Construct the problem and solve the trajectories in parallel
    ζ = (0.0, N_orbs * π)
    P = ODEProblem((ẋ, x, p, t) -> field_line!(ẋ, t, x, SpecVol, p[1]), x₀[:, 1], ζ, choose_vol[1])
    EP = EnsembleProblem(P, prob_func=prob_fn)
    simf = solve(EP, Tsit5(), EnsembleThreads(), trajectories=N_trajs, saveat=ζ_slices, reltol=1e-10)

    ζ = (0.0, -N_orbs * π)
    P = ODEProblem((ẋ, x, p, t) -> field_line!(ẋ, t, x, SpecVol, p[1]), x₀[:, 1], ζ, choose_vol[1])
    EP = EnsembleProblem(P, prob_func=prob_fn)
    simb = solve(EP, Tsit5(), EnsembleThreads(), trajectories=N_trajs, saveat=-ζ_slices, reltol=1e-10)

    # Loop though outputs and store plane intersecetions
    N_orbs += 1
    data = zeros(2, N_trajs * N_orbs)

    poincare_data = PoincarePlane(zeros(N_trajs * N_orbs), zeros(N_trajs * N_orbs), ζ₀)


    for i = 1:N_trajs
        u = vcat(simf.u[i].u, simb.u[i].u[2:end])
        # Move this chunk of field lines to the output
        if circletransform
            data[:, (i-1)*N_orbs+1:i*N_orbs] = mod.(hcat(u...), 2π)
        else
            data[:, (i-1)*N_orbs+1:i*N_orbs] = hcat(u...)
        end

        s = first.(u)
        t = last.(u)

        st = map((s, t) -> get_RZ(s, t, ζ_slices[1], SpecVol, choose_vol[i]), s, t)
        poincare_data.ψ[(i-1)*N_orbs+1:i*N_orbs] = first.(st)
        poincare_data.θ[(i-1)*N_orbs+1:i*N_orbs] = last.(st)
    end

    if y_lims[1] == -π
        data[2, :] = rem2pi.(data[2, :], RoundNearest)
    end

    return poincare_data
end
