module Documents
using ..Bokeh: iDocument
using ..Models
using ..Events

struct Document
    "private field for document id"
    index :: Int64

    "private field for storing roots"
    roots :: Vector{iModel}

    Document() = Document(newmodelid(), iModel)
end

bokehid(doc::Document) = doc.id
Base.propertynames(doc::Document, private :: Bool = false) = private ? fieldnames(doc) : ()
Models.allmodels(doc::Document) = allmodels(doc.roots)

function Base.push!(doc::Document, root::iModel, roots::Vararg{iModel}; dotrigger :: Bool = true)
    roots = (root, roots...)
    push!(doc.roots, roots...)
    dotrigger && Events.trigger((Events.RootAddedKey(doc, root) for root ∈ roots)...)
    return doc
end

function Base.delete!(doc::Document, root::iModel, roots::Vararg{iModel}; dotrigger :: Bool = true)
    roots   = (root, roots...)

    let rootids = [bokehid(i) for i ∈ roots]
        filter!(doc.roots) do root
            bokehid(root) ∉ rootids
        end
    end

    dotrigger && Events.trigger((Events.RootRemovedKey(doc, root) for root ∈ roots)...)
    return doc
end

function updatedocs!(func::Function, doc::iDocument, docs::Vararg{iDocument})
    docs = (doc, docs...)
    Events.events!() do events :: Events.EventList
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

function flush!(events::EventList, doc::iDocument, docs::Vararg{iDocument})
    docs   = (doc, docs...)
    cbacks = Events.trigger!(events)
    jsons  = [
        Events.json(doc, cbacks, ids)
        for (doc, ids) ∈ zip(docs, roots)
    ]
    toclient(zip(docs, jsons))
end

curdoc!(func::Function, doc::iDocument) = task_local_storage(func, :BOKEH_DOC, doc)
@inline curdoc() :: Union{iDocument, Nothing} = get(task_local_storage(), :BOKEH_DOC, nothing)
@inline check_hasdoc() :: Bool = !isnothing(curdoc())
flushcurdoc!() = flush!(Events.task_eventlist(), curdoc())

Base.propertynames(::Document; private :: Bool = false) =  private ? fieldnames(Document) : ()

export Document, iDocument, curdoc, check_hasdoc, flushcurdoc!
end

using .Documents
