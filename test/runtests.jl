using Test
# using SPECreader

@testset "Single volume SPEC tests" begin
    include("Test1Vol.jl")
end

@testset "Multivolume (2) SPEC tests" begin
    include("Test2Vol.jl")
end
