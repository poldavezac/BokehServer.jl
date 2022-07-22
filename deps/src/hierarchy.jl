module Hierarchies
using ..BokehServer
using PythonCall

model(name)  = pyimport("bokeh.models" => "Model").model_class_reverse_map["$name"]
modelnames() = (pyconvert(String, i) for i ∈ pyimport("bokeh.models" => "Model").model_class_reverse_map.keys())

function hierarchy(mdl::Py)
    todos = Pair{Py, Vector{Symbol}}[mdl => Symbol[pyconvert(Symbol, mdl.__name__)]]
    if endswith(pyconvert(String, mdl.__module__), "dom") && !startswith("$(last(todos[1])[1])", "DOM")
        last(todos[1])[1] = Symbol("iDOM$(last(todos[1])[1])")
    else
        last(todos[1])[1] = Symbol("i$(last(todos[1])[1])")
    end
    done  = Set{Tuple}()
    while !isempty(todos)
        (child, names) = pop!(todos)
        for cls ∈ child.__bases__
            name = pyconvert(Symbol, cls.__name__)
            if name ≡ :object
                continue
            elseif name ≡ :Model
                push!(done, tuple(names..., :iModel))
            else
                push!(todos, cls => [names..., Symbol("i$name")])
            end
        end
    end
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
            @assert !haskey(opts, cls[i-1]) || (opts[cls[i-1]] ≡ cls[i]) "$(cls[i-1]) => $(opts[cls[i-1]]) ≢ $(cls[i])"
            opts[cls[i-1]] = cls[i]
        end
        push!(out, name => cls)
    end
    return out
end

export hierarchy
end
using .Hierarchies
