module Serialize
using Dates
using Base64
using ..AbstractTypes
using ...Model
using ...Events
using ..Protocol: Buffers

const RT  = Dict{String, Any}

abstract type iRules end

"Specifies module specific rules for json serialization"
struct Rules <: iRules end

"Specifies module specific rules for json serialization with buffers"
struct BufferedRules <: iRules
    buffers :: Buffers
    BufferedRules() = new(Buffers(undef, 0)) 
end

const _END_PATT = r"^finish" => "end"
_fieldname(x::Symbol) :: String = replace("$x", _END_PATT)

function serialroot(η::iHasProps, 𝑅::iRules) :: RT
    @nospecialize η 𝑅
    attrs = RT()
    𝑇     = typeof(η)
    for i ∈ Model.bokehproperties(𝑇)
        if hasfield(𝑇, i) && !Model.isdefaultvalue(η, i)
            attrs[_fieldname(i)] = serializeattribute(𝑇, i, getfield(η, i), 𝑅)
        end
    end
    return RT(
        "attributes"  => attrs,
        "id"          => "$(bokehid(η))",
        "type"        => "$(nameof(typeof(η)))",
    )
end

serialroot(@nospecialize(η::Events.iEvent), @nospecialize(𝑅::iRules)) ::RT  = serialref(η, 𝑅)

const _👻Simple = Union{AbstractString, Number, Nothing}

serializeattribute(::Type, ::Symbol, @nospecialize(η), @nospecialize(𝑅)) = serialref(η, 𝑅)

function serialref(@nospecialize(η), @nospecialize(𝑅::iRules))
    # using if ... elseif ... reduces compilation resources 
    return if η isa Union{
            _👻Simple,
            Tuple{Vararg{_👻Simple}},
            AbstractSet{<:_👻Simple},
            AbstractDict{String, <:_👻Simple}
    }
        η
    elseif η isa OrdinalRange
        # warning : we're going to javascript, thus the ranges start at 0...
        RT("start"  => first(η)-1, "step"  => 1, "stop"  => last(η))
    elseif η isa StepRangeLen
        # warning : we're going to javascript, thus the ranges start at 0...
        RT("start"  => first(η)-1, "step"  => step(η), "stop"  => last(η))
    elseif η isa AbstractVector{<:_👻Simple}
        # warning: put this **after** Ranges as these are considered AbstractVector types
        η
    elseif η isa Model.iSpec
        out = let itm = η.item
            key = itm isa Model.iHasProps ? "expr" : itm isa Model.Column ? "field" : "value"
            RT(key => serialref(itm, 𝑅))
        end
        let itm = η.transform
            ismissing(itm) || (out["transform"] = serialref(itm, 𝑅))
        end
        (η isa Model.iUnitSpec) && let itm = η.units.value
            (itm ≡ first(Model.units(η))) || (out["units"] = "$itm")
        end
        out
    elseif η isa iHasProps
        RT("id"  => "$(bokehid(η))")
    elseif η isa Model.EnumType
        "$(η.value)"
    elseif η isa Union{Date, DateTime}
        "$η"
    elseif η isa Model.Color
        "$(Model.colorhex(η))"
    elseif η isa Union{AbstractVector, AbstractSet, Tuple}
        Any[serialref(i, 𝑅) for i ∈ η]
    elseif η isa Union{AbstractDict, NamedTuple}
        RT(("$i" => serialref(j, 𝑅) for (i,j) ∈ η)...)
    else
        @assert !(η isa Events.iEvent)
        RT(("$i" => serialref(getfield(η, i), 𝑅) for i ∈ fieldnames(typeof(η)))...)
    end
end

for cls ∈ (:RootAddedEvent, :RootRemovedEvent)
    @eval function serialref(η::$cls, 𝑅::iRules) :: RT
        return RT("kind" => $(string(cls)[1:end-5]), "model"  => serialref(η.root, 𝑅))
    end
end

function serialroot(η::Events.TitleChangedEvent, 𝑅::iRules) :: RT
    return RT("kind"  => "TitleChanged", "title"  => η.title)
end

function serialroot(η::Events.ModelChangedEvent, 𝑅::iRules) :: RT
    return RT(
        "attr"  => _fieldname(η.attr),
        "hint"  => nothing,
        "kind"  => "ModelChanged",
        "model" => serialref(η.model, 𝑅),
        "new"   => serializeattribute(typeof(η.model), η.attr, Model.bokehunwrap(η.new), 𝑅),
    )
end

function serialroot(η::Events.ColumnsPatchedEvent, 𝑅::iRules) :: RT
    return RT(
        "column_source"  => serialref(η.model, 𝑅),
        "kind"           => "ColumnsPatched",
        "patches"        => Dict{String, Vector}(
            k => [(_𝑐𝑝_to(i, 𝑅), j) for (i, j) ∈ v]
            for (k, v) ∈ η.patches
        )
    )
end

function serialroot(η::Events.ColumnsStreamedEvent, 𝑅::iRules) :: RT
    return RT(
        "column_source"  => serialref(η.model, 𝑅),
        "data"           => serialref(η.data, 𝑅),
        "kind"           => "ColumnsStreamed",
        "rollover"       => serialref(η.rollover, 𝑅)
    )
end

function serialroot(η::Events.ColumnDataChangedEvent, ::iRules) :: RT
    𝑅 = Rules()
    return RT(
        "cols"           => serialref(collect(keys(η.data)), 𝑅),
        "column_source"  => serialref(η.model, 𝑅),
        "kind"           => "ColumnDataChanged",
        "new"            => RT(k => _𝑑𝑠_to(v, 𝑅) for (k, v) ∈ η.data)
    )
end

function serialroot(η::Events.iActionEvent, 𝑅::iRules) :: RT
    @nospecialize η 𝑅
    return RT(
        "kind"      => "MessageSent",
        "msg_data"  => RT(
            "event_name"    => η.event_name,
            "event_values"  => RT(("$i" => serialref(getfield(η, i), 𝑅) for i ∈ fieldnames(typeof(η)) if i ≢ :doc)...),
        ),
        "msg_type"  => "bokeh_event",
    )
end

_𝑐𝑝_to(x::AbstractRange, 𝑅::iRules)                  = serialref(x, 𝑅)
_𝑐𝑝_to(x::Integer,        ::iRules)                  = Int64(x)-1
_𝑐𝑝_to(x::Tuple{<:Integer, <:Any, <:Any}, 𝑅::iRules) = (x[1]-1, _𝑐𝑝_to(x[2], 𝑅), _𝑐𝑝_to(x[3], 𝑅))

const _𝑑𝑠_ID    = bokehidmaker()
const _𝑑𝑠_BIN   = Union{(AbstractVector{i} for i ∈ AbstractTypes.NumberElTypeDataDict)...}
const _𝑑𝑠_NDBIN = Union{(AbstractVector{<:AbstractArray{i}} for i ∈ AbstractTypes.NumberElTypeDataDict)...} 

_𝑑𝑠_to(𝑑::AbstractVector, ::iRules)        = 𝑑
_𝑑𝑠_to(𝑑::AbstractVector, ::BufferedRules) = 𝑑

for (R, code) ∈ (
        Rules           => :("__ndarray__"  => String(base64encode(𝑑))),
        BufferedRules   => :("__buffer__"   => let id = "$(_𝑑𝑠_ID())"
            push!(𝑅.buffers, id => reinterpret(UInt8, 𝑑))
            id
        end)
)
    @eval function _𝑑𝑠_to(𝑑::_𝑑𝑠_BIN, 𝑅::$R) :: RT
        isempty(𝑑) && return 𝑑
        return RT(
            $code,
            "dtype"  => lowercase("$(nameof(eltype(𝑑)))"),
            "order"  => Base.ENDIAN_BOM ≡ 0x04030201 ? "little" : "big",
            "shape"  => size(𝑑),
        )
    end
end

function _𝑑𝑠_to(𝑑::_𝑑𝑠_NDBIN, 𝑅::iRules)
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

const SERIAL_ROOTS = Union{Events.iEvent, iHasProps}
serialize(η::AbstractVector{<:SERIAL_ROOTS}, 𝑅 :: iRules) = [serialroot(i, 𝑅) for i ∈ η]
serialize(η::SERIAL_ROOTS,                   𝑅 :: iRules) = serialroot(η, 𝑅)

serialize(x, buffers::Buffers) = serialize(x, BufferedRules(buffers))
serialize(x, ::Nothing)        = serialize(x)
serialize(x)                   = serialize(x, Rules())

export serialize
for 𝑅 ∈ (Rules, BufferedRules)
    for 𝑇 ∈ (
            iHasProps, ModelChangedEvent, RootAddedEvent, RootRemovedEvent,
            ColumnDataChangedEvent, ColumnsStreamedEvent, ColumnsPatchedEvent,
            Events.iActionEvent,
    )
        precompile(serialroot, (𝑇, 𝑅))
    end
    precompile(serialref,  (iHasProps, 𝑅))
end
end
using .Serialize
