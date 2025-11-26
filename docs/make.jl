
push!(LOAD_PATH, "../src/")

using Documenter, Literate, SPECReader


LitPathExamples = [
    joinpath(@__DIR__, "..", "examples", filename) for filename in readdir(joinpath(@__DIR__, "..", "examples"))
]

DocSrc = joinpath(@__DIR__, "src", "examples") #.md creation path

for example in LitPathExamples
    Literate.markdown(example, DocSrc, codefence="```text" => "```")
end


makedocs(sitename="SPECReader",
    pages=[
        "Home" => "index.md",
        "Examples" => [
            "examples/Basics.md",
            "examples/Poincare.md",
            "examples/Plotting.md"
        ]
    ],
    modules=[SPECReader],
    format=Documenter.HTML(prettyurls=false),
    warnonly=Documenter.except(:linkcheck, :footnote)
)

deploydocs(
    repo="github.com/JuliaPlasma/SPECReader.jl.git",
)
