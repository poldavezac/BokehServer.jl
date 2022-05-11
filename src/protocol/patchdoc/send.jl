function patchdoc!(λ::Events.EventList, doc::Events.iDocument, oldids::Set{Int64})
    all = allmodels(doc)
    filt(k::Events.ModelChangedEvent) = bokehid(k.model) ∈ keys(all)
    filt(k::Events.iDocumentEvent)    = k.doc ≡ doc

    ToJSON.sprintjson((;
        events     = [i for i ∈ λ.events if filt(i)],
        references = [ToJSON.jsreference(j) for (i, j) ∈ all if i ∉ oldids]
    ))
end
