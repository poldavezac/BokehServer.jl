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

function patchdoc(𝐹::Function, 𝐷::iDocument, λ::Events.iEventList)
    oldids = allids(𝐷)
    lst    = Events.eventlist!(λ) do
        𝐹()
    end

    return patchdoc(lst, 𝐷, oldids)
end

function patchdoc(𝐹::Function, 𝐷::iDocument, λ::Events.iEventList, ios::Vararg{IO})
    outp = patchdoc(𝐹, 𝐷, λ)
    return isnothing(outp) ? missing : send(ios, msg"PATCH-DOC", outp, Pair{Vector{UInt8}, String}[])
end
