module Documents
using ..AbstractTypes
using ..Models
using ..Events
using ..Themes

const ID = bokehidmaker()

@Base.kwdef mutable struct Document <: iDocument
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

function Base.setproperty!(doc::Document, attr::Symbol, value; dotrigger :: Bool = true)
    return if attr ≡ :roots
        empty!(doc)
        if value isa iModel
            push!(doc, value)
        else
            push!(doc, value...)
        end
    elseif attr ≡ :title
        setfield!(doc, :title, string(value))
        dotrigger && Events.trigger(TitleChangedEvent(doc, getfield(doc, :title)))
    elseif attr ≡ :theme
        Themes.changetheme!(doc, value)
    else
        @assert false "Writing to Document.$attr not yet implemented"
    end
end

function Themes.changetheme!(doc::Document, theme::Themes.Theme)
    for mdl ∈ allmodels(doc)
        Themes.changetheme!(mdl, value)
        setfield(doc, :theme, value)
    end
end

Models.allmodels(doc::Document) = allmodels(doc.roots...)

Base.length(doc::Document) = length(doc.roots)
Base.eltype(::Type{Document}) = iModel
function Base.iterate(doc::Document, state :: Int64 = 1)
    return state > length(doc.roots) ? nothing : (doc.roots[state], state+1)
end

function Base.push!(doc::Document, roots::Vararg{iModel}; dotrigger :: Bool = true)
    if !isempty(roots)
        let common = bokehid.(roots) ∩ bokehid.(doc)
            isempty(common) || throw(ErrorException("Roots already added: $common"))
        end
        size = length(doc.roots)
        push!(doc.roots, roots...)
        dotrigger && for (i, root) ∈ enumerate(roots)
            Events.trigger(RootAddedEvent(doc, root, i+size))
        end
    end
    return doc
end

function Base.empty!(doc::Document; dotrigger :: Bool = true)
    roots = collect(getfield(doc, :roots))
    empty!(getfield(doc, :roots))
    dotrigger && for (i, root) ∈ enumerate(roots)
        Events.trigger(RootRemovedEvent(doc, root, i))
    end
end

function Base.delete!(doc::Document, roots::Vararg{iModel}; dotrigger :: Bool = true)
    if !isempty(roots)
        inds = indexin(bokehid.(roots), bokehid.(doc))

        deleteat!(doc.roots, sort!(filter!(!isnothing, inds)))

        dotrigger && for (i, root) ∈ zip(inds, roots)
            isnothing(i) || Events.trigger(RootRemovedEvent(doc, root, i))
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
