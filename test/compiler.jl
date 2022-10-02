const StyleSheets = Union{Dict{String, Union{BokehServer.Models.iStyles, Dict{String, Union{Nothing, String}}}}, String}

@BokehServer.model mutable struct Custom <: BokehServer.Models.iUIElement
    __implementation__ = "custom.ts"

    text :: String = "Custom text"
    slider  :: BokehServer.Models.Slider
    visible :: Bool = true
    classes :: Vector{String} = String[]
    styles :: Union{BokehServer.Models.iStyles, Dict{String, Union{Nothing, String}}} = Dict{String, Union{Nothing, String}}()
    stylesheets :: Vector{StyleSheets} = StyleSheets[]
end

@testset "bundlemodel" begin
    mdl = BokehServer.Server.JSCompiler.CustomModel(Custom)
    vals = Dict{String, BokehServer.Server.JSCompiler.CustomModel}()
    push!(vals, BokehServer.Server.JSCompiler._qualifiedname(mdl) => mdl)
    out = BokehServer.Server.JSCompiler._bundle_models(vals)
    
    recreate = false
    recreate && open("custom.js", "w") do io
        print(io, out)
    end
    truth = read(joinpath(@__DIR__, "custom.js"), String)
    @testset for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(out)))
        @test i == j
    end

    out = BokehServer.Server.JSCompiler.bundle_models()
    recreate && open("bundle.js", "w") do io
        print(io, out)
    end
    truth = read(joinpath(@__DIR__, "bundle.js"), String)
    @testset for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(out)))
        @test i == j
    end
end

pop!(BokehServer.Model.MODEL_TYPES, Custom)
