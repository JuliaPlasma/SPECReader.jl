module plotting


using Makie, GeometryBasics
using LinearAlgebra: norm, normalize
using SPECReader

import SPECReader: plotboundary, plotboundary!
import SPECReader: plotaxis, plotaxis!


# import SPECreader

"""
Plot the boundary of a `SPECEquilibrium` object. Recommend using `GLMakie` rather than `CairoMakie` since this is always a 3D plot.
"""
Makie.@recipe PlotBoundary begin
    transparency = true
end

Makie.preferred_axis_type(::PlotBoundary) = LScene

function Makie.plot!(input::PlotBoundary{<:Tuple{<:SPECReader.SPECEquilibrium}})

    speceq = input[1][]

    θ_rng = range(0.0, 2π, 101)
    ζ_rng = range(0.0, 2π, 1001)

    lvol = speceq.NumberofVolumes

    boundary_points_x = [get_RZ(1.0, θ, ζ, speceq, lvol)[1] * cos(ζ) for θ in θ_rng, ζ in ζ_rng]
    boundary_points_z = [get_RZ(1.0, θ, ζ, speceq, lvol)[2] for θ in θ_rng, ζ in ζ_rng]
    boundary_points_y = [norm(get_RZ(1.0, θ, ζ, speceq, lvol)) * sin(ζ) for θ in θ_rng, ζ in ζ_rng]

    # Convert to Point3fs
    points = vec([Point3f(x, y, z) for (x, y, z) in zip(boundary_points_x, boundary_points_y, boundary_points_z)])

    # Build faces for the plotting
    _faces = decompose(QuadFace{GLIndex}, Tessellation(Rect(0, 0, 1, 1), size(boundary_points_z)))

    # Compute the normals for the points
    _normals = normalize.(points)

    modB = [norm(SPECReader.get_Bfield(1.0, θ, ζ, speceq)) for θ in θ_rng, ζ in ζ_rng]

    # Assign the colours to the faces
    _color = FaceView(modB[:], _faces)

    # Build the mesh from the stuff above
    solidmesh = GeometryBasics.mesh(points, _faces, normal=_normals, color=_color)

    mesh!(input, solidmesh, transparency=input.transparency)

    return input
end



"""
Plot the axis of a `SPECEquilibrium` object. Recommend using `GLMakie` rather than `CairoMakie` since this is always a 3D plot.
"""
Makie.@recipe PlotAxis begin
    color = :red
end

Makie.preferred_axis_type(::PlotAxis) = LScene

function Makie.plot!(input::PlotAxis{<:Tuple{<:SPECReader.SPECEquilibrium}})
    speceq = input[1][]

    RZ_axis = [get_RZ(-0.9, 0.0, ζ, speceq, 1) for ζ in range(0.0, 2π, 1001)]

    boundary_R_points = first.(RZ_axis) .* cos.(range(0.0, 2π, 1001))
    boundary_Z_points = last.(RZ_axis)
    boundary_y_points = norm.(RZ_axis) .* sin.(range(0.0, 2π, 1001))

    lines!(input, boundary_R_points, boundary_y_points, boundary_Z_points, color=input.color)

    return input
end







end
