function _flushevents!(::RootRemovedKey, ::Nothing)
    for cb ∈ key.doc.callbacks
        cb(key.doc, :RootRemoved, key.model)
    end
end

function _flushevents!(::RootAddedKey, ::Nothing)
    for cb ∈ key.doc.callbacks
        cb(key.doc, :RootAdded, key.model)
    end
end

function _flushevents!(key::ModelChangedKey, val::ModelChangedEvent)
    for cb ∈ getfield(getfield(key.model, :callbacks), key.attr)
        cb(key.model, key.attr, val.old, val.new)
    end
end

function flushevents!(λ::EventList)
    while !isempty(λ.events)
        _flushevents!(popfirst!(λ.events)...)
    end
end
