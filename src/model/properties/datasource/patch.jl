macro _𝑑𝑠_applicable(code)
    esc(:(if !applicable($(code.args...))
        throw(ErrorException("Unknown patch format $key => $patch"))
    else
        $code
    end))
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
        push!(get!(()-> Vector{Pair}(), agg, key), patch)
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

            vals = datatypeconvert(arr, vals)
            if _𝑑𝑠_differs(arr, inds, vals)
                push!(get!(()->Pair[], agg, key), inds => vals)
            end
        end
    end

    for (key, opts) ∈ agg, patch ∈ opts
        _𝑑𝑠_patch(γ.values[key], patch...)
    end

    isempty(agg) || @_𝑑𝑠_trigger ColumnsPatchedEvent agg
    return γ
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
