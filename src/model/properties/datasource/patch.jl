macro _𝑑𝑠_applicable(code)
    esc(:(if !applicable($(code.args...))
        throw(ErrorException("Unknown patch format $key => $patch" * $(", see $code") * " with arr = $(typeof(arr))"))
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
    for dico ∈ patches, (attr, vect) ∈ dico
        arr = get(γ.values, attr, nothing)
        isnothing(arr) && throw(ErrorException("Can only patch existing columns"))

        arragg = get!(()->Pair[], agg, attr)
        for (key, patch) ∈ vect
            val = @_𝑑𝑠_applicable _𝑑𝑠_convert(arr, key, patch)
            isnothing(val) || push!(arragg, val)
        end
    end

    for (attr, opts) ∈ agg, (key, patch) ∈ opts
        _𝑑𝑠_patch(γ.values[attr], key, patch)
    end

    isempty(agg) || @_𝑑𝑠_trigger ColumnsPatchedEvent agg
    return γ
end

const _𝑑𝑠_NAMED_SLICE = NamedTuple{(:start, :stop, :step)}
const _𝑑𝑠_R    = Union{Integer, OrdinalRange, StepRangeLen, _𝑑𝑠_NAMED_SLICE}
const _𝑑𝑠_2D   = AbstractVector{<:AbstractMatrix}
const _𝑑𝑠_2D_R = Tuple{<:Integer, <:_𝑑𝑠_R, <:_𝑑𝑠_R}

_𝑑𝑠_patch(𝑎, 𝑘::Integer, 𝑣)                                 = 𝑎[𝑘]                = 𝑣
_𝑑𝑠_patch(𝑎, 𝑘::AbstractRange, 𝑣)                           = 𝑎[𝑘]               .= 𝑣
_𝑑𝑠_patch(𝑎, 𝑘::Tuple{<:Integer, <:Integer, <:Integer}, 𝑣)  = 𝑎[𝑘[1]][𝑘[2],𝑘[3]]  = 𝑣
_𝑑𝑠_patch(𝑎, 𝑘::Tuple{<:Integer, Any, Any}, 𝑣)              = 𝑎[𝑘[1]][𝑘[2],𝑘[3]] .= 𝑣

function _𝑑𝑠_slice(𝑎, 𝑥)
    quote
        start = something($𝑥.start, 1)
        stop  = something($𝑥.stop,  $𝑎)
        step  = something($𝑥.step,  1)
        return step ≡ 1 ? (start:stop) : (start:step:stop)
    end
end

_𝑑𝑠_err(𝑘, 𝑣) = throw(ErrorException("Unable to apply path $𝑘 => $𝑣"))

function _𝑑𝑠_convert(𝑎::AbstractVector, key::Integer, patch)
    (1 ≤ key ≤ length(𝑎)) || _𝑑𝑠_err(key, patch)
    value = @_𝑑𝑠_applicable datatypeconvert(eltype(𝑎), patch)
    return compare(𝑎[key], value) ? nothing : key => value
end

function _𝑑𝑠_convert(𝑎::_𝑑𝑠_2D, key::Tuple{<:Integer, <:Integer, <:Integer}, patch)
    (1 ≤ key[1] ≤ length(𝑎)) || _𝑑𝑠_err(key, patch)
    itm = 𝑎[key[1]]
    (1 ≤ key[2] ≤ size(itm, 1) && 1 ≤ key[3] ≤ size(itm, 2)) || _𝑑𝑠_err(key, patch)
    value = @_𝑑𝑠_applicable datatypeconvert(eltype(eltype(𝑎)), patch)
    return compare(itm[key[1], key[2]], value) ? nothing : key => value
end

@generated function _𝑑𝑠_convert(𝑎::AbstractVector, key::_𝑑𝑠_R, patch)
    slice = key <: Colon ? :(axes(𝑎, 1)) : key <: _𝑑𝑠_NAMED_SLICE ? _𝑑𝑠_slice(:(length(𝑎)), :key) : :key
    quote
        key   = $slice
        (length(key) ≡ length(patch) && 1 ≤ minimum(key) && maximum(key) ≤ length(𝑎)) || _𝑑𝑠_err(key, patch)
        value = @_𝑑𝑠_applicable datatypearray($(eltype(𝑎)), patch)
        return compare(view(𝑎, key), value) ? nothing : key => value
    end
end

@generated function _𝑑𝑠_convert(𝑎::_𝑑𝑠_2D, 𝑘::_𝑑𝑠_2D_R, patch)
    types = (𝑘.parameters[2], 𝑘.parameters[3])

    check(ax::Int) = if types[ax] <: Integer
        :(1 ≤ key[$(ax+1)] ≤ size(itm, $ax))
    elseif types[ax] <: Colon
        :(size(itm, $ax) ≡ length(patch))
    else
        :(length(key[$(ax+1)]) ≡ length(patch) && 1 ≤ minimum(key[$(ax+1)]) &&  maximum(key[$(ax+1)]) ≤ size(itm, $ax))
    end

    slice(ax::Int) = if types[ax] <: Colon
        :(axes(itm, $ax))
    elseif types[ax] <: _𝑑𝑠_NAMED_SLICE
        _𝑑𝑠_slice(:(size(itm, $ax)), :(𝑘[$(ax+1)]))
    else
        :(𝑘[$(ax+1)])
    end

    quote
        (1 ≤ 𝑘[1] ≤ length(𝑎)) || _𝑑𝑠_err(key, patch)
        itm   = 𝑎[𝑘[1]]
        key   = (𝑘[1], $(slice(1)), $(slice(2)))
        ($(check(1)) && $(check(2))) || _𝑑𝑠_err(key, patch)
        value = @_𝑑𝑠_applicable datatypearray(eltype(itm), patch)
        return compare(view(itm, key[2], key[3]), value) ? nothing : key => value
    end
end
