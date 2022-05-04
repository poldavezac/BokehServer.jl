abstract type iEventList end
abstract type iEvent end
abstract type iEventKey end
abstract type iRootEventKey <: iEventKey end

struct ModelChangedKey <: iEventKey
    model :: iModel
    attr  :: Symbol
end

struct ModelChangedEvent <: iEvent
    old :: Any
    new :: Any
end

Base.hash(key::ModelChangedKey) = hash((bokehid(key.model), key.attr))

for (ind, cls) ∈ enumerate((:RootAddedKey, :RootRemovedKey))
    @eval begin
        struct $cls <: iRootEventKey
            doc  :: iDocument
            root :: iModel
        end

        Base.hash(key::$cls) = hash(($ind, bokehid(key.doc), bokehid(key.model)))
    end
end

const EventDict = OrderedDict{iEventKey, Union{iEvent, Nothing}}

struct EventList <: iEventList
    events :: EventDict
    EventList() = new(EventDict())
end
