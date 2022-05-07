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

struct EventList <: iEventList
    events :: Vector{iEvent}
    EventList() = new(iEvent[])
end

function Base.in(evts::EventList, ε::iEvent)
    h = hash(ε)
    return any(h ≡ hash(i) for i ∈ evts.events)
end

for fcn ∈ (:isempty, :popfirst!)
    @eval Base.$fcn(evts::EventList) = $fcn(evts.events)
end

Base.push!(evts::EventList, ε::iEvent) = push!(evts.events, ε)

function Base.pop!(evts::EventList, ε::iEvent)
    h = hash(ε)
    for i ∈ eachindex(evts.events)
        if hash(evts.events[i]) ≡ h
            return popat!(evts.events, i)
        end
    end

    return nothing
end

export ModelChangedEvent, ModelChangedEvent, RootAddedEvent, RootRemovedEvent
