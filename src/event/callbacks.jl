function invokable(func::Function, args...)
    return (
        method.sig.parameters
        for method ∈ methods(func)
        if let params = method.sig.parameters
            length(params) ≡ length(args)+1 && all(
                args[i] <: params[i+1] || params[i+1] <: args[i]
                for i ∈ eachindex(args)
            )
        end
    )
end

function getargtype(params, index::Int, types::Vararg{Type})
    types = (Any, types...)
    sel   = Set([p[index+1] for p ∈ params])

    return if any(i ∈ sel for i ∈ types)
        Any
    elseif length(sel) == 1
        first(sel)
    else
        Union{sel...}
    end
end

"""
    onchange(func::Function, model::iDocument)

Adds a callback to the document.

# Examples
```julia
julia > begin
        doc = Bokeh.Document

        onchange(doc) do evt
            @assert evt isa Bokeh.Events.iDocumentEvent
            println("callback 1: any doc events")
        end

        onchange(doc) do evt::Bokeh.RootAddedEvent
            @assert evt isa Bokeh.RootAddedEvent
            println("callback 2: only RootAddedEvent")
        end

        Bokeh.Events.eventlist() do
            push!(doc, Model1())
            delete!(doc, Model2())
        end
    end;

callback 1: any doc events
callback 2: only RootAddedEvent
callback 1: any doc events
"""
function onchange(func::Function, model::iDocument)
    cb = getfield(model, :callbacks)
    (func ∈ cb) && return nothing

    params = collect(invokable(func, iDocumentEvent))
    if isempty(params)
        throw(KeyError("""
            No correct signature. It should be:
            * function (::<:iDocumentEvent)
        """))
    end

    tpe = getargtype(params, 1, iEvent, iDocumentEvent)
    return if tpe ≡ Any
        push!(cb, func)
        func
    else
        wrap = (e::iDocumentEvent) -> (e isa tpe) && func(e)
        push!(cb, wrap)
        wrap
    end
end

"""
    onchange(func::Function, model::ModelChangedEvent)

Adds a callback to the model.

# Examples
```julia
julia > begin
        obj = Model()
        onchange(obj) do evt
            @assert evt isa Bokeh.ModelChangedEvent
            println("callback 1: receive events")
        end

        onchange(obj) do model, attr, old, new
            println("callback 2: just sugar")
        end

        onchange(obj) do model, attr, old, new::Float64
            # select a specific type for new
            # we could do the same for old
            @assert new isa Float64
            println("callback 3: a specific type for `new`")
        end

        Bokeh.Events.eventlist() do
            obj.a = 1
            obj.a = 10.
        end
    end;

callback 1: receive events
callback 2: just sugar
callback 1: receive events
callback 2: just sugar
callback 3: a specific type for `new`
"""
function onchange(func::Function, model::iModel)
    cb = getfield(model, :callbacks)
    return if func ∈ cb
        nothing
    elseif !isempty(invokable(func, ModelChangedEvent))
        push!(cb, func)
        func
    else
        params = collect(invokable(func, iModel, Symbol, Any, Any))

        isempty(params) && throw(KeyError("""
            No correct signature. It should be:
            * function (::ModelChangedEvent)
            * function (obj::iModel, attr::Symbol, old::Any, new::Any)
        """))

        oldtpe = getargtype(params, 3)
        newtpe = getargtype(params, 4)
        wrap = function (e::ModelChangedEvent) 
            if e.old isa oldtpe && e.new isa newtpe
                func(e.model, e.attr, e.old, e.new)
            end
        end
        push!(cb, wrap)
        wrap
    end
end

export onchange
