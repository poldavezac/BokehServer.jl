module Deserialize
using Base64
using ...Model
using ...AbstractTypes
using ..Protocol: Buffers

const JSDict       = Dict{String, Any}
const ModelDict    = Dict{Int64, iHasProps}
const _MODEL_TYPES = Dict{Symbol, DataType}()
const _LOCK        = Threads.SpinLock()
const _𝑏_OPTS      = Union{JSDict, Vector}
const _END_PATT    = r"^end" => "finish"

_fieldname(x::String) = Symbol(replace(x, _END_PATT))

getid(𝐼::JSDict) :: Int64 = parse(Int64, 𝐼["id"])

"""
Contains info needed for deserialization.
"""
struct Deserializer
    models   :: ModelDict
    contents :: Vector
    buffers  :: Buffers
end

function _decode_slice(η::JSDict)
    start = let x = get(η, "start", nothing)
        isnothing(x) ? 1 : x + 1
    end,
    step = let x = get(η, "step", nothing)
        isnothing(x) ? 1 : x
    end,
    stop = get(η, "stop", nothing)
    return step ≡ 1 ? (start:stop) :  (start:step:stop)
end

function _decode_object end

function _decode_model(η::JSDict, 𝑅::Deserializer)
    get!(𝑅.models, parse(Int64, η["id"])) do
        return _MODEL_TYPES[Symbol(𝐼["name"])](;
            id,
            ((
                _fieldname(i) => deserialize(𝑇, _fieldname(i), j, 𝑅)
                for (i, j) ∈ get(𝐼, "attributes", ())
            )...)
        )
    end
end

function deserialize(@nospecialize(η), 𝑅::Deserializer)
    return if η isa Vector{Any}
        [deserialize(i, 𝑅) for i ∈ η]
    elseif η isa Union{String, Number, Nothing}
        η
    elseif η isa JSDict
        tpe = get(η, "type", missing)

        if ismissing(tpe) && haskey(η, "id")
            _decode_model(η, 𝑅)
        elseif ismissing(tpe)
            JSDict(i => deserialize(j, 𝑅) for (i, j) ∈ η)
        elseif tpe == "number"
            val = η["value"]
            val == "nan" ? NaN64 : val == "-inf" ? -Inf64 : Inf64
        elseif tpe == "ref"
            key = parse(Int64, η["id"])
            haskey(𝑅.models, key) ? 𝑅.models[key] : 𝑅.buffers[key]
        elseif tpe ∈ ("value", "field", "expr")
            Dict{Symbol, Any}(Symbol(i) => deserialize(j, 𝑅) for (i, j) ∈ η if i != "type")
        elseif tpe == "slice"
            _decode_slice(η)
        elseif tpe == "map"  
            JSDict(i => deserialize(j, 𝑅) for (i, j) ∈ η if i != "type")
        elseif tpe == "set"
            Set(deserialize(i, 𝑅) for i ∈ η["entries"])
        elseif tpe == "object"  
            haskey(η, "id") ? _decode_model(η, 𝑅) : _decode_object(η, 𝑅)
        elseif tpe == "bytes"
            data = η["data"]
            data isa String ? base64decode(data) : data isa Vector ? collect(data) : 𝑅.buffers[data["id"]]
        elseif tpe == "typed_array"
            _reshape(deserialize(η["array"], 𝑅), η["dtype"], Any[], η["order"])
        elseif tpe == "ndarray"
            _reshape(deserialize(η["array"], 𝑅), η["dtype"], η["shape"], η["order"])
        end

        val = JSDict(i => deserialize(j, 𝑅) for (i, j) ∈ η)
    end
end


_knownconversion(_...) = nothing

function _knownconversion(ν::JSDict, 𝑅::Deserializer)
    return if length(ν) ≡ 1 && first(keys(ν)) == "id"
        deserialize(iHasProps, ν, 𝑅)
    elseif haskey(ν, _𝐵𝐾) ||  haskey(ν, _𝑁𝐾)
        deserialize(Vector, ν, 𝑅)
    else
        nothing
    end
end

function deserialize(𝑇::Type, attr::Symbol, val, 𝑅::Deserializer)
    @nospecialize 𝑇 val
    out = _knownconversion(val, 𝑅)
    if isnothing(out)
        deserialize(Model.bokehfieldtype(𝑇, attr), val, 𝑅)
    else
        out
    end
end

function deserialize(@nospecialize(𝑇::Type), val::JSDict, 𝑅::Deserializer)
    out = _knownconversion(val, 𝑅)
    return if isnothing(out)
        cnv = Dict((i => deserialize(Any, j, 𝑅) for (i, j) ∈ val)...)
        out = Model.bokehconvert(𝑇, cnv)
        out isa Model.Unknown ? val : out
    else
        out
    end
end

deserialize(::Type, @nospecialize(val::Union{Nothing, String, Number}), ::Deserializer) = val
deserialize(::Type, @nospecialize(val::Vector), 𝑅::Deserializer) = [deserialize(Any, i, 𝑅) for i ∈ val]

function deserialize(::Type{<:iHasProps}, val::JSDict, 𝑅::Deserializer)
    key  = val["id"]
    bkid = parse(Int64, key)
    itm  = get(𝑅.models, bkid, nothing)
    if isnothing(itm)
        createreference!(𝑅, bkid, only(j for j ∈ 𝑅.contents if j["id"] == key))
    else
        itm
    end
end

function deserialize(@nospecialize(𝑇::Type{<:Pair}), val::JSDict, 𝑅::Deserializer)
    @assert length(val) == 1
    (k, v) = first(val)
    return deserialize(𝑇.parameters[1], k, 𝑅) => deserialize(𝑇.parameters[2], v, 𝑅)
end

function deserialize(@nospecialize(𝑇::Type{<:AbstractDict}), ν::JSDict, 𝑅::Deserializer)
    p𝑇 = eltype(𝑇)
    Dict((Pair(deserialize(p𝑇.parameters[1], i, 𝑅), deserialize(p𝑇.parameters[2], j, 𝑅)) for (i, j) ∈ ν)...)
end

function deserialize(@nospecialize(𝑇::Type{<:AbstractVector}), ν::JSDict, 𝑅::Deserializer)
    return if haskey(ν, _𝐵𝐾)
        _reshape(𝑅.buffers[ν[_𝐵𝐾]], ν["dtype"], ν["shape"], ν["order"])
    elseif haskey(ν, _𝑁𝐾)
        _reshape(base64decode(ν[_𝑁𝐾]), ν["dtype"], ν["shape"], ν["order"])
    else
        throw(ErrorException("Unknown message format $𝑇 <= $ν"))
    end
end

function deserialize(𝑇::Type{<:AbstractVector}, ν::Vector, 𝑅::Deserializer)
    v𝑇 = eltype(𝑇)
    return [deserialize(v𝑇, i, 𝑅) for i ∈ ν]
end

function deserialize(𝑇::Type{<:AbstractSet}, ν::Vector, 𝑅::Deserializer)
    v𝑇 = eltype(𝑇)
    return Set([deserialize(v𝑇, i, 𝑅) for i ∈ ν])
end

function deserialize(::Type{DataDict}, ν::JSDict, 𝑅::Deserializer)
    out = DataDict()
    for (i, j) ∈ ν
        arr = Model.datadictarray(deserialize(Vector, j, 𝑅))
        push!(out, i => arr)
    end
    out
end

for (name, action) ∈ (:RootAdded => :push!, :RootRemoved => :delete!)
    @eval function apply(::Val{$(Meta.quot(name))}, 𝐷::iDocument, 𝐼::JSDict, 𝑅::Deserializer)
        $action(𝐷, deserialize(iHasProps, 𝐼["model"], 𝑅))
    end
end

function apply(::Val{:TitleChanged}, 𝐷::iDocument, 𝐼 :: JSDict, ::Deserializer)
    𝐷.title = 𝐼["title"]
end

function apply(::Val{:ModelChanged}, 𝐷::iDocument, 𝐼::JSDict, 𝑅::Deserializer)
    mdl  = deserialize(iHasProps, 𝐼["model"], 𝑅)
    attr = _fieldname(𝐼["attr"])
    val  = deserialize(typeof(mdl), attr, 𝐼["new"], 𝑅)
    setproperty!(mdl, attr, val; patchdoc = true)
end

function apply(::Val{:ColumnDataChanged}, 𝐷::iDocument, 𝐼::JSDict, 𝑅::Deserializer)
    obj  = deserialize(iHasProps, 𝐼["column_source"], 𝑅)
    data = deserialize(DataDict, 𝐼["new"], 𝑅)
    Model.update!(obj.data, data)
end

function apply(::Val{:ColumnsStreamed}, 𝐷::iDocument, 𝐼::JSDict, 𝑅::Deserializer)
    obj  = deserialize(iHasProps, 𝐼["column_source"], 𝑅)
    data = deserialize(DataDict, 𝐼["data"], 𝑅)
    Model.stream!(obj.data, data; rollover = 𝐼["rollover"])
end

function apply(::Val{:ColumnsPatched}, 𝐷::iDocument, 𝐼::JSDict, 𝑅::Deserializer)
    obj  = deserialize(iHasProps, 𝐼["column_source"], 𝑅)
    data = Dict{String, Vector{Pair}}(
        col => Pair[_𝑐𝑝_key(x) => _𝑐𝑝_value(y) for (x, y) ∈ lst]
        for (col, lst) ∈ 𝐼["patches"]
    )
    Model.patch!(obj.data, data)
end

"""
    deserialize!(𝐷::iDocument, 𝐶::JSDict, 𝐵::Buffers)

Uses data extracted from websocket communication to update a document.
"""
function deserialize!(𝐷::iDocument, 𝐶::JSDict, 𝐵::Buffers)
    if length(Model.MODEL_TYPES) ≢ length(_MODEL_TYPES)
        lock(_LOCK) do
            for cls ∈ Model.MODEL_TYPES
                _MODEL_TYPES[nameof(cls)] = cls
            end
        end
    end

    for evts ∈ deserialize(𝐶, Deserializer(𝐷, 𝐵))
        apply!(𝐷, evts)
    end
end


function _reshape(data::Union{Vector{Int8}, Vector{UInt8}}, dtype::String, shape::Vector{Any}, order::String)
    arr = reinterpret(
        let tpe = dtype
            tpe == "uint8"   ? UInt8   : tpe == "uint16"  ? UInt16  : tpe == "uint32" ? UInt32 :
            tpe == "int8"    ? Int8    : tpe == "int16"   ? Int16   : tpe == "int32"  ? Int32  :
            tpe == "float32" ? Float32 : tpe == "float64" ? Float64 : throw(ErrorException("Unknown type $tpe"))
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

const _𝐵𝐾       = "__buffer__"
const _𝑁𝐾       = "__ndarray__"
const _𝑐𝑝_SLICE = AbstractDict{<:AbstractString, <:Union{Nothing, Integer}}

_𝑐𝑝_key(𝑥::Integer)   = 𝑥+1
_𝑐𝑝_key(@nospecialize(𝑥::Vector)) = (𝑥[1]+1, _𝑐𝑝_fro(𝑥[2]), _𝑐𝑝_fro(𝑥[3]))
_𝑐𝑝_key(𝑥::_𝑐𝑝_SLICE) =  (;
    start = let x = get(𝑥, "start", nothing)
        isnothing(x) ? 1 : x + 1
    end,
    step = let x = get(𝑥, "step", nothing)
        isnothing(x) ? 1 : x
    end,
    stop = get(𝑥, "stop", nothing)
)

_𝑐𝑝_value(@nospecialize(x::Union{Number, String, iHasProps, AbstractVector{<:Number}})) = x
_𝑐𝑝_value(@nospecialize(x::AbstractVector{Int64})) = collect(Int32, x)
_𝑐𝑝_value(x::Vector{Any}) = collect((i for i ∈ x))

export deserialize!
end
using .Deserialize
