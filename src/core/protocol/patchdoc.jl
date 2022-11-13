using HTTP.WebSockets
function patchdoc(
        λ      :: AbstractVector{<:Events.iEvent},
        doc    :: iDocument,
        oldids :: Set{Int64},
        oldevts:: AbstractVector{<:Events.iEvent} = Events.iEvent[];
        deferred :: Bool = true
)
    isempty(λ) && return nothing

    all = Model.bokehmodels(doc)
    𝑅   = Encoder(oldids; deferred)
    return (;
        events = Any[
            serialize(i, 𝑅)
            for i ∈ λ if begin
                if any(Model.compare(i, o) for o ∈ oldevts)
                    false
                elseif i isa Events.iDocEvent
                    i.doc ≡ doc
                elseif i isa Union{Events.iDocModelEvent, Events.iModelUIEvent}
                    # only keep mutation events which refer to a model not in the references
                    id = bokehid(i.model)
                    (id ∈ oldids) && haskey(all, id)
                else
                    !(i isa Events.iDocUIEvent)
                end
            end
        ],
        𝑅.buffers
    )
end

function patchdoc(𝐹::Function, 𝐷::iDocument, λ::Events.iEventList = Events.EventList(); k...)
    oldids = bokehids(𝐷)
    lst    = Events.eventlist!(()->curdoc!(𝐹, 𝐷), λ)
    return patchdoc(lst, 𝐷, oldids; k...)
end

function patchdoc(𝐹::Function, 𝐷::iDocument, λ::Events.iEventList, ios::Vararg{WebSockets.WebSocket}; k...)
    outp = patchdoc(𝐹, 𝐷, λ; k...)
    return isnothing(outp) ? missing : sendmessage(ios, msg"PATCH-DOC", (; outp.events), outp.buffers)
end

function patchdoc(
        λ::AbstractVector{<:Events.iEvent},
        𝐷::iDocument,
        oldids::Set{Int64},
        ios::Vararg{WebSockets.WebSocket};
        k...
)
    return patchdoc(λ, 𝐷, oldids, Events.iEvent[], ios...; k...)
end

function patchdoc(
        λ::AbstractVector{<:Events.iEvent},
        𝐷::iDocument,
        oldids::Set{Int64},
        oldevts::AbstractVector{<:Events.iEvent},
        ios::Vararg{WebSockets.WebSocket};
        k...
)
    any(isopen(ws.io) for ws ∈ ios) || return missing
    outp = patchdoc(λ, 𝐷, oldids, oldevts; k...)
    return isnothing(outp) ? missing : sendmessage(ios, msg"PATCH-DOC", (; outp.events), outp.buffers)
end

patchdoc!(𝐷::iDocument, 𝐶::AbstractDict{String, Any}, 𝐵::Buffers) = deserialize!(𝐷, 𝐶, 𝐵)

function onreceive!(μ::msg"PATCH-DOC", 𝐷::iDocument, λ::Events.iEventList, ios::Vararg{WebSockets.WebSocket})
    oldevts = Events.iEvent[]
    oldids  = bokehids(𝐷)
    outp    = Events.eventlist!(λ) do
        curdoc!(𝐷) do
           append!(oldevts, patchdoc!(𝐷, μ.contents, µ.buffers))
        end
    end

    isempty(outp) && return missing

    msgid = patchdoc(outp, 𝐷, oldids, oldevts, ios[begin])
    (length(ios) > 1) && (msgid = patchdoc(outp, 𝐷, oldids, ios[begin+1:end]...))
    return msgid
end
