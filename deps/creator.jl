push!(LOAD_PATH, joinpath((@__DIR__), ".."))
using Bokeh
using Bokeh.Model.Dates
using Bokeh.Themes.JSON
using PythonCall

include("jldefault.jl")
include("jlprop.jl")

jlmodel(name)  = pyimport("bokeh.models" => "Model").model_class_reverse_map["$name"]
jlmodelnames() = pyimport("bokeh.models" => "Model").model_class_reverse_map.keys()

jlproperties(name) = jlproperties(jlmodel(name))

function jlproperties(cls::Py)
    attrs = Dict(
        pyconvert(Symbol, attr) => try
            jlprop(cls, getproperty(cls, pyconvert(String, attr)).property)
        catch exc
            @error(
                "Could not deal with $cls.$attr => $(getproperty(cls, pyconvert(String, attr)).property)",
                exception = (exc, Base.catch_backtrace())
            )

            rethrow()
        end
        for attr ∈ cls.properties()
    )
end
