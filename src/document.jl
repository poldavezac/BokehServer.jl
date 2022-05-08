module Documents
using ..AbstractTypes
using ..Models
using ..Events
using ..Themes

const ID = BokehIdMaker()

@Base.kwdef struct Document <: iDocument
    "private field for document id"
    id        :: String           = string(ID())

    "private field for storing roots"
    roots     :: Vector{iModel}   = iModel[]

    theme     :: Themes.Theme     = Themes.Theme()

    title     :: String           = ""

    callbacks :: Vector{Function} = Function[]
end

function Base.propertynames(doc::Document, private :: Bool = false)
    private ? fieldnames(doc) : (:theme, :title)
end

Models.allmodels(doc::Document) = allmodels(doc.roots...)

function Base.push!(doc::Document, roots::Vararg{iModel}; dotrigger :: Bool = true)
    if !isempty(roots)
        push!(doc.roots, roots...)
        dotrigger && for root ∈ roots
            Events.trigger(RootAddedEvent(doc, root))
        end
    end
    return doc
end

function Base.delete!(doc::Document, roots::Vararg{iModel}; dotrigger :: Bool = true)
    if !isempty(roots)
        let rootids = Set([bokehid(i) for i ∈ roots])
            filter!(doc.roots) do root
                bokehid(root) ∉ rootids
            end
        end

        dotrigger && for root ∈ roots
            Events.trigger(RootRemovedEvent(doc, root))
        end
    end
    return doc
end

function updatedocs!(func::Function, doc::iDocument, docs::Vararg{iDocument})
    docs = (doc, docs...)
    @assert !Events.task_hasevents()
    Events.eventlist() do events :: Events.EventList
        updatedoc!(func, events, doc...)
    end
end

function updatedocs!(func::Function, events::Events.EventList, doc::iDocument, docs::Vararg{iDocument})
    docs = (doc, docs...)
    try
        roots  = [doc => Set{Int64}(keys(allmodels(doc)))  for doc ∈ docs]
        func()
    finally
        flushdoc!(events, roots...)
    end
end

function flushdoc!(events::Events.EventList, docs::Vararg{Pair{<:iDocument, Set{Int64}}})
    Events.flushevents!(events)
    toclient((doc => Events.json(events, doc, oldids) for (doc, oldids) ∈ docs))
end

curdoc!(func::Function, doc::iDocument) = task_local_storage(func, :BOKEH_DOC, doc)
@inline curdoc() :: Union{iDocument, Nothing} = get(task_local_storage(), :BOKEH_DOC, nothing)
@inline check_hasdoc() :: Bool = !isnothing(curdoc())
flushcurdoc!() = flushdoc!(Events.task_eventlist(), curdoc())
iterroots(doc::iDocument) = doc.roots

export Document, iDocument, curdoc, check_hasdoc, flushcurdoc!, curdoc!, iterroots
end

using .Documents

function removecallback!(doc::iDocument, func::Function)
    filter!(getfield(doc, :callbacks)) do opt
        func ≢ opt
    end
end

function addcallback!(doc::iDocument, func::Function)
    cb = getfield(model, :callbacks)
    if (func ∈ cb)
       return nothing
    elseif any(length(m.sig.parameters) ≥ 4 for m ∈ methods(func))
        push!(cb, func)
    else
        sig = "$(nameof(func))(::<:iDocument, ::<:Symbol, ::<:iModel)"
        throw(KeyError("No correct signature: should be $sig"))
    end
    return func
end
