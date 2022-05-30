struct DataSource <: iContainer{Dict{String, AbstractVector}}
    parent :: WeakRef
    attr   :: Symbol
    values :: Dict{String, AbstractVector}
end

function _𝑑𝑠_check(data::Dict{String, AbstractVector}, others::Vararg{<:AbstractVector})
    isempty(data) && isempty(others) && return
    sz = isempty(data) ? length(first(others)) : length(first(values(data)))
    if any(sz ≢ length(i) for i ∈ values(data)) || any(sz ≢ length(i) for i ∈ others)
        throw(ErrorException("The data source columns must have equal length"))
    end
end

macro _𝑑𝑠_trigger(T, args...)
    quote
        let parent = β.parent.value
            if (dotrigger && !isnothing(parent) && (β.values ≡ parent.values))
                Events.trigger($T(parent, β.attr, $(args...)))
            end
        end
    end
end

function Base.merge!(β::DataSource, 𝑑::Dict{String, AbstractVector})
    isempty(𝑑) && return β
    data = merge(β.values, 𝑑)
    _𝑑𝑠_check(data)
    merge!(β.values, data)
    @_𝑑𝑠_trigger ColumnDataChangedEvent Dict{String, AbstractVector}(i=>copy(j) for (i, j) ∈ 𝑑)
    return β
end

Base.merge!(β::DataSource, 𝑑::DataSource) = Base.merge!(β, 𝑑.values)

function Base.setindex!(β::DataSource, 𝑘, 𝑣)
    if !isempty(β.values) & length(𝑣) ≢ length(first(values(β.values)))
        throw(ErrorException("The data source columns must have equal length"))
    end
    _𝑑𝑠_check(data, 𝑣)
    β.values[𝑘] = 𝑣
    @_𝑑𝑠_trigger ColumnDataChangedEvent Dict{String, AbstractVector}(𝑘 => copy(𝑣))
    return 𝑣
end

Base.size(β::DataSource) = isempty(β.values) ? (0, 0) : (length(first(values(β.values))), length(β.values))
Base.size(β::DataSource, i :: Int) = isempty(β.values) ? 0 : i ≡ 1 ? length(first(values(β.values))) : length(β.values)

function stream!(
        β::DataSource,
        rows,
        rollover  :: Union{Int, Nothing} = nothing;
        dotrigger :: Bool                = true
)
    isempty!(rows) && return
    (!isnothing(rollover) && (rollover ≤ 0)) && (rollover = nothing)

    len  = size(β, 1)
    data = Dict{String, AbstractVector}(
        i => let old = get(β.values, i, missing)
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
        for (i, j) ∈ rows
    )
    _𝑑𝑠_check(data)
    keys(data) ⊇ keys(β.values) || throw(ErrorException("`stream!` requires new data for every column"))

    merge!(β.values, data)
    @_𝑑𝑠_trigger ColumnsStreamedEvent collect(rows) rollover
end

macro _𝑑𝑠_patch(T𝑎, T𝑥, T𝑦, check, apply)
    quote
        _𝑑𝑠_patch(𝑎::$T𝑎, 𝑥::$T𝑥, 𝑦::$T𝑦) = $apply
        _𝑑𝑠_p_check(𝑎::$T𝑎, 𝑥::$T𝑥, 𝑦::$T𝑦) = $check
    end
end

const _𝑑𝑠_RANGES = Union{OrdinalRange, StepRangeLen}
@_𝑑𝑠_patch AbstractVector Int Any (𝑎[𝑥] = 𝑦) (1 ≤ 𝑥 ≤ length(𝑎))
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
        && 1 ≤ first(𝑥[2]) && last(𝑥[2]) ≤ size(𝑎[x[1]], 1)
        && 1 ≤ first(𝑥[3]) && last(𝑥[3]) ≤ size(𝑎[x[1]], 2)
    )
)
@_𝑑𝑠_patch(
    AbstractVector{<:AbstractMatrix}, Tuple{<:Integer, <:Integer, <:Integer}, Any,
    𝑎[𝑥[1]][𝑥[2], 𝑥[3]] = 𝑦,
    (
        (1 ≤ 𝑥[1] ≤ length(𝑎))
        && 1 ≤ 𝑥[2] ≤ size(𝑎[x[1]], 1)
        && 1 ≤ 𝑥[3] ≤ size(𝑎[x[1]], 2)
    )
)

function patch!(
        β::DataSource,
        patches::Vararg{Pair{<:AbstractString, <:Pair}};
        dotrigger :: Bool = true
)
    isempty!(patches) && return
    for (key, (inds, vals)) ∈ patches
        arr = get(β.values, key, nothing)
        if isnothing(arr)
            throw(ErrorException("Can only patch existing columns"))
        elseif !applicable(_𝑑𝑠_p_check, arr, inds, vals)
            throw(ErrorException("Unknown patch format $key => $patch"))
        elseif !_𝑑𝑠_p_check(β.values[key], inds, vals)
            throw(ErrorException("Unable to apply path $key => $patch"))
        end
    end

    for (key, patch) ∈ patches
        _𝑑𝑠_patch(β.values[key], patch...)
    end

    @_𝑑𝑠_trigger ColumnsPatchedEvent collect(patches)
end
