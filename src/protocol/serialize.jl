module Serialize
using Dates
using Base64
using ..AbstractTypes
using ...Model
using ...Events
using ..Protocol: Buffers

abstract type iRules end

"Specifies module specific rules for json serialization"
struct Rules <: iRules end

"Specifies module specific rules for json serialization with buffers"
struct BufferedRules <: iRules
    buffers :: Buffers
    BufferedRules() = new(Buffers(undef, 0)) 
end

serialtype(η::T, ::iRules) where {T <: iHasProps} = (; type = nameof(T))
serialtype(::Type{T}, ::iRules) where {T <: iHasProps} = (; type = nameof(T))

const _END_PATT = r"^finish" => "end"
_fieldname(x::Symbol) = Symbol(replace("$x", _END_PATT))

function serialattributes(η::T, 𝑅::iRules) where {T <: iHasProps}
    return (;(
        _fieldname(i) => serialref(j, Model.bokehrawtype(getproperty(η, i)), 𝑅)
        for (i, j) ∈ Model.bokehfields(T)
        if !Model.isdefaultvalue(η, i)
    )...)
end

function serialroot(η::iHasProps, 𝑅::iRules)
    return (;
        attributes = serialattributes(η, 𝑅),
        serialref(η, 𝑅)...,
        serialtype(η, 𝑅)...
    )
end
serialroot(η::Events.iEvent, 𝑅::iRules) = serialref(η, 𝑅)
serialref(::Type, η, 𝑅::iRules)         = serialref(η, 𝑅)
serialref(η::iHasProps, ::iRules)       = (; id = "$(bokehid(η))")
serialref(::Nothing, ::iRules)          = nothing

for cls ∈ (:RootAddedEvent, :RootRemovedEvent)
    @eval function serialref(η::$cls, 𝑅::iRules)
        return (;
            kind  = $(Meta.quot(Symbol(string(cls)[1:end-5]))),
            model = serialref(η.root, 𝑅)
        )
    end
end

function serialref(η::Events.ModelChangedEvent, 𝑅::iRules)
    return (;
        attr  = _fieldname(η.attr),
        hint  = nothing,
        kind  = :ModelChanged,
        model = serialref(η.model, 𝑅),
        new   = serialref(η.new, 𝑅),
    )
end

# warning : we're going to javascript, thus the ranges start at 0...
serialref(x::OrdinalRange, ::iRules) = (; start = first(x)-1, step = 1,       stop = last(x))
serialref(x::StepRangeLen, ::iRules) = (; start = first(x)-1, step = step(x), stop = last(x))
_𝑐𝑝_to(x::AbstractRange, 𝑅::iRules) = serialref(x, 𝑅)
_𝑐𝑝_to(x::Integer,        ::iRules) = x-1
_𝑐𝑝_to(x::Tuple{<:Integer, <:Any, <:Any}, 𝑅::iRules) = (x[1]-1, _𝑐𝑝_to(x[2], 𝑅), _𝑐𝑝_to(x[3], 𝑅))

function serialref(η::Events.ColumnsPatchedEvent, 𝑅::iRules)
    return (;
        column_source = serialref(η.model, 𝑅),
        kind          = :ColumnsPatched,
        patches       = Dict{String, Vector}(
            k => [(_𝑐𝑝_to(i, 𝑅), j) for (i, j) ∈ v]
            for (k, v) ∈ η.patches
        )
    )
end

function serialref(η::Events.ColumnsStreamedEvent, 𝑅::iRules)
    return (;
        column_source = serialref(η.model, 𝑅),
        data          = serialref(η.data, 𝑅),
        kind          = :ColumnsStreamed,
        rollover      = serialref(η.rollover, 𝑅)
    )
end

function serialref(η::Events.ColumnDataChangedEvent, 𝑅::iRules)
    new           = serialref(Model.DataDictContainer, η.data, 𝑅)
    return (;
        cols          = serialref(collect(keys(η.data)), 𝑅),
        column_source = serialref(η.model, 𝑅),
        kind          = :ColumnDataChanged,
        new
    )
end

function serialref(η::Events.iActionEvent, 𝑅::iRules)
    return (;
        kind     = :MessageSent,
        msg_type = :bokeh_event,
        msg_data = (; (i => serialref(getproperty(η, i), 𝑅) for i ∈ propertynames(η) if i ≢ :doc)...)
    )
end

const _𝑑𝑠_ID    = bokehidmaker()
const _𝑑𝑠_BIN   = Union{(AbstractVector{i} for i ∈ AbstractTypes.NumberElTypeDataDict)...}
const _𝑑𝑠_NDBIN = Union{(AbstractVector{<:AbstractArray{i}} for i ∈ AbstractTypes.NumberElTypeDataDict)...} 

_𝑑𝑠_to(𝑑::AbstractVector, ::iRules)        = 𝑑
_𝑑𝑠_to(𝑑::AbstractVector, ::BufferedRules) = 𝑑

for (R, code) ∈ (
        Rules           => :(__ndarray__ = String(base64encode(𝑑))),
        BufferedRules   => :(__buffer__  = let id = "$(_𝑑𝑠_ID())"
            push!(𝑅.buffers, id => reinterpret(Int8, 𝑑))
            id
        end)
)
    @eval function _𝑑𝑠_to(𝑑::_𝑑𝑠_BIN, 𝑅::$R)
        isempty(𝑑) && return 𝑑
        return (;
            $(Expr(:kw, code.args...)),
            dtype = lowercase("$(nameof(eltype(𝑑)))"),
            order = Base.ENDIAN_BOM ≡ 0x04030201 ? :little : :big,
            shape = size(𝑑),
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

function serialref(::Type{Model.DataDictContainer}, 𝑑::DataDict, 𝑅::iRules)
    return Dict{String, Union{Vector, NamedTuple}}(k => _𝑑𝑠_to(v, 𝑅) for (k, v) ∈ 𝑑)
end

serialref(η::TitleChangedEvent, 𝑅::iRules) = (; kind = :TitleChanged, title = η.title)
serialref(η::Union{Date, DateTime, Model.Color}, ::iRules)    = "$η"
serialref(η::Union{AbstractString, Number, Symbol}, ::iRules) = η
serialref(η::Union{AbstractVector, AbstractSet}, 𝑅::iRules)   = [serialref(i, 𝑅) for i ∈ η]
serialref(η::AbstractDict, 𝑅::iRules) = Dict((serialref(i, 𝑅) => serialref(j, 𝑅) for (i,j) ∈ η)...)
serialref(η::NamedTuple, 𝑅::iRules) = (; (i => serialref(j, 𝑅) for (i,j) ∈ η)...)
serialref(η::Tuple, 𝑅::iRules) = tuple((serialref(i, 𝑅) for i ∈ η)...)
function serialref(η::T, 𝑅::iRules) where {T}
    return (; (
        i => serialref(Model.bokehrawtype(getproperty(η, i)), 𝑅)
        for i ∈ propertynames(η)
    )...)
end


const SERIAL_ROOTS = Union{Events.iEvent, iHasProps}
serialize(η::AbstractVector{<:SERIAL_ROOTS}, 𝑅 :: iRules) = [serialroot(i, 𝑅) for i ∈ η]
serialize(η::SERIAL_ROOTS,                   𝑅 :: iRules) = serialroot(η, 𝑅)

serialize(x, buffers::Buffers) = serialize(x, BufferedRules(buffers))
serialize(x, ::Nothing)        = serialize(x)
serialize(x)                   = serialize(x, Rules())

export serialize
end
using .Serialize
