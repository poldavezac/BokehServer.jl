module Documents
using ..AbstractTypes
using ..Models
using ..Events
using ..Themes

const _MODELIDS = collect(1:Threads.nthreads())

newbokehid() = (_MODELIDS[Threads.threadid()] += 1000)

struct Document <: iDocument
    "private field for document id"
    id    :: Int64

    "private field for storing roots"
    roots :: Vector{iModel}

    theme :: Themes.Theme

    callbacks :: Vector{Function}

    Document() = new(newbokehid(), iModel[], Themes.Theme(), Function[])
end

Base.propertynames(doc::Document, private :: Bool = false) = private ? fieldnames(doc) : ()
Models.allmodels(doc::Document) = allmodels(doc.roots...)

function Base.push!(doc::Document, roots::Vararg{iModel}; dotrigger :: Bool = true)
    if !isempty(roots)
        push!(doc.roots, roots...)
        dotrigger && Events.trigger(Events.RootAddedKey, doc, roots...)
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

        dotrigger && Events.trigger(Events.RootRemovedKey, doc, roots...)
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
        roots  = [Set{Int64}(keys(allmodels(doc)))  for doc ∈ docs]
        func()
    finally
        flush!(events, docs...)
    end
end

function flushdoc!(events::Events.EventList, doc::iDocument, docs::Vararg{iDocument})
    docs   = (doc, docs...)
    cbacks = Events.flushevents!(events)
    jsons  = [
        Events.json(doc, cbacks, ids)
        for (doc, ids) ∈ zip(docs, roots)
    ]
    toclient(zip(docs, jsons))
end

curdoc!(func::Function, doc::iDocument) = task_local_storage(func, :BOKEH_DOC, doc)
@inline curdoc() :: Union{iDocument, Nothing} = get(task_local_storage(), :BOKEH_DOC, nothing)
@inline check_hasdoc() :: Bool = !isnothing(curdoc())
flushcurdoc!() = flushdoc!(Events.task_eventlist(), curdoc())

export Document, iDocument, curdoc, check_hasdoc, flushcurdoc!, curdoc!
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
