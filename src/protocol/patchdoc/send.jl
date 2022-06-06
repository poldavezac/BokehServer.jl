function patchdoc(λ::AbstractVector{<:Events.iEvent}, doc::iDocument, oldids::Set{Int64}, 𝑅::Serialize.iRules = Serialize.Rules())
    isempty(λ) && return nothing

    all = allmodels(doc)
    filt(k::Events.iModelEvent)    = haskey(all, bokehid(k.model))
    filt(k::Events.iDocumentEvent) = k.doc ≡ doc

    return (;
        events     = serialize([i for i ∈ λ if filt(i)], 𝑅),
        references = serialize([j for (i, j) ∈ all if i ∉ oldids], 𝑅)
    )
end

function patchdoc(
        𝐹::Function,
        𝐷::iDocument,
        λ::Events.iEventList = Events.EventList(),
        𝑅::Serialize.iRules  = Serialize.Rules()
)
    oldids = allids(𝐷)
    lst    = Events.eventlist!(()->curdoc!(𝐹, 𝐷), λ)
    return patchdoc(lst, 𝐷, oldids, 𝑅)
end

function patchdoc(𝐹::Function, 𝐷::iDocument, λ::Events.iEventList, ios::Vararg{IO})
    𝑅    = Serialize.BufferedRules()
    outp = patchdoc(𝐹, 𝐷, λ, 𝑅)
    return isnothing(outp) ? missing : send(ios, msg"PATCH-DOC", outp, 𝑅.buffers)
end
