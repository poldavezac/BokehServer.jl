module Documents
using ..AbstractTypes
using ..Model
using ..Events
using ..Themes

@Base.kwdef mutable struct Document <: iDocument
    "private field for document id"
    id        :: String           = string(newid())

    "private field for storing roots"
    roots     :: Vector{iModel}   = iModel[]

    theme     :: Themes.Theme     = Themes.Theme(:current)

    title     :: String           = ""

    callbacks :: Vector{Function} = Function[]
end

function Base.propertynames(𝐷::Document, private :: Bool = false)
    private ? fieldnames(𝐷) : (:theme, :title)
end

function Base.setproperty!(𝐷::Document, σ::Symbol, value; dotrigger :: Bool = true)
    return if σ ≡ :roots
        empty!(𝐷)
        if value isa iModel
            push!(𝐷, value)
        else
            push!(𝐷, value...)
        end
    elseif σ ≡ :title
        setfield!(𝐷, :title, string(value))
        dotrigger && Events.trigger(TitleChangedEvent(𝐷, getfield(𝐷, :title)))
    elseif σ ≡ :theme
        Themes.changetheme!(𝐷, value)
    else
        @assert false "Writing to Document.$σ not yet implemented"
    end
end

function Base.getproperty(𝐷::Document, σ::Symbol; dotrigger :: Bool = true)
    # make sure roots are not changed through direct access
    return σ ≡ :roots ? tuple(getfield(𝐷, :roots)...) : getfield(𝐷, σ)
end

function Themes.changetheme!(𝐷::Document, theme::Themes.Theme)
    for mdl ∈ values(bokehmodels(𝐷))
        Themes.changetheme!(mdl, value)
        setfield(𝐷, :theme, value)
    end
end

for 𝐹 ∈ (:bokehmodels, :bokehids)
    @eval Model.$𝐹(𝐷::Document) = $𝐹(getfield(𝐷, :roots)...)
end

for 𝐹 ∈ (:last, :first, :isempty, :length, :lastindex, :firstindex, :eachindex)
    @eval Base.$𝐹(𝐷::Document) = $𝐹(getfield(𝐷, :roots))
end
Base.getindex(𝐷::Document, i::Integer) = getfield(𝐷, :roots)[i]
Base.eltype(::Type{Document}) = iModel
function Base.iterate(𝐷::Document, state :: Int64 = 1)
    return state > length(𝐷) ? nothing : (𝐷[state], state+1)
end

function Base.push!(𝐷::Document, roots::Vararg{iModel}; dotrigger :: Bool = true)
    if !isempty(roots)
        let common = bokehid.(roots) ∩ bokehid.(𝐷)
            isempty(common) || throw(BokehException("Roots already added: $common"))
        end
        size = length(𝐷)
        push!(getfield(𝐷, :roots), roots...)
        dotrigger && for (i, root) ∈ enumerate(roots)
            Events.trigger(RootAddedEvent(𝐷, root, i+size))
        end
    end
    return 𝐷
end

function Base.empty!(𝐷::Document; dotrigger :: Bool = true)
    roots = collect(getfield(𝐷, :roots))
    empty!(getfield(𝐷, :roots))
    dotrigger && for (i, root) ∈ enumerate(roots)
        Events.trigger(RootRemovedEvent(𝐷, root, i))
    end
end

function Base.delete!(𝐷::Document, roots::Vararg{iModel}; dotrigger :: Bool = true)
    if !isempty(roots)
        inds = indexin(bokehid.(roots), bokehid.(𝐷))

        deleteat!(getfield(𝐷, :roots), sort!(filter!(!isnothing, inds)))

        dotrigger && for (i, root) ∈ zip(inds, roots)
            isnothing(i) || Events.trigger(RootRemovedEvent(𝐷, root, i))
        end
    end
    return 𝐷
end

curdoc!(func::Function, 𝐷::iDocument) = task_local_storage(:BOKEH_DOC, 𝐷) do
    applicable(func) ? func() : func(𝐷)
end

@inline curdoc() :: Union{iDocument, Nothing} = get(task_local_storage(), :BOKEH_DOC, nothing)
@inline check_hasdoc() :: Bool = !isnothing(curdoc())

export Document, iDocument, curdoc, check_hasdoc, curdoc!
end

using .Documents
