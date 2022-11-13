module Decoding
using Base64
using DataStructures
using ...Model
using ...AbstractTypes
using ..Events
using ..Protocol: Buffers

const _MODEL_TYPES = Dict{String, DataType}()
const _LOCK        = Threads.SpinLock()
const _𝑏_OPTS      = Union{AbstractDict, Vector}
const _👻Simple    = Union{AbstractString, Number, Nothing}

@inline _fieldname(x::String)::Symbol = Symbol(startswith(x, "end") ? string("finish", x[4:end]) : x)

getid(η::AbstractDict) :: Int64 = parse(Int64, η["id"])

"""
Contains info needed for deserialization.
"""
struct Decoder
    references :: Dict{String, Any}
    doc:: iDocument
end

struct PushDocInfo
    roots :: Vector{iHasProps}
    title :: String
end

struct EventsInfo
    events :: Vector{Events.iEvent}
end

"""
    deserialize!(𝐷::iDocument, 𝐶::AbstractDict, 𝐵::Buffers)

Uses data extracted from websocket communication to update a document.
"""
function deserialize!(𝐷::iDocument, 𝐶::AbstractDict, 𝐵::Buffers)
    data = _decode(𝐶, 𝐷, 𝐵)
    if data.type ≡ :doc
        𝐷.title = data.title
        empty!(𝐷)
        push!(𝐷, data.roots...)
    elseif data.type ≡ :events
        foreach(Base.Fix1(_apply!, 𝐷), data.events)
        return data.events
    else
        throw(BokehException("Unknown decoding type $(data.type)"))
    end
    return Events.iEvent[]
end

decodefield(::Type, ::Symbol, @nospecialize(η)) = η

"""
    _decode(𝐶::AbstractDict, 𝐷::iDocument, 𝐵::Buffers)

Convert a message to bokeh objects
"""
function _decode(𝐶::AbstractDict, 𝐷::iDocument, 𝐵::Buffers)
    if length(Model.MODEL_TYPES) ≢ length(_MODEL_TYPES)
        lock(_LOCK) do
            for cls ∈ Model.MODEL_TYPES
                _MODEL_TYPES[string(nameof(cls))] = cls
            end
        end
    end

    𝑅 = Decoder(
        Dict{String, Any}(𝐵..., ("$i" => j for (i, j) ∈ Model.bokehmodels(𝐷))...),
        𝐷
    )
    return if haskey(𝐶, "doc")
        (;
           roots = iHasProps[decode(i, 𝑅) for i ∈ 𝐶["doc"]["roots"]],
           title = string(𝐶["doc"]["title"]),
           type  = :doc
        )
    else
        (; events = Events.iEvent[decode(i, 𝑅) for i ∈ 𝐶["events"]], type = :events)
    end
end

@inline function _𝑑𝑒𝑐_number(η::AbstractDict, ::Decoder)
    val = η["value"]
    return val == "nan" ? NaN64 : val == "-inf" ? -Inf64 : Inf64
end

@inline _𝑑𝑒𝑐_value(η::AbstractDict, 𝑅::Decoder)        = Dict{Symbol, Any}(Symbol(i) => decode(j, 𝑅) for (i, j) ∈ η)
@inline _𝑑𝑒𝑐_field(η::AbstractDict, 𝑅::Decoder)        = Dict{Symbol, Any}(Symbol(i) => decode(j, 𝑅) for (i, j) ∈ η)
@inline _𝑑𝑒𝑐_expr(η::AbstractDict, 𝑅::Decoder)         = Dict{Symbol, Any}(Symbol(i) => decode(j, 𝑅) for (i, j) ∈ η)
@inline _𝑑𝑒𝑐_map(η::AbstractDict, 𝑅::Decoder)          = Dict(i => decode(j, 𝑅) for (i, j) ∈ η["entries"])
@inline _𝑑𝑒𝑐_set(η::AbstractDict, 𝑅::Decoder)          = Set(decode(j, 𝑅) for j ∈ η)
@inline _𝑑𝑒𝑐_typed_array(η::AbstractDict, 𝑅::Decoder)  = _reshape(decode(η["array"], 𝑅), η["dtype"], Any[], η["order"])
@inline _𝑑𝑒𝑐_ndarray(η::AbstractDict, 𝑅::Decoder)      = _reshape(decode(η["array"], 𝑅), η["dtype"], η["shape"], η["order"])
@inline _𝑑𝑒𝑐_object(η::AbstractDict, 𝑅::Decoder)       = haskey(η, "id") ? _𝑑𝑒𝑐_model(η, 𝑅) : _𝑑𝑒𝑐_data(η, 𝑅)

function _𝑑𝑒𝑐_data end

@inline function _𝑑𝑒𝑐_model(η::AbstractDict, 𝑅::Decoder)
    get!(𝑅.references, η["id"]) do
        id = parse(Int64, η["id"])
        𝑇  = _MODEL_TYPES[η["name"]]
        return 𝑇(;
            id,
            ((
                let fname = _fieldname(i)
                    fname => decodefield(𝑇, fname, decode(j, 𝑅))
                end
                for (i, j) ∈ get(η, "attributes", ())
            )...)
        )
    end
end

@inline function _𝑑𝑒𝑐_bytes(η::AbstractDict, 𝑅::Decoder)
    data = η["data"]
    data isa String ? base64decode(data) : data isa Vector ? collect(data) : 𝑅.references[data["id"]]
end

@inline function _𝑑𝑒𝑐_slice(η::AbstractDict)
    start = let x = get(η, "start", nothing)
        isnothing(x) ? 1 : x + 1
    end
    step = let x = get(η, "step", nothing)
        isnothing(x) ? 1 : x
    end
    stop = get(η, "stop", nothing)
    return step ≡ 1 ? (start:stop) :  (start:step:stop)
end

_𝑑𝑒𝑐_titlechanged(η::AbstractDict, 𝑅::Decoder) = Events.TitleChangedEvent(𝑅.doc, η["title"])
_apply!(𝐷::iDocument, η::Events.TitleChangedEvent) = 𝐷.title = η.title

for (𝑇, 𝐹) ∈ (:RootAddedEvent => push!, :RootRemovedEvent => delete!)
    @eval begin
        $(𝑇 ≡ :RootAddedEvent ? :_𝑑𝑒𝑐_rootadded : :_𝑑𝑒𝑐_rootremoved)(
            η::AbstractDict, 𝑅::Decoder
        ) = Events.$𝑇(𝑅.doc, _𝑑𝑒𝑐_model(η["model"], 𝑅), -1)
        _apply!(𝐷::iDocument, η::Events.$𝑇) = $𝐹(𝐷, η.root)
    end
end

function _𝑑𝑒𝑐_modelchanged(η::AbstractDict, 𝑅::Decoder)
    mdl  = decode(η["model"], 𝑅)
    attr = _fieldname(η["attr"])
    val  = decodefield(typeof(mdl), attr, decode(η["new"], 𝑅))
    old  = Model.bokehunwrap(getproperty(mdl, attr))
    Events.ModelChangedEvent(mdl, attr, old, val)
end
_apply!(::iDocument, η::Events.ModelChangedEvent) = setproperty!(η.model, η.attr, η.new; patchdoc = true)

@inline function _data(η::AbstractDict, 𝑅::Decoder)
    return Model.bokehconvert(
        Model.DataDict, 
        Dict{String, AbstractVector}(pairs(decode(η["data"], 𝑅))...)
    )
end

@inline function _patch_key(𝑥)
    return if 𝑥 isa Integer
        𝑥+1
    elseif 𝑥 isa Vector
        (length(𝑥) ≡ 3) || throw(BokehException("Could not decode key $x::$(typeof(x))"))
        (𝑥[1]+1, _patch_key(𝑥[2]), _patch_key(𝑥[3]))
    else
        (x isa AbstractRange) || throw(BokehException("Could not decode key $x::$(typeof(x))"))
        x
    end
end

function _𝑑𝑒𝑐_columnspatched(η::AbstractDict, 𝑅::Decoder)
    return Events.ColumnsPatchedEvent(
        decode(η["model"], 𝑅), Symbol(η["attr"]),
        Dict{String, Vector{Pair}}(
            col => Pair[_patch_key(i) => collect(j) for (i, j) ∈ lst]
            for (col, lst) ∈ decode(η["patches"], 𝑅)
        )
    )
end
function _apply!(𝐷::iDocument, η::Events.ColumnsPatchedEvent)
    Model.patch!(getproperty(η.model, η.attr), η.patches)
end

function _𝑑𝑒𝑐_columnsstreamed(η::AbstractDict, 𝑅::Decoder)
    return Events.ColumnsStreamedEvent(
        decode(η["model"], 𝑅), Symbol(η["attr"]),
        _data(η, 𝑅), decode(η["rollover"], 𝑅)
    )
end
function _apply!(𝐷::iDocument, η::Events.ColumnsStreamedEvent)
    Model.stream!(getproperty(η.model, η.attr), η.data; η.rollover)
end

function _𝑑𝑒𝑐_columndatachanged(η::AbstractDict, 𝑅::Decoder)
    return Events.ColumnDataChangedEvent(
        decode(η["model"], 𝑅), Symbol(η["attr"]), _data(η, 𝑅)
    )
end
function _apply!(𝐷::iDocument, η::Events.ColumnDataChangedEvent)
    Model.update!(getproperty(η.model, η.attr), η.data)
end

function _reshape(data::Union{Vector{Int8}, Vector{UInt8}}, dtype::String, shape::Vector{Any}, order::String)
    arr = reinterpret(
        let tpe = dtype
            tpe == "uint8"   ? UInt8   : tpe == "uint16"  ? UInt16  : tpe == "uint32" ? UInt32 :
            tpe == "int8"    ? Int8    : tpe == "int16"   ? Int16   : tpe == "int32"  ? Int32  :
            tpe == "float32" ? Float32 : tpe == "float64" ? Float64 : throw(BokehException("Unknown type $tpe"))
        end,
        data
    )
    if order ≡ "little" && Base.ENDIAN_BOM ≡ 0x01020304
        arr = ltoh.(arr)
    elseif order ≡ "big" && Base.ENDIAN_BOM ≡ 0x04030201
        arr = htol.(arr)
    end
    return if isempty(shape) || length(shape) == 1
        arr
    else
        sz  = tuple(shape[2:end]...)
        len = prod(sz)
        [
            reshape(view(arr, i:i+len-1), sz)
            for i ∈ 1:len:length(arr)
        ]
    end
end

# creating a static dispatch of all `_𝑑𝑒𝑐_` methods
@eval function decode(@nospecialize(η), 𝑅::Decoder)
    if η isa _👻Simple
        return η
    elseif η isa Vector{Any}
        return [decode(i, 𝑅) for i ∈ η]
    elseif η isa AbstractDict
        tpe = let x = pop!(η, "type", missing)
            ismissing(x) && (x = pop!(η, "kind", missing))
            ismissing(x) ? missing : lowercase(x)
        end

        $(let expr = :(if ismissing(tpe)
                haskey(η, "id") ? _𝑑𝑒𝑐_object(η, 𝑅) : Dict{String, Any}(i => decode(j, 𝑅) for (i, j) ∈ η)
            else
                decode(Val(Symbol(tpe)), η, 𝑅)
            end)
            last = expr
            for name ∈ names(@__MODULE__; all = true)
                key  = "$name"
                startswith(key, "_𝑑𝑒𝑐_") || continue
                last = last.args[end] = Expr(:elseif, :(tpe == $(split(key, '_')[end])), :($name(η, 𝑅)), last.args[end])
            end
            expr
        end)
    else
        throw(BokehException("Can't decode $η"))
    end
end
end
using .Decoding: deserialize!
