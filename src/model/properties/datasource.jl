struct DataSource <: iContainer{DataDict}
    parent :: WeakRef
    attr   :: Symbol
    values :: DataDict
end

function _𝑑𝑠_check(data::Dict{String, AbstractVector}, others::Vararg{<:AbstractVector})
    isempty(data) && isempty(others) && return
    sz = isempty(data) ? length(first(others)) : length(first(values(data)))
    if any(sz ≢ length(i) for i ∈ values(data)) || any(sz ≢ length(i) for i ∈ others)
        throw(ErrorException("The data source columns must have equal length"))
    end
end

macro _𝑑𝑠_trigger(T, args...)
    esc(quote
        let parent = γ.parent.value
            if (dotrigger && !isnothing(parent) && (getfield(parent, γ.attr) ≡ γ.values))
                Bokeh.Events.trigger(Bokeh.Events.$T(parent, γ.attr, $(args...)))
            end
        end
    end)
end

const DataDictArg = Union{
    Pair{<:AbstractString, <:AbstractVector},
    AbstractDict{<:AbstractString, <:AbstractVector},
    AbstractVector{<:Pair{<:AbstractString, <:AbstractVector}},
    DataSource
}

macro _𝑑𝑠_merge_args(code)
    esc(quote
        isempty(𝑑s) && return γ

        𝑑 = if length(𝑑s) ≡ 1 && first(𝑑s) isa AbstractDict
            first(𝑑s)
        else
            out = DataDict()
            for 𝑑 ∈ 𝑑s, (i, j) ∈ (𝑑 isa Pair ? (𝑑,) : bokehrawtype(𝑑))
                out[i] = $code
            end
            out
        end
        isempty(𝑑) && return γ
    end)
end

function Base.merge!(γ::DataSource, 𝑑s::Vararg{DataDictArg}; dotrigger::Bool = true)
    @_𝑑𝑠_merge_args copy(j)
    data = merge(γ.values, 𝑑)
    _𝑑𝑠_check(data)
    merge!(γ.values, data)
    @_𝑑𝑠_trigger ColumnDataChangedEvent 𝑑
    return γ
end

Base.setindex!(γ::DataSource, 𝑘, 𝑣) = (merge!(γ, 𝑘 => 𝑣); 𝑣)
Base.size(γ::DataSource) = isempty(γ.values) ? (0, 0) : (length(first(values(γ.values))), length(γ.values))
Base.size(γ::DataSource, i :: Int) = isempty(γ.values) ? 0 : i ≡ 1 ? length(first(values(γ.values))) : length(γ.values)

function stream!(
        γ         :: DataSource,
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

macro _𝑑𝑠_patch(T𝑎, T𝑥, T𝑦, apply, check)
    esc(quote
        _𝑑𝑠_patch(𝑎::$T𝑎, 𝑥::$T𝑥, 𝑦::$T𝑦) = $apply
        _𝑑𝑠_patch_check(𝑎::$T𝑎, 𝑥::$T𝑥, 𝑦::$T𝑦) :: Bool = $check
    end)
end

const _𝑑𝑠_RANGES = Union{OrdinalRange, StepRangeLen}

_𝑑𝑠_patch(𝑎, 𝑥::Pair)       = _𝑑𝑠_patch(𝑎, 𝑥[1], 𝑥[2])
_𝑑𝑠_patch_check(𝑎, 𝑥::Pair) = _𝑑𝑠_patch_check(𝑎, 𝑥[1], 𝑥[2])

@_𝑑𝑠_patch AbstractVector Int   Any            (𝑎[𝑥] = 𝑦)  (1 ≤ 𝑥 ≤ length(𝑎))
@_𝑑𝑠_patch AbstractVector Colon AbstractVector (𝑎[𝑥] .= 𝑦) (length(𝑎) ≡ length(𝑦))
@_𝑑𝑠_patch(
    AbstractVector, _𝑑𝑠_RANGES, AbstractVector,
    𝑎[𝑥] .= 𝑦,
    length(𝑥) ≡ length(𝑦) && 1 ≤ minimum(𝑥)  && maximum(𝑥) ≤ length(𝑎)
)
@_𝑑𝑠_patch(
    AbstractVector{<:AbstractMatrix}, Tuple{<:Integer, <:_𝑑𝑠_RANGES, <:_𝑑𝑠_RANGES}, AbstractVector,
    𝑎[𝑥[1]][𝑥[2], 𝑥[3]] .= 𝑦,
    (
        (1 ≤ 𝑥[1] ≤ length(𝑎))
        && 1 ≤ first(𝑥[2]) && last(𝑥[2]) ≤ size(𝑎[𝑥[1]], 1)
        && 1 ≤ first(𝑥[3]) && last(𝑥[3]) ≤ size(𝑎[𝑥[1]], 2)
    )
)
@_𝑑𝑠_patch(
    AbstractVector{<:AbstractMatrix}, Tuple{<:Integer, <:Integer, <:Integer}, Any,
    𝑎[𝑥[1]][𝑥[2], 𝑥[3]] = 𝑦,
    (
        (1 ≤ 𝑥[1] ≤ length(𝑎))
        && 1 ≤ 𝑥[2] ≤ size(𝑎[𝑥[1]], 1)
        && 1 ≤ 𝑥[3] ≤ size(𝑎[𝑥[1]], 2)
    )
)

function patch!(
        γ::DataSource,
        patches::Vararg{Pair{<:AbstractString, <:Pair}};
        dotrigger :: Bool = true
)
    isempty(patches) && return
    for (key, patch) ∈ patches
        arr = get(γ.values, key, nothing)
        if isnothing(arr)
            throw(ErrorException("Can only patch existing columns"))
        elseif !applicable(_𝑑𝑠_patch_check, arr, patch...)
            throw(ErrorException("Unknown patch format $key => $patch"))
        elseif !_𝑑𝑠_patch_check(γ.values[key], patch...)
            throw(ErrorException("Unable to apply path $key => $patch"))
        end
    end

    for (key, patch) ∈ patches
        _𝑑𝑠_patch(γ.values[key], patch...)
    end

    @_𝑑𝑠_trigger ColumnsPatchedEvent let out = Dict{String, Vector{Pair}}()
        for (k, v) ∈ patches
            push!(get!(out, k, Pair[]), v)
        end
        out
    end
end
