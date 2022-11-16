module Encoding
using Dates
using Base64
using JSON
using DataStructures
using ..AbstractTypes
using ...Model
using ...Events
using ..Protocol: Buffers

const JSDict = DataStructures.OrderedDict{String, Any}

@Base.kwdef struct Encoder
    references :: Set{Int64}        = Set{Int64}()
    deferred   :: Bool              = true
    buffers    :: Buffers           = Buffers(undef, 0)
end
Encoder(ids::AbstractSet{Int64}; k...) = Encoder(; references = Set{Int64}(ids), k...)

serialize(x, 𝑅::Encoder)       = encode(x, 𝑅)
serialize(x, buffers::Buffers) = encode(x, Encoder(; buffers))
serialize(x, ::Nothing)        = encode(x, Encoder(; deferred = false))
serialize(x)                   = encode(x, Encoder(; deferred = false))

const _👻Simple = Union{AbstractString, Bool, Int8, Int16, Int32, Nothing}
const _END_PATT = r"^finish" => "end"
_fieldname(x::Symbol) :: String = replace("$x", _END_PATT)

serialname(@nospecialize(𝑇::Type{<:iHasProps})) :: String = "$(nameof(𝑇))"
encodefield(::Type, ::Symbol, @nospecialize(η), @nospecialize(𝑅)) = encode(η, 𝑅)

_𝑟𝑒𝑓_id(η::Union{String, Int64}) = JSDict("id" => "$η")

function _𝑝𝑎𝑡𝑐ℎ_encode(@nospecialize(η::Union{Integer, AbstractRange{<:Integer}, Tuple{<:Integer, <:Any, <:Any}}), 𝑅::Encoder)
    return if η isa Integer
        Int64(η)-1
    elseif η isa AbstractRange
        _𝑒𝑛𝑐_vector(η, 𝑅)
    else
        (η[1]-1, _𝑝𝑎𝑡𝑐ℎ_encode(η[2], 𝑅), _𝑝𝑎𝑡𝑐ℎ_encode(η[3], 𝑅))
    end
end

const _𝑏𝑢𝑓_T  = tuple((AbstractArray{i} for i ∈ AbstractTypes.NumberElTypeDataDict)...)

function _𝑏𝑢𝑓_encode(@nospecialize(η::AbstractArray), 𝑅::Encoder) :: Union{JSDict, Vector{Any}}
    return if isempty(η)
        return Any[]
    elseif η isa Union{_𝑏𝑢𝑓_T...}
        JSDict(
            "type"   => "ndarray",
            "array"  => JSDict(
                "type" => "bytes",
                "data" => if 𝑅.deferred
                    id = "$(newid())"
                    push!(𝑅.buffers, id => reinterpret(UInt8, η))
                    _𝑟𝑒𝑓_id(id)
                else
                    String(base64encode(η))
                end
            ),
            "dtype"  => lowercase("$(nameof(eltype(η)))"),
            "order"  => Base.ENDIAN_BOM ≡ 0x04030201 ? "little" : "big",
            "shape"  => size(η),
        )
    elseif η isa Union{(AbstractVector{<:𝑇} for 𝑇 ∈ _𝑏𝑢𝑓_T)...}
        Any[_𝑏𝑢𝑓_encode(i, 𝑅) for i ∈ η]
    else
        Any[encode(i, 𝑅) for i ∈ η]
    end
end

const _MAX_SAFE_INT = 2^53 - 1

@inline _𝑒𝑛𝑐_int(η::Integer, ::Encoder) = !(η isa Int64) || (-_MAX_SAFE_INT < η ≤ _MAX_SAFE_INT) ? η : convert(Float64, η)
@inline _𝑒𝑛𝑐_datetime(η::Union{Date, DateTime}, ::Encoder) = "$η"
@inline _𝑒𝑛𝑐_color(η::Model.Color, ::Encoder) = "$(Model.colorhex(η))"

@inline function _𝑒𝑛𝑐_float(@nospecialize(η::AbstractFloat), ::Encoder)
    isnan(η) ? JSDict("type" => "number", "value" => "nan")                   :
    isinf(η) ? JSDict("type" => "number", "value" => η < 0 ? "-inf" : "+inf") :
    η
end

@inline function _𝑒𝑛𝑐_vector(@nospecialize(η::AbstractVector), 𝑅::Encoder)
    return if η isa OrdinalRange{Int64}
        # warning : we're going to javascript, thus the ranges start at 0...
        JSDict("type" => "slice", "start"  => first(η)-1, "step"  => 1, "stop"  => last(η))
    elseif η isa AbstractRange{Int64}
        # warning : we're going to javascript, thus the ranges start at 0...
        JSDict("type" => "slice", "start"  => first(η)-1, "step"  => step(η), "stop"  => last(η))
    else
        Any[encode(i, 𝑅) for i ∈ η]
    end
end

@inline function _𝑒𝑛𝑐_model(@nospecialize(η::iHasProps), 𝑅::Encoder) :: JSDict
    key = bokehid(η)
    out = _𝑟𝑒𝑓_id(key)
    if key ∉ 𝑅.references
        push!(𝑅.references, key)

        𝑇           = typeof(η)
        out["type"] = "object"
        out["name"] = serialname(𝑇)

        attrs = JSDict((
            _fieldname(i) => encodefield(𝑇, i, getfield(η, i), 𝑅)
            for i ∈ Model.bokehproperties(𝑇)
            if hasfield(𝑇, i) && !Model.isdefaultvalue(η, i)
        )...)
        isempty(attrs) || (out["attributes"] = attrs)
    end
    return out
end

@inline function _𝑒𝑛𝑐_namedtuple(@nospecialize(η::NamedTuple), 𝑅::Encoder)
    return JSDict(
        "type" => "map",
        "entries" => Any[("$i", encode(j, 𝑅)) for (i, j) ∈ pairs(η)]
    )
end

@inline _𝑒𝑛𝑐_tuple(@nospecialize(η::Tuple), 𝑅::Encoder) = Any[encode(i, 𝑅) for i ∈ η]

@inline function _𝑒𝑛𝑐_dict(@nospecialize(η::AbstractDict), 𝑅::Encoder)
    Dict(
        "type" => "map",
        "entries" => if η isa DataDict
            Any[(i, _𝑏𝑢𝑓_encode(j, 𝑅)) for (i, j) ∈ η]
        elseif η isa AbstractDict{<:_👻Simple, <:_👻Simple}
            collect(Any, pairs(η))
        elseif η isa AbstractDict{<:_👻Simple}
            Any[(i, encode(j, 𝑅)) for (i, j) ∈ η]
        else
            Any[(encode(i, 𝑅), encode(j, 𝑅)) for (i, j) ∈ η]
        end
    )
end

@inline function _𝑒𝑛𝑐_set(@nospecialize(η::AbstractSet), 𝑅::Encoder)
    if η isa AbstractSet{<:_👻Simple}
        JSDict("type" => "set", "entries" => collect(η))
    else
        JSDict("type" => "set", "endtries" => [encode(i, 𝑅) for i ∈ η])
    end
end

@inline function _𝑒𝑛𝑐_dataspec(@nospecialize(η::Model.iSpec), 𝑅::Encoder) :: JSDict
    out = let itm = η.item
        if itm isa Model.iHasProps
            JSDict("type" => "expr", "expr" => encode(itm, 𝑅))
        elseif itm isa Model.Column
            JSDict("type" => "field", "field" => itm.item)
        else
            JSDict("type" => "value", "value" => encode(itm, 𝑅))
        end
    end
    let itm = η.transform
        ismissing(itm) || (out["transform"] = encode(itm, 𝑅))
    end
    (η isa Model.iUnitSpec) && let itm = η.units.value
        (itm ≡ first(Model.units(typeof(η)))) || (out["units"] = "$itm")
    end
    out
end

@inline _𝑒𝑛𝑐_enumtype(η::Model.EnumType, ::Encoder) = "$(η.value)"

@inline function _𝑒𝑛𝑐_rootadded(η::Events.RootAddedEvent, 𝑅::Encoder) :: JSDict
    return JSDict("kind" => "RootAdded", "model" => encode(η.root, 𝑅))
end

@inline function _𝑒𝑛𝑐_rootremoved(η::Events.RootRemovedEvent, 𝑅::Encoder) :: JSDict
    return JSDict("kind" => "RootRemoved", "model" => _𝑟𝑒𝑓_id(bokehid(η.root)))
end

@inline function _𝑒𝑛𝑐_titlechanged(η::Events.TitleChangedEvent, 𝑅::Encoder) :: JSDict
    return JSDict("kind"  => "TitleChanged", "title"  => η.title)
end

@inline function _𝑒𝑣𝑡_output(kind::String, η::Events.iEvent, info::Vararg{Pair{String}}) :: JSDict
    @nospecialize
    return JSDict("kind"  => kind, "model" => _𝑟𝑒𝑓_id(bokehid(η.model)), "attr" => _fieldname(η.attr), info...)
end

@inline function _𝑒𝑛𝑐_modelchanged(η::Events.ModelChangedEvent, 𝑅::Encoder) :: JSDict
    return _𝑒𝑣𝑡_output("ModelChanged", η, "new" => encodefield(typeof(η.model), η.attr, Model.bokehunwrap(η.new), 𝑅))
end

@inline function _𝑒𝑛𝑐_columnspatched(η::Events.ColumnsPatchedEvent, 𝑅::Encoder) :: JSDict
    return _𝑒𝑣𝑡_output(
        "ColumnsPatched", η,
        "patches" => JSDict(
            "type" => "map",
            "entries" => Any[
                (k, Any[(_𝑝𝑎𝑡𝑐ℎ_encode(i, 𝑅), encode(j,𝑅)) for (i, j) ∈ v])
                for (k, v) ∈ η.patches
            ]
        )
    )
end

@inline function _𝑒𝑛𝑐_columnsstreamed(η::Events.ColumnsStreamedEvent, 𝑅::Encoder) :: JSDict
    return _𝑒𝑣𝑡_output("ColumnsStreamed", η, "data" => encode(η.data, 𝑅), "rollover" => encode(η.rollover, 𝑅))
end

@inline function _𝑒𝑛𝑐_columndatachanged(η::Events.ColumnDataChangedEvent, 𝑅::Encoder) :: JSDict
    return _𝑒𝑣𝑡_output(
        "ColumnDataChanged", η,
        "cols" => Any["$i" for i ∈ keys(η.data)],
        "data" => encode(η.data, Encoder(𝑅.references, false, 𝑅.buffers))
    )
end

@inline function _𝑒𝑛𝑐_action(η::Events.iUIEvent, 𝑅::Encoder) :: JSDict
    @nospecialize η 𝑅
    return JSDict(
        "kind"      => "MessageSent",
        "msg_data"  => JSDict(
            "type"   => "event",
            "name"   => η.event_name,
            "values" => JSDict(
                "type" => "map",
                "entries" => Any[
                    ("$i" => encode(getfield(η, i), 𝑅))
                    for i ∈ fieldnames(typeof(η)) if i ≢ :doc
                ]
            ),
        ),
        "msg_type"  => "bokeh_event",
    )
end

# creating a static dispatch of all `_𝑒𝑛𝑐_` methods
@eval function encode(η, 𝑅::Encoder)
    @nospecialize
    # for compilation performance, we use if ... elseif ... pattern rather than relying on multiple dispatch
    return $(let expr = :(if η isa Union{Symbol, _👻Simple, Tuple{Vararg{Union{Symbol, _👻Simple}}}}
            η
        else
            throw(BokehException("Don't know how to encode Type{$(typeof(η))}"))
        end)

        last = expr
        for name ∈ names(@__MODULE__; all = true)
            key  = "$name"
            startswith(key, "_𝑒𝑛𝑐_") || continue
            𝑇    = methods(getfield(@__MODULE__, name))[1].sig.parameters[2]
            last = last.args[end] = Expr(:elseif, :(η isa $𝑇), :($name(η, 𝑅)), last.args[end])
        end
        expr
    end)
end

end
using .Encoding: serialize, Encoder
