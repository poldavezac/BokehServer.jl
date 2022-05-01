module Documents
using ..Bokeh: iDocument
using ..Models
using ..Events

@Base.kwdef struct Document
    index :: Int64          = newmodelid()
    roots :: Vector{iModel} = iModel[]
end

Models.allmodels(doc::Document) = allmodels(doc.roots)

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

flush!() = flush!(Events.task_eventlist(), curdoc())

curdoc!(func::Function, doc::iDocument) = task_local_storage(func, :BOKEH_DOC, doc)
@inline curdoc() :: Union{iDocument, Nothing} = get(task_local_storage(), :BOKEH_DOC, nothing)
@inline check_hasdoc() :: Bool = !isnothing(curdoc())

Base.propertynames(::Document; private :: Bool = false) =  private ? fieldnames(Document) : ()

export Document, iDocument, curdoc, check_hasdoc
end

using .Documents
