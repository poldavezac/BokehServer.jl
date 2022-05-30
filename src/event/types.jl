abstract type iEventList end
abstract type iEvent end
abstract type iDocumentEvent <: iEvent end
abstract type iDocumentRootEvent <: iDocumentEvent end
abstract type iModelEvent <: iEvent end
abstract type iColumnDataEvent <: iModelEvent end

for (cls, fields) ∈ (
        :ModelChangedEvent      => (:(old::Any), :(new::Any)),
        :ColumnDataChangedEvent => (:(data::Dict{String, AbstractVector}),),
        :ColumnsStreamedEvent   => (:(data::Dict{String, AbstractVector}), :(rollover::Union{Nothing, Int})),
        :ColumnsPatchedEvent    => (:(patches::Vector{<:Pair{<:AbstractString, <:Pair}}),)
)
    @eval struct $cls <: iModelEvent
        model :: iModel
        attr  :: Symbol
        $(fields...)
    end
end

for cls ∈ (:RootAddedEvent, :RootRemovedEvent)
    @eval struct $cls <: iDocumentRootEvent
        doc   :: iDocument
        root  :: iModel
        index :: Int64
    end
end

struct TitleChangedEvent <: iDocumentEvent
    doc   :: iDocument
    title :: String
end

Base.hash(key::T) where {T<:iModelEvent}        = hash((T, bokehid(key.model), key.attr))
Base.hash(key::T) where {T<:iDocumentRootEvent} = hash((T, bokehid(key.doc), bokehid(key.root), key.root))
Base.hash(key::T) where {T<:iDocumentEvent}     = hash((T, bokehid(key.doc)))

export ModelChangedEvent, RootAddedEvent, RootRemovedEvent, TitleChangedEvent
export ColumnsPatchedEvent, ColumnsStreamedEvent, ColumnDataChangedEvent
