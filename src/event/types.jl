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
            doc   :: iDocument
            root  :: iModel
            index :: Int64
        end

        Base.hash(key::$cls) = hash(($ind, bokehid(key.doc), bokehid(key.root), key.root))
    end
end

struct TitleChangedEvent <: iDocumentEvent
    doc   :: iDocument
    title :: String
end

Base.hash(key::TitleChangedEvent) = hash(bokehid(key.doc))

export ModelChangedEvent, ModelChangedEvent, RootAddedEvent, RootRemovedEvent, TitleChangedEvent
