const DataDictArg = Union{
    Pair{<:AbstractString, <:AbstractVector},
    AbstractDict{<:AbstractString, <:AbstractVector},
    AbstractVector{<:Pair{<:AbstractString, <:AbstractVector}},
    DataDictContainer
}

function stream!(
        γ         :: DataDictContainer,
        𝑑s        :: Vararg{DataDictArg};
        rollover  :: Union{Int, Nothing} = nothing,
        dotrigger :: Bool                = true
)
    @_𝑑𝑠_merge_args haskey(out, i) ? vcat(out[i], j) : copy(j)
    (!isnothing(rollover) && (rollover ≤ 0)) && (rollover = nothing)

    len  = size(γ, 1)
    data = DataDict(
        "$i" => let old = get(γ.values, i, missing)
            if ismissing(old) || (!isnothing(rollover) && rollover ≡ length(j))
                j
            elseif isnothing(rollover) || rollover > length(j) + length(old)
                vcat(old, j)
            elseif rollover < length(j)
                j[end-rollover+1:end]
            else
                vcat(@view(old[end-rollover+1+length(j):end]), j)
            end
        end
        for (i, j) ∈ 𝑑
    )
    keys(data) ⊇ keys(γ.values) || throw(ErrorException("`stream!` requires new data for every column"))

    _𝑑𝑠_check(data)
    merge!(γ.values, data)
    @_𝑑𝑠_trigger ColumnsStreamedEvent 𝑑 rollover
    return γ
end

function Base.push!(
        γ         :: DataDictContainer,
        𝑑s        :: Vararg{DataDictArg};
        rollover  :: Union{Int, Nothing} = nothing,
        dotrigger :: Bool                = true
)
    stream!(γ, 𝑑s...; rollover, dotrigger)
end

export stream!
