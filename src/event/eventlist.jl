struct NullEventList <: iEventList
end

Base.isempty(::NullEventList)         = true
Base.popfirst!(::NullEventList)       = nothing
Base.in(::NullEventList, ::iEvent)    = false
Base.push!(::NullEventList, ::iEvent) = nothing
Base.pop!(::NullEventList, ::iEvent)  = nothing

struct EventList <: iEventList
    events :: Vector{iEvent}
    EventList() = new(iEvent[])
end

getevents(lst::iEventList) = lst.events

function Base.in(evts::iEventList, ε::iEvent)
    h = hash(ε)
    return any(h ≡ hash(i) for i ∈ getevents(evts))
end

for fcn ∈ (:isempty, :popfirst!)
    @eval Base.$fcn(evts::iEventList) = $fcn(getevents(evts))
end

Base.push!(evts::iEventList, ε::iEvent) = push!(getevents(evts), ε)

function Base.pop!(lst::iEventList, ε::iEvent)
    h    = hash(ε)
    evts = getevents(lst)
    for i ∈ reverse(eachindex(evts))
        if hash(evts[i]) ≡ h
            return popat!(evts, i)
        end
    end
    return nothing
end

struct Immediate{E <: iEventList}
    list :: E
    Immediate{E}() where {E} = new(E())
end

getevents(λ::Immediate{<:iEventList}) = getevents(λ.list)

function Base.push!(λ::Immediate{<:iEventList}, ε::iEvent)
    push!(λ.list, ε)
    flushevents!(λ.list)
end
