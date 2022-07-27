using HTTP.WebSockets

function patchdoc(
        λ      :: AbstractVector{<:Events.iEvent},
        doc    :: iDocument,
        oldids :: Set{Int64},
        𝑅      :: Serialize.iRules = Serialize.Rules()
)
    isempty(λ) && return nothing

    all = bokehmodels(doc)
    return (;
        events     = Any[
            serialize(i, 𝑅)
            for i ∈ λ if begin
                if i isa Events.iDocEvent
                    i.doc ≡ doc
                elseif i isa Union{Events.iDocModelEvent, Events.iModelActionEvent}
                    # only keep mutation events which refer to a model not in the references
                    id = bokehid(i.model)
                    (id ∈ oldids) && haskey(all, id)
                elseif i isa Events.iDocActionEvent
                    false
                end
            end
        ],
        references = Any[serialize(j, 𝑅) for (i, j) ∈ all if i ∉ oldids]
    )
end

function patchdoc(
        𝐹::Function,
        𝐷::iDocument,
        λ::Events.iEventList = Events.EventList(),
        𝑅::Serialize.iRules  = Serialize.Rules()
)
    oldids = bokehids(𝐷)
    lst    = Events.eventlist!(()->curdoc!(𝐹, 𝐷), λ)
    return patchdoc(lst, 𝐷, oldids, 𝑅)
end

function patchdoc(𝐹::Function, 𝐷::iDocument, λ::Events.iEventList, ios::Vararg{WebSockets.WebSocket})
    𝑅    = Serialize.BufferedRules()
    outp = patchdoc(𝐹, 𝐷, λ, 𝑅)
    return isnothing(outp) ? missing : sendmessage(ios, msg"PATCH-DOC", outp, 𝑅.buffers)
end

function patchdoc(λ::AbstractVector{<:Events.iEvent}, 𝐷::iDocument, oldids::Set{Int64}, ios::Vararg{WebSockets.WebSocket})
    any(isopen(ws.io) for ws ∈ ios) || return missing
    𝑅    = Serialize.BufferedRules()
    outp = patchdoc(λ, 𝐷, oldids, 𝑅)
    return isnothing(outp) ? missing : sendmessage(ios, msg"PATCH-DOC", outp, 𝑅.buffers)
end

patchdoc!(𝐷::iDocument, 𝐶::AbstractDict, 𝐵::Buffers) = Deserialize.deserialize!(𝐷, 𝐶, 𝐵)
