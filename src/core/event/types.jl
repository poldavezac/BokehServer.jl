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
        @Base.__doc__ struct $(code.args[2])
            model :: iModel
            attr  :: Symbol
            $(code.args[3].args...)
        end
    end
end


"""
Event triggered by a mutated field in an `iHasProps` instance.

Fields:

* `model::iModel`: the mutated instance
* `attr::Symbol`: the mutated field name
* `old::Any`: the previous field value
* `new::Any`: the currnet field value

Supertypes: ModelChangedEvent <: iDocModelEvent <: iEvent
"""
@_𝑚_event struct ModelChangedEvent <: iDocModelEvent
    old :: Any
    new :: Any
end

"""
Event triggered by a calling `BokehServer.update!` on a `BokehServer.Models.ColumnDataSource`,
i.e, by adding *columns* to the `ColumnDataSource`.

Fields:

* `model::iModel`: the mutated instance
* `attr::Symbol`: the mutated field name (always `:data`)
* `data::DataDict`: columns added to the `ColumnDataSource`

Supertypes: ColumnDataChangedEvent <: iDataSourceEvent <: iDocModelEvent <: iEvent
"""
@_𝑚_event struct ColumnDataChangedEvent <: iDataSourceEvent
    data :: DataDict
end

"""
Event triggered by a calling `BokehServer.stream!` on a `BokehServer.Models.ColumnDataSource`,
i.e, by adding *rows* to the `ColumnDataSource`.

Fields:

* `model::iModel`: the mutated instance
* `attr::Symbol`: the mutated field name (always `:data`)
* `data::DataDict`: columns added to the `ColumnDataSource`
* `rollover::Union{Nothing, Int}`: the rollover which was applied

Supertypes: ColumnsStreamedEvent <: iDataSourceEvent <: iDocModelEvent <: iEvent
"""
@_𝑚_event struct ColumnsStreamedEvent <: iDataSourceEvent
    data     :: DataDict
    rollover :: Union{Nothing, Int}
end

"""
Event triggered by a calling `BokehServer.patch!` on a `BokehServer.Models.ColumnDataSource`,
i.e, by mutating parts of the data in a the `ColumnDataSource`.

Fields:

* `model::iModel`: the mutated instance
* `attr::Symbol`: the mutated field name (always `:data`)
* `patches::Dict{String, Vector{Pair}}`: the patches applied

Supertypes: ColumnsPatchedEvent <: iDataSourceEvent <: iDocModelEvent <: iEvent
"""
@_𝑚_event struct ColumnsPatchedEvent <: iDataSourceEvent
    patches :: Dict{String, Vector{Pair}}
end

for (cls, action) ∈ (:RootAddedEvent => "added", :RootRemovedEvent => "removed")
    @eval struct $cls <: iDocRootEvent
        doc   :: iDocument
        root  :: iModel
        index :: Int64
    end

    eval(:(@doc($("""
    Event triggered on a `BokehServer.Document` when a root is $action to it.

    Fields:

    * `doc::iDocument`: the mutated document
    * `root::iModel`: the root $action to the document
    * `index::Int`: the root index in the list of roots.

    Supertypes: $cls <: iDocRootEvent <: iDocEvent <: iEvent
    """), $cls)))
end

"""
Event triggered on a `BokehServer.Document` when the HTML document title is changed.

Fields:

* `doc::iDocument`: the mutated document
* `title::String`: the new title

Supertypes: TitleChangedEvent <: iDocEvent <: iEvent
"""
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
