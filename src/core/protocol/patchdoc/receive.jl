module PatchDocReceive
using Base64
using ...Model
using ...AbstractTypes
using ..Serialize
using ..Protocol: Buffers

const JSDict       = Dict{String, Any}
const ModelDict    = Dict{Int64, iHasProps}
const _MODEL_TYPES = Dict{Symbol, DataType}()
const _LOCK        = Threads.SpinLock()
const _𝑏_OPTS      = Union{JSDict, Vector}
const _END_PATT    = r"^end" => "finish"

_fieldname(x::String) = Symbol(replace(x, _END_PATT))

getid(𝐼::JSDict) :: Int64 = parse(Int64, 𝐼["id"])

struct _Models
    models   :: ModelDict
    contents :: Vector
    buffers  :: Buffers
end

function createreference!(𝑀::_Models, id::Int, 𝐼::JSDict)
    get!(𝑀.models, id) do
        𝑇 = _MODEL_TYPES[Symbol(𝐼["type"])]
        return 𝑇(;
            id,
            ((
                _fieldname(i) => fromjson(𝑇, _fieldname(i), j, 𝑀)
                for (i, j) ∈ get(𝐼, "attributes", ())
            )...)
        )
    end
end

_knownconversion(_...) = nothing

function _knownconversion(ν::JSDict, 𝑀::_Models)
    return if length(ν) ≡ 1 && first(keys(ν)) == "id"
        fromjson(iHasProps, ν, 𝑀)
    elseif haskey(ν, _𝐵𝐾) ||  haskey(ν, _𝑁𝐾)
        fromjson(Vector, ν, 𝑀)
    else
        nothing
    end
end

function fromjson(𝑇::Type, attr::Symbol, val, 𝑀::_Models)
    out = _knownconversion(val, 𝑀)
    if isnothing(out)
        fromjson(Model.bokehfieldtype(𝑇, attr), val, 𝑀)
    else
        out
    end
end

function fromjson(𝑇::Type, val::JSDict, 𝑀::_Models)
    out = _knownconversion(val, 𝑀)
    return if isnothing(out)
        cnv = Dict((i => fromjson(Any, j, 𝑀) for (i, j) ∈ val)...)
        out = Model.bokehconvert(𝑇, cnv)
        out isa Model.Unknown ? val : out
    else
        out
    end
end

fromjson(::Type, @nospecialize(val::Union{Nothing, String, Number}), ::_Models) = val
fromjson(::Type, @nospecialize(val::Vector), 𝑀::_Models) = [fromjson(Any, i, 𝑀) for i ∈ val]

function fromjson(::Type{<:iHasProps}, val::JSDict, 𝑀::_Models)
    key  = val["id"]
    bkid = parse(Int64, key)
    itm  = get(𝑀.models, bkid, nothing)
    if isnothing(itm)
        createreference!(𝑀, bkid, only(j for j ∈ 𝑀.contents if j["id"] == key))
    else
        itm
    end
end

function fromjson(𝑇::Type{<:Pair}, val::JSDict, 𝑀::_Models)
    @assert length(val) == 1
    (k, v) = first(val)
    return fromjson(𝑇.parameters[1], k, 𝑀) => fromjson(𝑇.parameters[2], v, 𝑀)
end

function fromjson(𝑇::Type{<:AbstractDict}, ν::JSDict, 𝑀::_Models)
    p𝑇 = eltype(𝑇)
    Dict((Pair(fromjson(p𝑇.parameters[1], i, 𝑀), fromjson(p𝑇.parameters[2], j, 𝑀)) for (i, j) ∈ ν)...)
end

function fromjson(𝑇::Type{<:AbstractVector}, ν::JSDict, 𝑀::_Models)
    return if haskey(ν, _𝐵𝐾)
        _reshape(𝑀.buffers[ν[_𝐵𝐾]], ν["dtype"], ν["shape"], ν["order"])
    elseif haskey(ν, _𝑁𝐾)
        _reshape(base64decode(ν[_𝑁𝐾]), ν["dtype"], ν["shape"], ν["order"])
    else
        throw(ErrorException("Unknown message format $𝑇 <= $ν"))
    end
end

function fromjson(𝑇::Type{<:AbstractVector}, ν::Vector, 𝑀::_Models)
    v𝑇 = eltype(𝑇)
    return [fromjson(v𝑇, i, 𝑀) for i ∈ ν]
end

function fromjson(𝑇::Type{<:AbstractSet}, ν::Vector, 𝑀::_Models)
    v𝑇 = eltype(𝑇)
    return Set([fromjson(v𝑇, i, 𝑀) for i ∈ ν])
end

function fromjson(::Type{DataDict}, ν::JSDict, 𝑀::_Models)
    out = DataDict()
    for (i, j) ∈ ν
        arr = Model.datadictarray(fromjson(Vector, j, 𝑀))
        push!(out, i => arr)
    end
    out
end

for (name, action) ∈ (:RootAdded => :push!, :RootRemoved => :delete!)
    @eval function apply(::Val{$(Meta.quot(name))}, 𝐷::iDocument, 𝐼::JSDict, 𝑀::_Models)
        $action(𝐷, fromjson(iHasProps, 𝐼["model"], 𝑀))
    end
end

function apply(::Val{:TitleChanged}, 𝐷::iDocument, 𝐼 :: JSDict, _)
    𝐷.title = 𝐼["title"]
end

function apply(::Val{:ModelChanged}, 𝐷::iDocument, 𝐼::JSDict, 𝑀::_Models)
    mdl  = fromjson(iHasProps, 𝐼["model"], 𝑀)
    attr = _fieldname(𝐼["attr"])
    val  = fromjson(typeof(mdl), attr, 𝐼["new"], 𝑀)
    setproperty!(mdl, attr, val; patchdoc = true)
end

function apply(::Val{:ColumnDataChanged}, 𝐷::iDocument, 𝐼::JSDict, 𝑀::_Models)
    obj  = fromjson(iHasProps, 𝐼["column_source"], 𝑀)
    data = fromjson(DataDict, 𝐼["new"], 𝑀)
    Model.update!(obj.data, data)
end

function apply(::Val{:ColumnsStreamed}, 𝐷::iDocument, 𝐼::JSDict, 𝑀::_Models)
    obj  = fromjson(iHasProps, 𝐼["column_source"], 𝑀)
    data = fromjson(DataDict, 𝐼["data"], 𝑀)
    Model.stream!(obj.data, data; rollover = 𝐼["rollover"])
end

function apply(::Val{:ColumnsPatched}, 𝐷::iDocument, 𝐼::JSDict, _)
    obj  = fromjson(iHasProps, 𝐼["column_source"], 𝑀)
    data = Dict{String, Vector{Pair}}(
        col => Pair[_𝑐𝑝_key(x) => _𝑐𝑝_value(y) for (x, y) ∈ lst]
        for (col, lst) ∈ 𝐼["patches"]
    )
    Model.patch!(obj.data, data)
end

parsereferences(𝐶::Vector, 𝐵::Buffers = Buffers()) = parsereferences!(ModelDict(), 𝐶, 𝐵)

function parsereferences!(𝑀::ModelDict, 𝐶::Vector, 𝐵::Buffers)
    if length(Model.MODEL_TYPES) ≢ length(_MODEL_TYPES)
        𝑅 = Serialize.Rules()
        lock(_LOCK) do
            for cls ∈ Model.MODEL_TYPES
                _MODEL_TYPES[nameof(cls)] = cls
            end
        end
    end

    info = _Models(𝑀, 𝐶, 𝐵)
    for new ∈ 𝐶
        createreference!(info, getid(new), new)
    end
    𝑀
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
    return if length(shape) == 1
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

function patchdoc!(𝐷::iDocument, 𝐶::JSDict, 𝐵::Buffers)
    𝑀    = parsereferences!(bokehmodels(𝐷), 𝐶["references"], 𝐵)
    info = _Models(𝑀, 𝐶["events"], 𝐵)
    for msg ∈ 𝐶["events"]
        apply(Val(Symbol(msg["kind"])), 𝐷, msg, info)
    end
end

const _𝐵𝐾       = "__buffer__"
const _𝑁𝐾       = "__ndarray__"
const _𝑐𝑝_SLICE = AbstractDict{<:AbstractString, <:Union{Nothing, Integer}}

_𝑐𝑝_key(𝑥::Integer)   = 𝑥+1
_𝑐𝑝_key(𝑥::Vector)    = (𝑥[1]+1, _𝑐𝑝_fro(𝑥[2]), _𝑐𝑝_fro(𝑥[3]))
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

export patchdoc!, parsereferences
end
using .PatchDocReceive
