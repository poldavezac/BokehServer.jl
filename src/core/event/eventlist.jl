struct NullEventList <: iEventList
end

Base.isempty(::NullEventList)         = true
Base.popfirst!(::NullEventList)       = nothing
Base.in(::NullEventList, ::iEvent)    = false
Base.push!(::NullEventList, ::iEvent) = nothing
Base.pop!(::NullEventList, ::iEvent)  = nothing

for cls ∈ (:EventList, :ImmediateEventList)
    @eval struct $cls <: iEventList
        events :: Vector{iEvent}
    end
    @eval $cls() = $cls(iEvent[])
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

Base.push!(λ::ImmediateEventList, ε::iEvent) = (push!(getevents(λ), ε); flushevents!(λ))


mutable struct Deferred{T <: iEventList} <: iEventList
    events :: Vector{iEvent}
    task   :: Union{Nothing, Task}
    mutex  :: Threads.SpinLock

    Deferred{T}() where {T} = new(iEvent[], nothing, Threads.SpinLock())
end

for 𝐹 ∈ (:popfirst!, :pop!)
    @eval Base.$𝐹(λ::Deferred) = lock(()->$𝐹(getevents(λ)), λ.mutex)
end

function Base.push!(λ::Deferred, ε::iEvent)
    lock(λ.mutex) do
        push!(getevents(λ), ε)
        if isnothing(λ.task)
            λ.task = @async try
                flushevents!(λ)
            catch exc
                @error "Failed flush" exception = (exc, Base.catch_backtrace())
                rethrow(exc)
            end
        end
    end
end

function flushevents!(λ::Deferred{𝑇}) where {𝑇}
    return if isempty(getevents(λ))
        iEvent[]
    else
        flushevents!(𝑇(lock(λ.mutex) do
            λ.task = nothing
            swapfield!(λ, :events, iEvent[])
        end))
    end
end
