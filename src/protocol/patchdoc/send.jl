function patchdoc(λ::Events.EventList, doc::iDocument, oldids::Set{Int64})
    all = allmodels(doc)
    filt(k::Events.ModelChangedEvent) = haskey(all, bokehid(k.model))
    filt(k::Events.iDocumentEvent)    = k.doc ≡ doc

    return (;
        events     = serialize([i for i ∈ λ.events if filt(i)]),
        references = serialize([j for (i, j) ∈ all if i ∉ oldids])
    )
end