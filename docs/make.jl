
push!(LOAD_PATH,"../src/")

using Documenter, Literate, SPECreader

LitPathExample = joinpath(@__DIR__,"..","examples","Basics.jl")
LitPathExample = joinpath(@__DIR__,"..","examples","Poincare.jl")
LitPathExample = joinpath(@__DIR__,"..","examples","Plotting.jl")
DocSrc = joinpath(@__DIR__,"src","examples") #.md creation path
Literate.markdown(LitPathExample,DocSrc,codefence="```text" => "```")


makedocs(sitename="SPECreader",
    pages = [
        "Home" => "index.md",
        "Examples" => [
            "examples/Basics.md",
            "examples/Poincare.md"
            "examples/Plotting.md"
        ]
    ],
    modules=[SPECreader],
    format=Documenter.HTML(prettyurls=false),
    warnonly = Documenter.except(:linkcheck,:footnote)
    )

deploydocs(
    repo = "github.com/Spiffmeister/SPECreader.jl.git",
)
