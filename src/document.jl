module Documents
using ..Models
using ..Events

abstract type iDocument end

struct Document
    roots     :: Vector{iModel}
end

Models.allmodels(doc::Document) = allmodels(doc.roots)

function updatedoc!(func::Function, doc::Document)
    Events.events!() do events :: Events.EventList
        updatedoc!(func, events, doc)
    end
end

struct DocIds
    roots :: Vector{Int64}
    models:: Set{Int64}

    DocIds(doc::Document) = new(
        modelid.(doc.roots), Set{Int64}(keys(allmodels))
    )
end

function updatedoc!(func::Function, events::Events.EventList, docs::Vararg{iDocument})
    size(docs) > 1 || return
    try
        roots  = [doc => DocIds(doc)  for doc ∈ docs]
        func()
    finally
        cbacks = Events.trigger!(events)
        for (doc, ids) ∈ docs
            toclient(doc, cbacks, ids)
        end
    end
end

function toclient!(doc::Document, events::Events.EventDict, oldids::DocIds)
    all    = allmodels(doc)
    events = let discarded = setdiff(oldids.models, keys(all))
        filter(events) do (key, _)
            # keep only models which actually are in the doc
            key[1] ∉ discarded
        end
    end

    new    = setdiff(keys(all), oldids.models)
end

curdoc!(func::Function, doc::iDocument) = task_local_storage(func, :BOKEH_DOC, doc)
@inline curdoc() :: Union{iDocument, Nothing} = get(task_local_storage(), :BOKEH_DOC, nothing)
@inline check_hasdoc() :: Bool = !isnothing(curdoc())

Base.propertynames(::Document; private :: Bool = false) =  private ? fieldnames(Document) : ()

export Document, iDocument, curdoc, check_hasdoc
end

using .Documents
