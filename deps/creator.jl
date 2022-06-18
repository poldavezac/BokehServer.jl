push!(LOAD_PATH, joinpath((@__DIR__), ".."))
using Bokeh
using PythonCall

include("defaults.jl")
include("properties.jl")
include("hierarchy.jl")
include("dependencies.jl")

function jlcreatecode(io::IO)
    println(io, "#- file created by @__PATH__: do not edit! -#")
    cls = let direct = Dict{String, Symbol}()
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
        direct
    end

    deplist  = Dict(i => jldependencies(jlmodel(i)) for i ∈ jlmodelnames())
    proplist = jlproperties()
    done     = Set{Type}()
    while !isempty(proplist)
        sz = length(proplist)
        for (name, deps) ∈ deplist
            isempty(setdiff!(deps, done)) || continue
            pop!(deplist, name)
            props = pop!(proplist, name)

            klass = Symbol(occursin(".dom.", name) ? "Dom$(split(name, '.')[end])" : name)
            if klass ∈ names(Bokeh.Models; all = true)
                push!(done, getfield(Bokeh.Models, klass))
            end

            println(io)
            if !isnothing(props[:__doc__])
                println(io, "\"\"\"")
                for line ∈ split(strip(props[:__doc__]), '\n')
                    println(io, strip(line))
                end
                println(io, "\"\"\"")
            end
            pop!(props, :__doc__)

            println(io, "@model struct $klass <: $(pop!(cls, name))")
            for (i, j) ∈ props
                println(io)
                if !isnothing(j.doc)
                    println(io, "    \"\"\"")
                    for line ∈ split(strip(j.doc), '\n')
                        println(io, "    ", strip(line))
                    end
                    println(io, "    \"\"\"")
                end
                if isnothing(j.default)
                    println(io, "    $i :: $(j.type)")
                else
                    println(io, "    $i :: $(j.type) = $(something(j.default))")
                end
            end
            println(io, "end")
        end
        (length(proplist) ≡ sz) && throw(ErrorException("Could not deal with $deplist"))
    end
end
