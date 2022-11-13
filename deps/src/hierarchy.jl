module Hierarchies
using PythonCall
using ..BokehServer
using ..CodeCreator: modelnames, model

function hierarchyoptions(mdl::Py)
    clsname(cls) = let val = pyconvert(Symbol, cls.__name__)
        if val ≡ :Action && occursin("models.ui.", pyconvert(String, cls.__module__))
            :UIAction
        else
            val
        end
    end
    todos = Pair{Py, Vector{Symbol}}[mdl => Symbol[clsname(mdl)]]
    if endswith(pyconvert(String, mdl.__module__), "dom") && !startswith("$(last(todos[1])[1])", "DOM")
        last(todos[1])[1] = Symbol("iDOM$(last(todos[1])[1])")
    else
        last(todos[1])[1] = Symbol("i$(last(todos[1])[1])")
    end
    done  = Set{Tuple}()
    while !isempty(todos)
        (child, names) = pop!(todos)
        for cls ∈ child.__bases__
            name = clsname(cls)
            if name ≡ :object
                continue
            elseif name ≡ :Model
                push!(done, tuple(names..., :iModel))
            else
                push!(todos, cls => [names..., Symbol("i$name")])
            end
        end
    end
    done
end

function hierarchy(mdl::Py)
    done = hierarchyoptions(mdl)
    @assert !isempty(done)
    (length(done) ≡ 1) && return first(done)

    opts   = collect(done)
    firsts = Symbol[]
    for i ∈ 1:minimum(length.(opts))
        all(opts[1][i] ≡ opts[j][i] for j ∈ 2:length(opts)) || break
        push!(firsts, opts[1][i])
    end

    lasts = Symbol[]
    for i ∈ 0:minimum(length.(opts))-1
        all(opts[1][end-i] ≡ opts[j][end-i] for j ∈ 2:length(opts)) || break
        insert!(lasts, 1, opts[1][end-i])
    end

    return tuple(firsts..., lasts...)
end

function hierarchy()
    opts = Dict{Symbol, Symbol}()
    out = Dict{String, Tuple}()
    for name ∈ modelnames()
        cls = hierarchy(model(name))
        for i ∈ 2:length(cls)
            @assert !haskey(opts, cls[i-1]) || (opts[cls[i-1]] ≡ cls[i]) "$name: $(cls[i-1]) => $(opts[cls[i-1]]) ≢ $(cls[i])"
            opts[cls[i-1]] = cls[i]
        end
        push!(out, name => cls)
    end
    return out
end

function unions()
    allnames = Set{Symbol}()
    for (_, i) ∈ hierarchy()
        union!(allnames, i)
    end

    out = Dict{Symbol, Set{String}}()
    for name ∈ modelnames()
        opts = Set{Symbol}()
        for i ∈ hierarchyoptions(model(name))
            union!(opts, setdiff(Set{Symbol}(i), allnames))
        end
        for i ∈ opts
            push!(get!(Set{Symbol}, out, i), name)
        end
    end
    return Dict(i for i ∈ out if length(i[2]) > 1)
end

export hierarchy, unions
end
using .Hierarchies
