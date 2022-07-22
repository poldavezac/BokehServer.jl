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

function _𝑒_onchange(func::Function, model)
    hascallback(model, func) && return func
    T = tuple((
        i
        for i ∈ eventtypes(model)
        if !isempty(invokable(func, i))
    )...)
    return isempty(T) ? missing : pushcallback!(model, func, T)
end

"""
    onchange(func::Function, model::iDocument)

Adds a *Julia* callback to a document-level event.

The function must have a single positional argument. Specifying an event type
allows triggering the callback on that specific event type only.

# Examples
```julia
doc = BokehServer.Document

# Add a callback for every type of event.
onchange(doc) do evt
    @assert evt isa BokehServer.Events.iDocEvent
    println("callback 1: any doc events")
end

# Add a callback for `RootAddedEvent` only
onchange(doc) do evt::BokehServer.RootAddedEvent
    @assert evt isa BokehServer.RootAddedEvent
    println("callback 2: only RootAddedEvent")
end

# now trigger the events
BokehServer.Events.eventlist!() do
    push!(doc, Model1())
    delete!(doc, Model2())
end
```

will outputs

```raw
callback 1: any doc events
callback 2: only RootAddedEvent
callback 1: any doc events
```
"""
function onchange(func::Function, model::iDocument)
    wrap = _𝑒_onchange(func, model)
    ismissing(wrap) && throw(KeyError("""
        No correct signature. It should be:
        * function (::Union{$(eventtypes(model))})
    """))
end

"""
    onchange(func::Function, model::iModel)

Adds a *Julia* callback to a model-level event.

The function can have two different signatures:

1. `callback(evt [::X])` where specifying `X` allows triggering on a specific event type.
2. `callback(model [::iModel], attribute [::Symbol], old [::A], new [::B])` where
specifying `A` or `B` allows triggering on a specific field type.

** Warning ** Using an incorrect type in the signature can result in callback
being silently ignored.

# Examples
```julia
obj = Model()

# Add a callback triggered by every type of event
onchange(obj) do evt
    @assert evt isa BokehServer.Events.iDocModelEvent
    println("callback 1: receive events")
end

# Add a callback triggered by `BokehServer.ModelChangedEvent` only.
onchange(obj) do model, attr, old, new
    println("callback 2: just sugar")
end

# Add a callback triggered by `BokehServer.ModelChangedEvent` only, where a
# `Float64` is the new value.
onchange(obj) do model, attr, old, new::Float64
    @assert new isa Float64
    println("callback 3: a specific type for `new`")
end

# now trigger the events
BokehServer.Events.eventlist!() do
    obj.a = 1
    obj.a = 10.
end
```

will outputs

```raw
callback 1: receive events
callback 2: just sugar
callback 1: receive events
callback 2: just sugar
callback 3: a specific type for `new`
```
"""
function onchange(func::Function, model::iModel)
    hascallback(model, func) && return func
    if !isempty(invokable(func, iModel, Symbol, Any, Any))
        wrap = function (e::ModelChangedEvent) 
            if applicable(func, e.model, e.attr, e.old, e.new)
                func(e.model, e.attr, e.old, e.new)
            end
        end
        pushcallback!(model, wrap, (ModelChangedEvent,))
    else
        wrap = _𝑒_onchange(func, model)
        ismissing(wrap) && throw(KeyError("""
            No correct signature. It should be:
            * function (::Union{$(eventtypes(model))})
            * function (obj::iModel, attr::Symbol, old::Any, new::Any)
        """))
        wrap
    end
end

hascallback(model, func::Function) = func ∈ model.callbacks

function pushcallback!(model, func::Function, _)
    push!(model.callbacks, func)
    return func
end

# see implementation in "src/actions.jl"
function eventtypes end

export onchange
