module Serialize
using Dates
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

function serialattributes(η::T, 𝑅::iRules) where {T <: iHasProps}
    return (;(
        i => serialref(j, Model.bokehrawtype(getproperty(η, i)), 𝑅)
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
        attr  = η.attr,
        hint  = nothing,
        kind  = :ModelChanged,
        model = serialref(η.model, 𝑅),
        new   = serialref(η.new, 𝑅),
    )
end

# warning : we're going to javascript, thus the ranges start at 0...
serialref(x::OrdinalRange, ::iRules) = (; start = first(x)-1, step = 1,       stop = last(x))
serialref(x::StepRangeLen, ::iRules) = (; start = first(x)-1, step = step(x), stop = last(x))

function serialref(η::Events.ColumnsPatchedEvent, 𝑅::iRules)
    return (;
        column_source = serialref(η.model, 𝑅),
        kind          = :ColumnsPatched,
        patches       = Dict{String, Vector}(
            k => [(serialref(i, 𝑅), j) for (i, j) ∈ v]
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
    return (;
        cols          = serialref(collect(keys(η.data)), 𝑅),
        column_source = serialref(η.model, 𝑅),
        kind          = :ColumnDataChanged,
        new           = serialref(Model.DataSource, η.data, 𝑅)
    )
end

const _𝑑𝑠_ID  = bokehidmaker()
const _𝑑𝑠_BIN = Union{(
    AbstractVector{i}
    for i ∈ (UInt8, Int8, UInt16, Int16, UInt32, Int32, Float32, Float64)
)...}

for (R, code) ∈ (
        iRules          => :(__ndarray__ = String(base64encode(arr))),
        BufferedRules   => :(__buffer__  = let id = "$(_𝑑𝑠_ID())"
            push!(𝑅.buffers, id => reinterpret(Int8, 𝑑))
            id
        end)
)
    @eval function _𝑑𝑠_to(𝑑::_𝑑𝑠_BIN, 𝑅::$R)
        return (;
            $(Expr(:kw, code.args...)),
            dtype = lowercase("$(nameof(eltype(𝑑)))"),
            order = Base.ENDIAN_BOM ≡ 0x04030201 ? :little : :big,
            shape = size(array),
        )
    end
end

for (T, code) ∈ (
        TimePeriod => :(Dates.toms.(𝑑)),
        DateTime   => :(Int64.(round.(1e3 .* Dates.datetime2unix.(𝑑)))),
        Date       => :(Dates.toms.(Day.(Dates.date2epochdays.(𝑑))))
)
    @eval _𝑑𝑠_to(𝑑::AbstractVector{$T}, 𝑅::iRules) = _𝑑𝑠_to($code, 𝑅)
end

function serialref(::Type{Model.DataSource}, 𝑑::Dict{String, AbstractVector}, 𝑅::iRules)
    return Dict{String, Union{Vector, NamedTuple}}(k => _𝑑𝑠_to(v) for (k, v) ∈ 𝑑)
end

serialref(η::TitleChangedEvent, 𝑅::iRules) = (; kind = :TitleChanged, title = η.title)
serialref(η::Union{Date, DateTime, Model.Color}, ::iRules)    = "$η"
serialref(η::Union{AbstractString, Number, Symbol}, ::iRules) = η
serialref(η::Union{AbstractVector, AbstractSet}, 𝑅::iRules)   = [serialref(i, 𝑅) for i ∈ η]
serialref(η::AbstractDict, 𝑅::iRules) = Dict((serialref(i, 𝑅) => serialref(j, 𝑅) for (i,j) ∈ η)...)
serialref(η::NamedTuple, 𝑅::iRules) = (; (i => serialref(j, 𝑅) for (i,j) ∈ η)...)
function serialref(η::T, 𝑅::iRules) where {T}
    return (; (
        i => serialref(Bokeh.bokehrawtype(getproperty(η, i)), 𝑅)
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
