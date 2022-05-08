abstract type iEventList end
abstract type iEvent end
abstract type iDocumentEvent <: iEvent end

struct ModelChangedEvent <: iEvent
    model :: iModel
    attr  :: Symbol
    old   :: Any
    new   :: Any
end

Base.hash(key::ModelChangedEvent) = hash((bokehid(key.model), key.attr))

for (ind, cls) ∈ enumerate((:RootAddedEvent, :RootRemovedEvent))
    @eval begin
        struct $cls <: iDocumentEvent
            doc  :: iDocument
            root :: iModel
        end

        Base.hash(key::$cls) = hash(($ind, bokehid(key.doc), bokehid(key.root)))
    end
end

export ModelChangedEvent, ModelChangedEvent, RootAddedEvent, RootRemovedEvent
