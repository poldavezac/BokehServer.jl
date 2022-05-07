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
            Bokeh.Events.flushevents!(Bokeh.Events.task_eventlist())
        end
    end;

callback 1: any doc events
callback 2: only RootAddedEvent
callback 1: any doc events
"""
function onchange(func::Function, model::iDocument)
    cb = getfield(model, :callbacks)
    (func ∈ cb) && return nothing

    params = Set([method[2] for method ∈ invokable(func, iDocumentEvent)])
    if isempty(params)
        throw(KeyError("""
            No correct signature. It should be:
            * function (::<:iDocumentEvent)
        """))
    end
    return if any(i ∈ params for i ∈ (Any, iEvent, iDocumentEvent))
        push!(cb, func)
        func
    else
        uni  = length(params) == 1 ? first(params) : Union{params...}
        wrap = (e::iDocumentEvent) -> (e isa uni) && func(e)
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

        Bokeh.Events.eventlist() do
            obj.a = 1
            Bokeh.Events.flushevents!(Bokeh.Events.task_eventlist())
        end
    end;

callback 1: receive events
callback 2: just sugar
"""
function onchange(func::Function, model::iModel)
    cb = getfield(model, :callbacks)
    return if func ∈ cb
        nothing
    elseif !isempty(invokable(func, ModelChangedEvent))
        push!(cb, func)
        func
    elseif !isempty(invokable(func, iModel, Symbol, Any, Any))
        wrap = (e::ModelChangedEvent) -> func(e.model, e.attr, e.old, e.new)
        push!(cb, wrap)
        wrap
    else
        throw(KeyError("""
            No correct signature. It should be:
            * function (::ModelChangedEvent)
            * function (obj::iModel, attr::Symbol, old::Any, new::Any)
        """))
    end
end

export onchange
