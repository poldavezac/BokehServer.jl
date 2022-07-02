abstract type iEventList                            end
abstract type iEvent                                end
abstract type iActionEvent      <: iEvent           end
abstract type iDocActionEvent   <: iActionEvent     end
abstract type iModelActionEvent <: iActionEvent     end
abstract type iDocEvent         <: iEvent           end
abstract type iDocRootEvent     <: iDocEvent        end
abstract type iDocModelEvent    <: iEvent           end
abstract type iDataSourceEvent  <: iDocModelEvent   end

macro _𝑚_event(code)
    quote
        struct $(code.args[2])
            model :: iModel
            attr  :: Symbol
            $(code.args[3].args...)
        end
    end
end

@_𝑚_event struct ModelChangedEvent <: iDocModelEvent
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
    @eval struct $cls <: iDocRootEvent
        doc   :: iDocument
        root  :: iModel
        index :: Int64
    end
end

struct TitleChangedEvent <: iDocEvent
    doc   :: iDocument
    title :: String
end

Base.hash(key::T) where {T<:iModelActionEvent} = hash((T, bokehid(key.model), key.event_name))
Base.hash(key::T) where {T<:iDocModelEvent}    = hash((T, bokehid(key.model), key.attr))
Base.hash(key::T) where {T<:iDocRootEvent}     = hash((T, bokehid(key.doc), bokehid(key.root), key.root))
Base.hash(key::T) where {T<:iDocEvent}         = hash((T, bokehid(key.doc)))
Base.hash(key::T) where {T<:iDocActionEvent}   = hash((T, bokehid(key.doc)))

export ModelChangedEvent, RootAddedEvent, RootRemovedEvent, TitleChangedEvent
export ColumnsPatchedEvent, ColumnsStreamedEvent, ColumnDataChangedEvent
