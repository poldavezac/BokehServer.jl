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

function _𝑒_onchange(func::Function, model, T::Type)
    cb = model.callbacks
    (func ∈ cb) && return func
    isempty(invokable(func, T)) && return missing
    push!(cb, func)
    return func
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

        Bokeh.Events.eventlist!() do
            push!(doc, Model1())
            delete!(doc, Model2())
        end
    end;

callback 1: any doc events
callback 2: only RootAddedEvent
callback 1: any doc events
"""
function onchange(func::Function, model::iDocument)
    wrap = _𝑒_onchange(func, model, iDocumentEvent)
    ismissing(wrap) && throw(KeyError("""
        No correct signature. It should be:
        * function (::iDocumentEvent)
    """))
end

"""
    onchange(func::Function, model::iModel)

Adds a callback to the model.

# Examples
```julia
julia > begin
        obj = Model()
        onchange(obj) do evt
            @assert evt isa Bokeh.Events.iModelEvent
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

        Bokeh.Events.eventlist!() do
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
    cb = model.callbacks
    (func ∈ cb) && return func
    if !isempty(invokable(func, iModel, Symbol, Any, Any))
        wrap = function (e::ModelChangedEvent) 
            if applicable(func, e.model, e.attr, e.old, e.new)
                func(e.model, e.attr, e.old, e.new)
            end
        end
        push!(cb, wrap)
        wrap
    else
        wrap = _𝑒_onchange(func, model, iModelEvent)
        ismissing(wrap) && throw(KeyError("""
            No correct signature. It should be:
            * function (::<:iModelEvent)
            * function (obj::iModel, attr::Symbol, old::Any, new::Any)
        """))
        wrap
    end
end

export onchange
