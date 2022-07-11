module Serialize
using Dates
using Base64
using ..AbstractTypes
using ...Model
using ...Events
using ..Protocol: Buffers

const RT  = Dict{Symbol, Any}

abstract type iRules end

"Specifies module specific rules for json serialization"
struct Rules <: iRules end

"Specifies module specific rules for json serialization with buffers"
struct BufferedRules <: iRules
    buffers :: Buffers
    BufferedRules() = new(Buffers(undef, 0)) 
end

const _END_PATT = r"^finish" => "end"
_fieldname(x::Symbol) :: Symbol = Symbol(replace("$x", _END_PATT))

function serialattributes(η::iHasProps, 𝑅::iRules) :: RT
    @nospecialize η 𝑅
    return RT((
        _fieldname(i) => serialref(j, Model.bokehunwrap(getproperty(η, i)), 𝑅)
        for (i, j) ∈ Model.bokehfields(typeof(η))
        if !Model.isdefaultvalue(η, i)
    )...)
end

function serialroot(η::iHasProps, 𝑅::iRules) :: RT
    @nospecialize η 𝑅
    return RT(
        :attributes => serialattributes(η, 𝑅),
        :id         => "$(bokehid(η))",
        :type       => nameof(typeof(η)),
    )
end

serialroot(@nospecialize(η::Events.iEvent), @nospecialize(𝑅::iRules)) ::RT  = serialref(η, 𝑅)

function serialref(p𝑇::Type{<:Model.iSpec}, η, 𝑅::iRules) :: RT
    @nospecialize p𝑇 η 𝑅
    serialref(Model.todict(Model.bokehconvert(p𝑇, η)), 𝑅)
end
serialref(::Type, @nospecialize(η), @nospecialize(𝑅::iRules))            = serialref(η, 𝑅)
serialref(@nospecialize(η::iHasProps), ::iRules)              :: RT      = RT(:id => "$(bokehid(η))")
serialref(::Nothing, ::iRules)                                :: Nothing = nothing
serialref(@nospecialize(η::Model.EnumType), ::iRules)         :: String  = "$(η.value)"

for cls ∈ (:RootAddedEvent, :RootRemovedEvent)
    @eval function serialref(η::$cls, 𝑅::iRules) :: RT
        return RT(
            :kind  => $(Meta.quot(Symbol(string(cls)[1:end-5]))),
            :model => serialref(η.root, 𝑅)
        )
    end
end

serialref(η::Events.ModelChangedEvent, 𝑅::iRules) :: RT = serialref(typeof(η.model), η, 𝑅)
function serialref(::Type, η::Events.ModelChangedEvent, 𝑅::iRules) :: RT
    return RT(
        :attr  => _fieldname(η.attr),
        :hint  => nothing,
        :kind  => :ModelChanged,
        :model => serialref(η.model, 𝑅),
        :new   => serialref(
            Model.bokehfieldtype(typeof(η.model), η.attr),
            Model.bokehunwrap(η.new),
            𝑅
        ),
    )
end

# warning : we're going to javascript, thus the ranges start at 0...
serialref(x::OrdinalRange, ::iRules) :: RT = RT(:start => first(x)-1, :step => 1, :stop => last(x))
serialref(x::StepRangeLen, ::iRules) :: RT = RT(:start => first(x)-1, :step => step(x), :stop => last(x))
_𝑐𝑝_to(x::AbstractRange, 𝑅::iRules) :: RT    = serialref(x, 𝑅)
_𝑐𝑝_to(x::Integer,        ::iRules) :: Int64 = Int64(x)-1
_𝑐𝑝_to(x::Tuple{<:Integer, <:Any, <:Any}, 𝑅::iRules) = (x[1]-1, _𝑐𝑝_to(x[2], 𝑅), _𝑐𝑝_to(x[3], 𝑅))

function serialref(η::Events.ColumnsPatchedEvent, 𝑅::iRules) :: RT
    return RT(
        :column_source => serialref(η.model, 𝑅),
        :kind          => :ColumnsPatched,
        :patches       => Dict{String, Vector}(
            k => [(_𝑐𝑝_to(i, 𝑅), j) for (i, j) ∈ v]
            for (k, v) ∈ η.patches
        )
    )
end

function serialref(η::Events.ColumnsStreamedEvent, 𝑅::iRules) :: RT
    return RT(
        :column_source => serialref(η.model, 𝑅),
        :data          => serialref(η.data, 𝑅),
        :kind          => :ColumnsStreamed,
        :rollover      => serialref(η.rollover, 𝑅)
    )
end

function serialref(η::Events.ColumnDataChangedEvent, ::iRules) :: RT
    𝑅   = Rules()
    new = serialref(Model.DataDictContainer, η.data, 𝑅)
    return RT(
        :cols          => serialref(collect(keys(η.data)), 𝑅),
        :column_source => serialref(η.model, 𝑅),
        :kind          => :ColumnDataChanged,
        :new           => new
    )
end

function serialref(η::Events.iActionEvent, 𝑅::iRules) :: RT
    @nospecialize η 𝑅
    return RT(
        :kind     => :MessageSent,
        :msg_data => RT(
            :event_name   => η.event_name,
            :event_values => RT((i => serialref(getfield(η, i), 𝑅) for i ∈ fieldnames(typeof(η)) if i ≢ :doc)...),
        ),
        :msg_type => :bokeh_event,
    )
end

const _𝑑𝑠_ID    = bokehidmaker()
const _𝑑𝑠_BIN   = Union{(AbstractVector{i} for i ∈ AbstractTypes.NumberElTypeDataDict)...}
const _𝑑𝑠_NDBIN = Union{(AbstractVector{<:AbstractArray{i}} for i ∈ AbstractTypes.NumberElTypeDataDict)...} 

_𝑑𝑠_to(𝑑::AbstractVector, ::iRules)        = 𝑑
_𝑑𝑠_to(𝑑::AbstractVector, ::BufferedRules) = 𝑑

for (R, code) ∈ (
        Rules           => :(:__ndarray__ => String(base64encode(𝑑))),
        BufferedRules   => :(:__buffer__  => let id = "$(_𝑑𝑠_ID())"
            push!(𝑅.buffers, id => reinterpret(UInt8, 𝑑))
            id
        end)
)
    @eval function _𝑑𝑠_to(𝑑::_𝑑𝑠_BIN, 𝑅::$R) :: RT
        isempty(𝑑) && return 𝑑
        return RT(
            $code,
            :dtype => lowercase("$(nameof(eltype(𝑑)))"),
            :order => Base.ENDIAN_BOM ≡ 0x04030201 ? :little : :big,
            :shape => size(𝑑),
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

function serialref(::Type{Model.DataDictContainer}, 𝑑::DataDict, 𝑅::iRules) :: Dict{String, Union{Vector, RT}}
    return Dict{String, Union{Vector, RT}}(k => _𝑑𝑠_to(v, 𝑅) for (k, v) ∈ 𝑑)
end

serialref(@nospecialize(η::TitleChangedEvent), 𝑅::iRules)    :: RT     = RT(:kind => :TitleChanged, :title => η.title)
serialref(@nospecialize(η::Union{Date, DateTime}), ::iRules) :: String = "$η"
serialref(@nospecialize(η::Model.Color), ::iRules)           :: String = "$(Model.colorhex(η))"
serialref(@nospecialize(η::Union{AbstractString, Number, Symbol}), ::iRules) = η
serialref(@nospecialize(η::Union{AbstractVector, AbstractSet}), 𝑅::iRules)   = [serialref(i, 𝑅) for i ∈ η]
serialref(@nospecialize(η::AbstractDict), 𝑅::iRules) :: Dict  = Dict((serialref(i, 𝑅) => serialref(j, 𝑅) for (i,j) ∈ η)...)
serialref(@nospecialize(η::NamedTuple), 𝑅::iRules)   :: RT    = RT((i => serialref(j, 𝑅) for (i,j) ∈ pairs(η))...)
serialref(@nospecialize(η::Tuple), 𝑅::iRules)        :: Tuple = tuple((serialref(i, 𝑅) for i ∈ η)...)
function serialref(η::Any, 𝑅::iRules) :: RT
    @nospecialize η 𝑅
    return RT((
        i => serialref(Model.bokehunwrap(getproperty(η, i)), 𝑅)
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
for 𝑅 ∈ (Rules, BufferedRules)
    precompile(serialroot, (iHasProps, 𝑅))
    for 𝑇 ∈ (
            iHasProps, ModelChangedEvent, RootAddedEvent, RootRemovedEvent,
            ColumnDataChangedEvent, ColumnsStreamedEvent, ColumnsPatchedEvent,
            AbstractVector, AbstractDict, NamedTuple, Tuple, Events.iActionEvent,
    )
        precompile(serialref,  (𝑇, 𝑅))
    end
end
end
using .Serialize
