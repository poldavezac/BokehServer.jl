#!/usr/bin/env -S julia --startup-file=no --history-file=no --project=./deps
push!(LOAD_PATH, joinpath((@__DIR__), ".."))
using Bokeh
using PythonCall

include("defaults.jl")
include("properties.jl")
include("hierarchy.jl")
include("dependencies.jl")

function jlabstracttypescode(io::IO)
    direct = Dict{String, Symbol}()
    done   = Set{Symbol}()
    for (name, opts) ∈ jlhierarchy()
        (length(opts) > 2) && for i ∈ (length(opts)-1):-1:2
            if opts[i] ∉ done
                println(io, "abstract type $(opts[i]) <: $(opts[i+1]) end")
                push!(done, opts[i])
            end
        end
        direct[name] = opts[2]
    end
    return direct
end

jldoccode(::IO, ::Nothing, ::Int) = nothing
function jldoccode(io::IO, doc::String, indent::Int)
    println(io, " "^indent, "\"\"\"")
    for line ∈ split(strip(props[:__doc__]), '\n')
        println(io, " "^indent, strip(line))
    end
    println(io, " "^indent, "\"\"\"")
    nothing
end

function jlstructcode(io::IO, name::String, parent; adddoc :: Symbol = :none)
    klass = Symbol(occursin(".dom.", name) ? "Dom$(split(name, '.')[end])" : name)
    props = jlproperties(jlmodel(name))

    println(io)
    (adddoc ∈ (:all, :struct)) && jldoccode(io, props[:__doc__], 0)
    pop!(props, :__doc__)

    println(io, "@model mutable struct $klass <: $parent")
    for (i, j) ∈ props
        println(io)
        (adddoc ∈ (:all,)) && jldoccode(io, j.doc, 4)
        println(
            io,
            replace(
                string("    $i :: $(j.type)", isnothing(j.default) ? "" : " = $(something(j.default))"),
                "Bokeh.Models." => ""
            )
        )
    end
        
    println(io, "end")
    return klass
end

function jlcreatecode(io::IO; adddoc ::Symbol = :none)
    println(io, "#- file created by @__PATH__: do not edit! -#")
    println(io, "module Models")
    println(io, "using ..Bokeh")
    println(io, "using ..Model")
    println(io, "using ..AbstractTypes")
    cls      = jlabstracttypescode(io)

    deplist = Dict(i => jldependencies(jlmodel(i)) for i ∈ jlmodelnames())
    done    = Set{Type}()
    while !isempty(deplist)
        sz = length(deplist)
        for (name, deps) ∈ deplist
            isempty(setdiff!(deps, done)) || continue
            pop!(deplist, name)
            klass = jlstructcode(io, name, pop!(cls, name); adddoc)
            if klass ∈ names(Bokeh.Models; all = true)
                push!(done, getfield(Bokeh.Models, klass))
            end
        end
        (length(deplist) ≡ sz) && throw(ErrorException("Could not deal with $deplist"))
    end
    println(io, "end")
end

function jlcreatecode(; adddoc ::Symbol = :none)
    open(joinpath((@__DIR__), "..", "src", "models.jl"), "w") do io
        jlcreatecode(io; adddoc)
    end
end

(abspath(PROGRAM_FILE) == @__FILE__) && jlcreatecode()
