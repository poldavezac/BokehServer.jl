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
    println(io, "const iTemplate = String")
    for (name, opts) ∈ jlhierarchy()
        @assert length(opts) > 1
        for i ∈ (length(opts)-1):-1:1
            if opts[i] ∉ done
                println(io, "abstract type $(opts[i]) <: $(opts[i+1]) end")
                push!(done, opts[i])
            end
        end
        direct[name] = opts[1]
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

function jlstructcode(io::IO, name::String, parent, deps; adddoc :: Symbol = :none)
    props = jlproperties(jlmodel(name))

    println(io)
    (adddoc ∈ (:all, :struct)) && jldoccode(io, props[:__doc__], 0)

    klass = Symbol(string(occursin(".dom.", name) ? "Dom" : "", split(name, '.')[end]))
    println(io, "@model mutable struct $klass <: $parent")
    for (i, j) ∈ props
        (i ≡ :__doc__) && continue

        println(io)
        (adddoc ∈ (:all,)) && jldoccode(io, j.doc, 4)
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
                "Bokeh.Models." => "i"
            )
        )
    end
        
    println(io, "end")
end

function jlcreatecode(io::IO; adddoc ::Symbol = :none)
    println(io, "#- file created by @__PATH__: do not edit! -#")
    println(io, "module Models")
    println(io, "using Dates")
    println(io, "using ..Bokeh")
    println(io, "using ..Model")
    println(io, "using ..AbstractTypes")
    cls     = jlabstracttypescode(io)
    deplist = Dict(i => jldependencies(jlmodel(i)) for i ∈ jlmodelnames())
    for (name, deps) ∈ deplist
        jlstructcode(io, name, cls[name], deps; adddoc)
    end
    println(io, "end")
end

function jlcreatecode(; adddoc ::Symbol = :none)
    open(joinpath((@__DIR__), "..", "src", "models.jl"), "w") do io
        jlcreatecode(io; adddoc)
    end
end

(abspath(PROGRAM_FILE) == @__FILE__) && jlcreatecode()
