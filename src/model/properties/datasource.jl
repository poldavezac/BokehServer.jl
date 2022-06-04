macro _𝑑𝑠_trigger(T, args...)
    esc(quote
        let parent = γ.parent.value
            if (dotrigger && !isnothing(parent) && (getfield(parent, γ.attr) ≡ γ.values))
                Bokeh.Events.trigger(Bokeh.Events.$T(parent, γ.attr, $(args...)))
            end
        end
    end)
end

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

macro _𝑑𝑠_applicable(code)
    esc(:(if !applicable($(code.args...))
        throw(ErrorException("Unknown patch format $key => $patch"))
    else
        $code
    end))
end

struct DataSource <: iContainer{DataDict}
    parent :: WeakRef
    attr   :: Symbol
    values :: DataDict
end

const DataDictArg = Union{
    Pair{<:AbstractString, <:AbstractVector},
    AbstractDict{<:AbstractString, <:AbstractVector},
    AbstractVector{<:Pair{<:AbstractString, <:AbstractVector}},
    DataSource
}

function Base.push!(
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

"""
    Base.merge!(γ::DataSource, 𝑑s::Vararg{Dict{String, Vector}}; dotrigger::Bool = true)

Adds or replaces columns.
"""
function Base.merge!(γ::DataSource, 𝑑s::Vararg{DataDictArg}; dotrigger::Bool = true)
    @_𝑑𝑠_merge_args j

    filter!(𝑑) do (k, v)
        !compare(v, get(γ, k, nothing))
    end
    isempty(𝑑) && return γ   

    data = merge(γ.values, 𝑑)
    _𝑑𝑠_check(data)
    merge!(γ.values, data)
    @_𝑑𝑠_trigger ColumnDataChangedEvent 𝑑
    return γ
end

"""
    Base.merge!(γ::DataSource, patches::Vararg{Pair{String, Pair}}; dotrigger :: Bool = true)
    Base.merge!(γ::DataSource, patches::Vararg{Dict{String, Vector{Pair}}}; dotrigger :: Bool = true)

Updates values within *existing* columns.

```julia
x = DataSource(Dict("a" => [1, 2, 3]))

merge!(x, "a" => 2 => 10)
@assert x["a"] == [1, 10, 3] 

merge!(x, Dict("a" => [1 => 5, 2:3 => 10]))
@assert x["a"] == [5, 10, 10] 
```
"""
function Base.merge!(γ::DataSource, patches::Vararg{Pair{<:AbstractString, <:Pair}}; dotrigger :: Bool = true)
    isempty(patches) && return

    agg = Dict{String, Vector{Pair}}()
    for (key, patch) ∈ patches
        push!(get!(()-> Vector{Pair}, agg, key), patch)
    end
    return merge!(γ, agg; dotrigger)
end

function Base.merge!(
        γ::DataSource,
        patches::Vararg{AbstractDict{<:AbstractString, <:AbstractVector{<:Pair}}};
        dotrigger :: Bool = true
)
    isempty(patches) && return

    agg = Dict{String, Vector{Pair}}()
    for dico ∈ patches, (key, vect) ∈ dico
        arr = get(γ.values, key, nothing)
        isnothing(arr) && throw(ErrorException("Can only patch existing columns"))

        for patch ∈ vect
            inds = @_𝑑𝑠_applicable _𝑑𝑠_slice(arr, patch[1])
            if !(@_𝑑𝑠_applicable _𝑑𝑠_patch_check(γ.values[key], inds, patch[2]))
                throw(ErrorException("Unable to apply path $key => $patch"))
            end

            if _𝑑𝑠_differs(arr, inds, patch[2])
                push!(get!(()->Pair[], agg, key), inds => patch[2])
            end
        end
    end

    for (key, opts) ∈ agg, patch ∈ opts
        _𝑑𝑠_patch(γ.values[key], patch...)
    end

    isempty(agg) || @_𝑑𝑠_trigger ColumnsPatchedEvent agg
    return γ
end

Base.setindex!(γ::DataSource, 𝑘, 𝑣) = (merge!(γ, 𝑘 => 𝑣); 𝑣)
Base.size(γ::DataSource) = isempty(γ.values) ? (0, 0) : (length(first(values(γ.values))), length(γ.values))
Base.size(γ::DataSource, i :: Int) = isempty(γ.values) ? 0 : i ≡ 1 ? length(first(values(γ.values))) : length(γ.values)

function _𝑑𝑠_check(data::Dict{String, AbstractVector}, others::Vararg{<:AbstractVector})
    isempty(data) && isempty(others) && return
    sz = isempty(data) ? length(first(others)) : length(first(values(data)))
    if any(sz ≢ length(i) for i ∈ values(data)) || any(sz ≢ length(i) for i ∈ others)
        throw(ErrorException("The data source columns must have equal length"))
    end
end

const _𝑑𝑠_R    = Union{Integer, OrdinalRange, StepRangeLen}
const _𝑑𝑠_2D   = AbstractVector{<:AbstractMatrix}
const _𝑑𝑠_2D_R = Tuple{<:Integer, <:_𝑑𝑠_R, <:_𝑑𝑠_R}

_𝑑𝑠_patch_check(𝑎::AbstractVector, 𝑥::Integer, 𝑦) = 1 ≤ 𝑥 ≤ length(𝑎)

function _𝑑𝑠_patch_check(𝑎::AbstractVector, 𝑥::AbstractRange, 𝑦::AbstractVector)
    1 ≤ minimum(𝑥) && maximum(𝑥) ≤ length(𝑎) && length(𝑥) == length(𝑦)
end

@generated function _𝑑𝑠_patch_check(𝑎::_𝑑𝑠_2D, 𝑥::_𝑑𝑠_2D_R, 𝑦)
    check = quote
        (1 ≤ 𝑥[1] ≤ length(𝑎))                                &&
        1 ≤ minimum(𝑥[2]) && maximum(𝑥[2]) ≤ size(𝑎[𝑥[1]], 1) &&
        1 ≤ minimum(𝑥[3]) && maximum(𝑥[3]) ≤ size(𝑎[𝑥[1]], 2)
    end

    return if 𝑥 <: Tuple{<:Integer, <:Integer, <:Integer}
        check
    else
        :($check && length(𝑥[2]) ≡ size(𝑦,1) && length(𝑥[3]) ≡ size(𝑦,2))
    end
end

function _𝑑𝑠_view(𝑎::Type, 𝑥::Type, 𝑦::Type)
    return if 𝑥 <: Union{Integer, Tuple{<:Integer, <:Integer, <:Integer}}
        𝑎 <: _𝑑𝑠_2D ? :(𝑎[𝑥[1]][𝑥[2],𝑥[3]]) : :(𝑎[𝑥])
    else
        𝑎 <: _𝑑𝑠_2D ? :(view(𝑎[𝑥[1]], 𝑥[2], 𝑥[3])) : :(view(𝑎, 𝑥))
    end
end

@generated _𝑑𝑠_differs(𝑎, 𝑥, 𝑦) = :(!compare($(_𝑑𝑠_view(𝑎, 𝑥, 𝑦)), 𝑦))
@generated function _𝑑𝑠_patch(𝑎, 𝑥, 𝑦)
    return if 𝑥 <: Union{Integer, Tuple{<:Integer, <:Integer, <:Integer}}
        :($(_𝑑𝑠_view(𝑎, 𝑥, 𝑦))  = 𝑦)
    else
        :($(_𝑑𝑠_view(𝑎, 𝑥, 𝑦)) .= 𝑦)
    end
end

const _𝑑𝑠_NAMED_SLICE = NamedTuple{(:start, :stop, :step)}
const _𝑑𝑠_SLICE       = Union{_𝑑𝑠_R, Colon, _𝑑𝑠_NAMED_SLICE}

_𝑑𝑠_slice(𝑎::_𝑑𝑠_2D,         𝑥::_𝑑𝑠_2D_R)        = (𝑥[1], _𝑑𝑠_slice(size(𝑎, 1), 𝑥[2]), _𝑑𝑠_slice(size(𝑎, 2), 𝑥[3]))
_𝑑𝑠_slice( ::AbstractVector, 𝑥::_𝑑𝑠_R)           = 𝑥
_𝑑𝑠_slice(𝑎::AbstractVector,  ::Colon)           = axes(𝑎,1)
_𝑑𝑠_slice(𝑎::AbstractVector, 𝑥::_𝑑𝑠_NAMED_SLICE) = _𝑑𝑠_slice(size(𝑎, 1), 𝑥)
_𝑑𝑠_slice( ::Integer,        𝑥::_𝑑𝑠_R)           = 𝑥
_𝑑𝑠_slice(𝑎::Integer,         ::Colon)           = 1:𝑎
function _𝑑𝑠_slice(𝑎::Integer, 𝑥::_𝑑𝑠_NAMED_SLICE)
    start = something(𝑥.start, 1)
    stop  = something(𝑥.stop,  𝑎)
    step  = something(𝑥.step,  1)
    return step ≡ 1 ? (start:stop) : (start:step:stop)
end
