module Bokeh
# a very simplified Bokeh for parsing bokeh
include(joinpath((@__DIR__), "..", "..", "src", "abstracttypes.jl"))
include(joinpath((@__DIR__), "..", "..", "src", "model.jl"))
end

module CodeCreator
using PythonCall

include("defaults.jl")
include("properties.jl")
include("hierarchy.jl")
include("dependencies.jl")

filename(name::String) = lowercase(String(structname(name)))

function abstracttypescode(io::IO)
    direct = Dict{String, Symbol}()
    done   = Set{Symbol}()
    println(io, "module ModelTypes")
    println(io, "using ..AbstractTypes")
    for (name, opts) ∈ sort!(collect(hierarchy()); by = string∘first)
        @assert length(opts) > 1
        for i ∈ (length(opts)-1):-1:1
            if opts[i] ∉ done
                println(io, "abstract type $(opts[i]) <: $(opts[i+1]) end")
                push!(done, opts[i])
            end
        end
        direct[name] = opts[1]
    end
    println(io, "end")
    return direct
end

doccode(::IO, ::Nothing, ::Int) = nothing
function doccode(io::IO, doc::String, indent::Int)
    println(io, " "^indent, "\"\"\"")
    for line ∈ split(strip(props[:__doc__]), '\n')
        println(io, " "^indent, strip(line))
    end
    println(io, " "^indent, "\"\"\"")
    nothing
end

const _BM_PATT = r"Bokeh\.Models\." => "i"

function structcode(io::IO, name::String, parent; adddoc :: Symbol = :none)
    props = parseproperties(model(name))

    println(io)
    (adddoc ∈ (:all, :struct)) && doccode(io, props[:__doc__], 0)

    println(io, "@model mutable struct $(structname(name)) <: $parent")
    for (i, j) ∈ sort!(collect(props); by = string∘first)
        (i ≡ :__doc__) && continue

        println(io)
        (adddoc ∈ (:all,)) && doccode(io, j.doc, 4)
        println(
            io,
            replace(
                string(
                    "    $i :: $(j.type)",
                    if isnothing(j.default)
                        ""
                    elseif something(j.default) isa Expr
                        " = $(something(j.default))"
                    else
                        " = $(repr(something(j.default)))"
                    end
                ),
                _BM_PATT
            )
        )
    end
        
    println(io, "end")
end

function createmainfile(io::IO, deplist)
    println(io, "#- file created by '$(@__FILE__)': edit at your own risk! -#")
    println(io, "module Models")
    println(io, "using Dates")
    println(io, "using ..Bokeh")
    println(io, "using ..Model")
    println(io, "using ..AbstractTypes")

    done   = Set{Symbol}()
    for (name, opts) ∈ sort!(collect(hierarchy()); by = string∘first)
        @assert length(opts) > 1
        for i ∈ (length(opts)-1):-1:1
            rem = setdiff(opts, done)
            if !isempty(rem)
                println(io, "using ..ModelTypes: $(join(rem, ", "))")
                push!(done, rem...)
            end
        end
    end

    println(io, "const iTemplate = String")
    for name ∈ sort!(collect(keys(deplist)))
        println(io, "include(\"models/$(filename(name)).jl\")")
    end
    println(io, "end")
end

function createcode(; adddoc ::Symbol = :none)
    deplist       = Dict(
        i => dependencies(model(i))
        for i ∈ modelnames()
        if !startswith("$i", "Abstract")
    )
    file(f, x...) = open(joinpath((@__DIR__), "..", "..", "src", x...), "w") do io
        println(io, "#- file created by '$(@__FILE__)': edit at your own risk! -#")
        f(io)
    end

    cls = file(abstracttypescode, "modeltypes.jl")
    file(Base.Fix2(createmainfile, deplist), "models.jl")
    for name ∈ sort!(collect(keys(deplist)))
        file("models", "$(filename(name)).jl") do io
            structcode(io, name, cls[name]; adddoc)
        end
    end
end
end
