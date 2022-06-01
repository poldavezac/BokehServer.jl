abstract type iEventList end
abstract type iEvent end
abstract type iDocumentEvent <: iEvent end
abstract type iDocumentRootEvent <: iDocumentEvent end
abstract type iModelEvent <: iEvent end
abstract type iDataSourceEvent <: iModelEvent end

macro _𝑚_event(code)
    quote
        struct $(code.args[2])
            model :: iModel
            attr  :: Symbol
            $(code.args[3].args...)
        end
    end
end

@_𝑚_event struct ModelChangedEvent <: iModelEvent
    old :: Any
    new :: Any
end

@_𝑚_event struct ColumnDataChangedEvent <: iDataSourceEvent
    data :: DataDict
end

@_𝑚_event struct ColumnsStreamedEvent <: iDataSourceEvent
    data     :: DataDict
    rollover :: Union{Nothing, Int}
end

@_𝑚_event struct ColumnsPatchedEvent <: iDataSourceEvent
    patches :: Dict{String, Vector{Pair}}
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
