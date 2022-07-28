module Serialize
using Dates
using Base64
using ..AbstractTypes
using ...Model
using ...Events
using ..Protocol: Buffers

const JSDict  = Dict{String, Any}

@Base.kwdef struct Serializer
    references :: Dict{Int, Any} = Dict{Int, Any}()
    deferred   :: Bool           = true
    buffers    :: Buffers        = Buffers(undef, 0)
end

abstract type Serializer end

const _👻Simple     = Union{AbstractString, Bool, Int8, Int16, Int32, Nothing}
const _MAX_SAFE_INT = 2^53 - 1
const _END_PATT     = r"^finish" => "end"
_fieldname(x::Symbol) :: String = replace("$x", _END_PATT)

serialname(@nospecialize(𝑇::Type{<:iHasProps})) :: String = "$(nameof(𝑇))"
serializefield(::Type, ::Symbol, @nospecialize(η), @nospecialize(𝑅)) = serialize(η, 𝑅)


serialize(x, buffers::Buffers) = serialize(x, Serializer(; buffers))
serialize(x, ::Nothing)        = serialize(x, Serializer(; deferred = false))
serialize(x)                   = serialize(x, Serializer(; deferred = false))

function serialize(@nospecialize(η), 𝑅::Serializer)
    # for compilation performance, we use if ... elseif ... pattern rather than relying on multiple dispatch
    return if η isa Union{_👻Simple, Tuple{Vararg{_👻Simple}}}
        η
    elseif η isa Int64
        _MAX_SAFE_INT < η ≤ _MAX_SAFE_INT ? η : convert(Float64, η)
    elseif η isa Real
        isnan(η) ? JSDict("type" => "number", "value" => "nan")                   :
        isinf(η) ? JSDict("type" => "number", "value" => η < 0 ? "-inf" : "+inf") :
        η
    elseif η isa OrdinalRange
        # warning : we're going to javascript, thus the ranges start at 0...
        JSDict("type" => "slice", "start"  => first(η)-1, "step"  => 1, "stop"  => last(η))
    elseif η isa StepRangeLen
        # warning : we're going to javascript, thus the ranges start at 0...
        JSDict("type" => "slice", "start"  => first(η)-1, "step"  => step(η), "stop"  => last(η))
    elseif η isa AbstractVector{<:_👻Simple}
        η # warning: put this **after** Ranges as these are considered AbstractVector types

    elseif η isa AbstractSet{<:_👻Simple}
        JSDict("type" => "set", "endtries" => collect(η))
    elseif η isa AbstractSet
        JSDict("type" => "set", "endtries" => [serialize(i, 𝑅) for i ∈ η])


    elseif η isa AbstractDict{<:_👻Simple, <:_👻Simple}
        JSDict("type" => "map", η...)

    elseif η isa AbstractDict{<:_👻Simple}
        JSDict("type" => "map", (i => serialize(j, 𝑅) for (i, j) ∈ η)...)


    elseif η isa NamedTuple
        JSDict("type" => "map", ("$i" => serialize(j, 𝑅) for (i, j) ∈ η)...)

    elseif η isa AbstractDict
        JSDict("type" => "map", (serialize(i, 𝑅) => serialize(j, 𝑅) for (i, j) ∈ η)...)

    elseif η isa Union{AbstractVector, AbstractSet, Tuple}
        Any[serialize(i, 𝑅) for i ∈ η]

    elseif η isa Model.iSpec
        _serialize_dataspec(η, 𝑅)

    elseif η isa Model.iHasProps
        _serialize_model(η, 𝑅)

    elseif η isa Model.EnumType
        "$(η.value)"
    elseif η isa Union{Date, DateTime}
        "$η"
    elseif η isa Model.Color
        "$(Model.colorhex(η))"
    else
        @assert !(η isa Events.iEvent)
        JSDict(("$i" => serialize(getfield(η, i), 𝑅) for i ∈ fieldnames(typeof(η)))...)
    end
end

for cls ∈ (:RootAddedEvent, :RootRemovedEvent)
    @eval function serialize(η::$cls, 𝑅::Serializer) :: JSDict
        return JSDict("kind" => $(string(cls)[1:end-5]), "model"  => serialize(η.root, 𝑅))
    end
end

function serialize(η::Events.TitleChangedEvent, 𝑅::Serializer) :: JSDict
    return JSDict("kind"  => "TitleChanged", "title"  => η.title)
end

function serialize(η::Events.ModelChangedEvent, 𝑅::Serializer) :: JSDict
    return JSDict(
        "attr"  => _fieldname(η.attr),
        "hint"  => nothing,
        "kind"  => "ModelChanged",
        "model" => serialize(η.model, 𝑅),
        "new"   => serializefield(typeof(η.model), η.attr, Model.bokehunwrap(η.new), 𝑅),
    )
end

function serialize(η::Events.ColumnsPatchedEvent, 𝑅::Serializer) :: JSDict
    return JSDict(
        "column_source"  => serialize(η.model, 𝑅),
        "kind"           => "ColumnsPatched",
        "patches"        => Dict{String, Vector}(
            k => [(_𝑐𝑝_to(i, 𝑅), j) for (i, j) ∈ v]
            for (k, v) ∈ η.patches
        )
    )
end

function serialize(η::Events.ColumnsStreamedEvent, 𝑅::Serializer) :: JSDict
    return JSDict(
        "column_source"  => serialize(η.model, 𝑅),
        "data"           => serialize(η.data, 𝑅),
        "kind"           => "ColumnsStreamed",
        "rollover"       => serialize(η.rollover, 𝑅)
    )
end

function serialize(η::Events.ColumnDataChangedEvent, ::Serializer) :: JSDict
    𝑅 = Rules()
    return JSDict(
        "cols"           => serialize(collect(keys(η.data)), 𝑅),
        "column_source"  => serialize(η.model, 𝑅),
        "kind"           => "ColumnDataChanged",
        "new"            => JSDict(k => _𝑑𝑠_to(v, 𝑅) for (k, v) ∈ η.data)
    )
end

function serialize(η::Events.iActionEvent, 𝑅::Serializer) :: JSDict
    @nospecialize η 𝑅
    return JSDict(
        "kind"      => "MessageSent",
        "msg_data"  => JSDict(
            "event_name"    => η.event_name,
            "event_values"  => JSDict(("$i" => serialize(getfield(η, i), 𝑅) for i ∈ fieldnames(typeof(η)) if i ≢ :doc)...),
        ),
        "msg_type"  => "bokeh_event",
    )
end

_𝑐𝑝_to(x::AbstractRange, 𝑅::Serializer)                  = serialize(x, 𝑅)
_𝑐𝑝_to(x::Integer,        ::Serializer)                  = Int64(x)-1
_𝑐𝑝_to(x::Tuple{<:Integer, <:Any, <:Any}, 𝑅::Serializer) = (x[1]-1, _𝑐𝑝_to(x[2], 𝑅), _𝑐𝑝_to(x[3], 𝑅))

const _𝑑𝑠_ID    = bokehidmaker()
const _𝑑𝑠_BIN   = Union{(AbstractVector{i} for i ∈ AbstractTypes.NumberElTypeDataDict)...}
const _𝑑𝑠_NDBIN = Union{(AbstractVector{<:AbstractArray{i}} for i ∈ AbstractTypes.NumberElTypeDataDict)...} 

_𝑑𝑠_to(@nospecialize(𝑑::AbstractVector), ::Serializer) = 𝑑

function _𝑑𝑠_to(𝑑::_𝑑𝑠_BIN, 𝑅::Serializer) :: JSDict
    isempty(𝑑) && return 𝑑
    return JSDict(
        "type"   => "ndarray",
        "array"  => if 𝑅.deferred
            id = "$(_𝑑𝑠_ID())"
            push!(𝑅.buffers, id => reinterpret(UInt8, 𝑑))
            JSDict("type" => "ref", "id" => id)
        else
            JSDict("type" => "bytes", "data" => String(base64encode(𝑑)))
        end,
        "dtype"  => lowercase("$(nameof(eltype(𝑑)))"),
        "order"  => Base.ENDIAN_BOM ≡ 0x04030201 ? "little" : "big",
        "shape"  => size(𝑑),
    )
end

function _𝑑𝑠_to(𝑑::_𝑑𝑠_NDBIN, 𝑅::Serializer)
    isempty(𝑑) && return 𝑑
    sz = size(first(𝑑))
    if all(size(i) ≡ sz for i ∈ @view 𝑑[2:end])
        x = copy(reshape(first(𝑑), :))
        foreach(Base.Fix1(append!, x), @view 𝑑[2:end])
        _𝑑𝑠_to(reshape(x, :, sz...), 𝑅)
    else
        𝑑
    end
end

function _serialize_model(@nospecialize(η::iHasProps), 𝑅::Serializer) :: JSDict
    out = get(𝑅.references, objectid(η))
    if isnothing(out)
        𝑇 = typeof(η)

        attrs = JSDict((
            _fieldname(i) => serializefield(𝑇, i, getfield(η, i), 𝑅)
            for i ∈ Model.bokehproperties(𝑇)
            if hasfield(𝑇, i) && !Model.isdefaultvalue(η, i)
        )...)

        out   = JSDict(
            "id"          => "$(bokehid(η))",
            "type"        => "object"
            "name"        => serialname(𝑇)
        )
        isempty(attrs) || (out["attributes"] = attrs)
    end
    return out
end

function _serialize_dataspec(@nospecialize(η::iSpec), 𝑅::Serializer) :: JSDict
    out = let itm = η.item
        if itm isa Model.iHasProps
            JSDict("type" => "expr", "expr" => serialize(itm, 𝑅))
        elseif itm isa Model.Column
            JSDict("type" => "field", "field" => itm.item)
        else
            JSDict("type" => "value", "value" => serialize(itm, 𝑅))
        end
    end
    let itm = η.transform
        ismissing(itm) || (out["transform"] = serialize(itm, 𝑅))
    end
    (η isa Model.iUnitSpec) && let itm = η.units.value
        (itm ≡ first(Model.units(typeof(η)))) || (out["units"] = "$itm")
    end
    out
end

export serialize
end
using .Serialize
