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

function createreference!(𝑀::ModelDict, 𝐶::Vector, id::Int, 𝐼::JSDict)
    get!(𝑀, id) do
        createreference(_MODEL_TYPES[Symbol(𝐼["type"])], id, 𝐼, 𝑀, 𝐶)
    end
end

function createreference(
        @nospecialize(𝑇::Type{<:iHasProps}),
        id::Int,
        𝐼::Dict{String, Any},
        𝑀::ModelDict,
        𝐶::Vector
)
    return 𝑇(;
        id,
        ((
            Symbol(i) => let key = j["id"], bkid = parse(Int64, key)
                itm = get(𝑀, bkid, nothing)
                if isnothing(itm)
                    createreference!(𝑀, 𝐶, bkid, only(j for j ∈ 𝐶 if j["id"] == key))
                else
                    itm
                end
            end
            for (i, j) ∈ get(𝐼, "attributes", ())
            if _𝑐𝑝_isamodel(j)
        )...)
    )
end

fromjson(::Type, val) = val

fromjson(::Type{<:iHasProps}, val::iHasProps) = val

function fromjson(::Type{<:Pair}, val::Dict)
    @assert length(val) == 1
    (k, v) = first(val)
    return fromjson(T.parameters[1], k) => fromjson(T.parameters[2], v)
end

function fromjson(
        𝑇 :: Type{<:Union{AbstractDict, AbstractSet, AbstractVector}},
        𝑣 :: Union{Dict, Vector},
)
    return 𝑇([fromjson(eltype(𝑇), i) for i ∈ 𝑣])
end

function fromjson(::Type{DataDict}, 𝑣::JSDict)
    out = DataDict()
    for (i, j) ∈ 𝑣
        arr = _𝑐𝑝_value(j)
        push!(out, i => arr)
    end
    out
end

function setpropertyfromjson!(mdl::iHasProps, attr:: Symbol, val; dotrigger ::Bool =true)
    @nospecialize mdl attr val
    setproperty!(mdl, attr, fromjson(Model.bokehfieldtype(typeof(mdl), attr), val); dotrigger, patchdoc = true)
end

function setreferencefromjson!(mdl::iHasProps, 𝐼::JSDict)
    @nospecialize mdl 𝐼
    for (key, val) ∈ 𝐼["attributes"]
        setpropertyfromjson!(mdl, _fieldname(key), val; dotrigger = false)
    end
end

for (name, action) ∈ (:RootAdded => :push!, :RootRemoved => :delete!)
    @eval function apply(::Val{$(Meta.quot(name))}, 𝐷::iDocument, 𝐼::JSDict)
        $action(𝐷, 𝐼["model"])
    end
end

function apply(::Val{:TitleChanged}, 𝐷::iDocument, 𝐼 :: JSDict)
    𝐷.title = 𝐼["title"]
end

function apply(::Val{:ModelChanged}, 𝐷::iDocument, 𝐼::JSDict)
    setpropertyfromjson!(𝐼["model"], _fieldname(𝐼["attr"]), 𝐼["new"])
end

function apply(::Val{:ColumnDataChanged}, 𝐷::iDocument, 𝐼::JSDict)
    Model.update!(𝐼["column_source"].data, fromjson(DataDict, 𝐼["new"]))
end

function apply(::Val{:ColumnsStreamed}, 𝐷::iDocument, 𝐼::JSDict)
    Model.stream!(𝐼["column_source"].data, fromjson(DataDict, 𝐼["data"]); rollover = 𝐼["rollover"])
end

function apply(::Val{:ColumnsPatched}, 𝐷::iDocument, 𝐼::JSDict)
    Model.patch!(
        𝐼["column_source"].data,
        Dict{String, Vector{Pair}}(
            col => Pair[_𝑐𝑝_key(x) => _𝑐𝑝_value(y) for (x, y) ∈ lst]
            for (col, lst) ∈ 𝐼["patches"]
        )
    )
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

    for new ∈ 𝐶
        createreference!(𝑀, 𝐶, getid(new), new)
    end
    _dereference!(𝐶, 𝑀, 𝐵)

    for new ∈ 𝐶
        setreferencefromjson!(𝑀[getid(new)], new)
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

function _dereference!(𝐶::Vector, 𝑀::ModelDict, 𝐵::Buffers)
    isempty(𝐶) && return
    todos = _𝑏_OPTS[𝐶]
    while !isempty(todos)
        cur = pop!(todos)
        for (k, v) ∈ pairs(cur)
            if v isa JSDict && !isempty(v)
                if length(v) == 1 && haskey(v, "id")
                    cur[k] = 𝑀[getid(v)]
                elseif haskey(v, _𝐵𝐾)
                    cur[k] = _reshape(𝐵[v[_𝐵𝐾]], v["dtype"], v["shape"], v["order"])
                elseif haskey(v, _𝑁𝐾)
                    cur[k] = _reshape(base64decode(v[_𝑁𝐾]), v["dtype"], v["shape"], v["order"])
                elseif any(i isa _𝑏_OPTS for i ∈ values(v))
                    push!(todos, v)
                end
            elseif v isa Vector && !isempty(v) && any(i isa _𝑏_OPTS for i ∈ v)
                push!(todos, v)
            end
        end
    end
end

function patchdoc!(𝐷::iDocument, 𝐶::JSDict, 𝐵::Buffers)
    𝑀 = parsereferences!(allmodels(𝐷), 𝐶["references"], 𝐵)
    _dereference!(𝐶["events"], 𝑀, 𝐵)
    for msg ∈ 𝐶["events"]
        apply(Val(Symbol(msg["kind"])), 𝐷, msg)
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

_𝑐𝑝_isamodel(x::JSDict) = length(x) == 1 && first(keys(x)) == "id"
_𝑐𝑝_isamodel(@nospecialize(x)) = false
_𝑐𝑝_value(@nospecialize(x::Union{Number, String, iHasProps, AbstractVector{<:Number}})) = x
_𝑐𝑝_value(@nospecialize(x::AbstractVector{Int64})) = collect(Int32, x)

function _𝑐𝑝_value(x::Vector{Any})
    elT = Union{typeof.(x)...}
    return if elT <: String
        collect(String, x)
    elseif elT <: Int64
        collect(Int32, x)
    elseif elT <: Union{Float64, Nothing}
        Float64[something(i, NaN64) for i ∈ x]
    elseif elT <: iHasProps
        collect(iHasProps, x)
    else
        x
    end
end


precompile(setpropertyfromjson!, (iHasProps, Symbol, Any))
export patchdoc!, parsereferences
end
using .PatchDocReceive
