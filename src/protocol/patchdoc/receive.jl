module PatchDocReceive
using ...Model
using ...AbstractTypes
using ..Serialize
using ..Protocol: Buffers

const ModelDict    = Dict{Int64, iHasProps}
const _MODEL_TYPES = Dict{NTuple{N, Symbol} where {N}, DataType}()
const _LOCK        = Threads.SpinLock()

getid(𝐼::Dict{String}) :: Int64 = parse(Int64, 𝐼["id"])

createreference(::Type{T}, 𝐼::Dict{String}) where {T<:iHasProps} = T(; id = getid(𝐼))

fromjson(::Type, val, _) = val

fromjson(::Type{<:iHasProps}, val::Dict, 𝑀::ModelDict) = 𝑀[getid(val)]

function fromjson(::Type{<:Pair}, val::Dict, 𝑀::ModelDict)
    @assert length(val) == 1
    (k, v) = first(val)
    return fromjson(T.parameters[1], k, 𝑀) => fromjson(T.parameters[2], v, 𝑀)
end

function fromjson(
        𝑇 :: Type{<:Union{AbstractDict, AbstractSet, AbstractVector}},
        𝑣 :: Union{Dict, Vector},
        𝑀 :: ModelDict
)
    elT = eltype(𝑇)
    return 𝑇([fromjson(elT, i, 𝑀) for i ∈ 𝑣])
end

function fromjson(𝑇::Type{<:Model.iContainer{<:AbstractVector}}, 𝑣::Vector, 𝑀 :: ModelDict)
    fT  = Model.bokehfieldtype(𝑇)
    elT = eltype(fT)
    return elT[fromjson(elT, i, 𝑀) for i ∈ 𝑣]
end

function fromjson(𝑇::Type{<:Model.iContainer{<:AbstractDict}}, 𝑣::Dict, 𝑀 :: ModelDict)
    fT  = Model.bokehfieldtype(𝑇)
    elK = eltype(fT).parameters[1]
    elV = eltype(fT).parameters[2]
    return fT((fromjson(elK, i, 𝑀) => fromjson(elV, j, 𝑀) for (i, j) ∈ 𝑣)...)
end

fromjson(::Type{DataDict}, 𝑣::Dict{String}, 𝑀::ModelDict) = DataDict(i => _𝑐𝑝_value(j, 𝑀) for (i, j) ∈ 𝑣)

function setpropertyfromjson!(mdl::T, attr:: Symbol, val, 𝑀::ModelDict; dotrigger ::Bool =true) where {T <: iHasProps}
    setproperty!(mdl, attr, fromjson(Model.bokehpropertytype(T, attr), val, 𝑀); dotrigger)
end

function setreferencefromjson!(mdl::iHasProps, 𝑀::ModelDict, 𝐼 :: Dict{String})
    for (key, val) ∈ 𝐼["attributes"]
        setpropertyfromjson!(mdl, Symbol(key), val, 𝑀; dotrigger = false)
    end
end

for (name, action) ∈ (:RootAdded => :push!, :RootRemoved => :delete!)
    @eval function apply(::Val{$(Meta.quot(name))}, 𝐷::iDocument, 𝑀::ModelDict, 𝐼::Dict{String})
        $action(𝐷, 𝑀[getid(𝐼["model"])])
    end
end

function apply(::Val{:TitleChanged}, 𝐷::iDocument, ::ModelDict, 𝐼 :: Dict{String})
    𝐷.title = 𝐼["title"]
end

function apply(::Val{:ModelChanged}, 𝐷::iDocument, 𝑀::ModelDict, 𝐼::Dict{String})
    setpropertyfromjson!(𝑀[getid(𝐼["model"])], Symbol(𝐼["attr"]), 𝐼["new"], 𝑀)
end

function apply(::Val{:ColumnDataChanged}, 𝐷::iDocument, 𝑀::ModelDict, 𝐼::Dict{String})
    Model.update!(𝑀[getid(𝐼["column_source"])].data, fromjson(DataDict, 𝐼["new"], 𝑀))
end

function apply(::Val{:ColumnsStreamed}, 𝐷::iDocument, 𝑀::ModelDict, 𝐼::Dict{String})
    Model.stream!(𝑀[getid(𝐼["column_source"])].data, fromjson(DataDict, 𝐼["data"], 𝑀); rollover = 𝐼["rollover"])
end

const _𝑐𝑝_SLICE  = AbstractDict{<:AbstractString, <:Union{Nothing, Integer}}
const _𝑐𝑝_RANGES = Union{Integer, _𝑐𝑝_SLICE}

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

_𝑐𝑝_isamodel(x::Dict{String, String}) = length(x) == 1 && first(keys(x)) == "id"
_𝑐𝑝_isamodel(x) = false

_𝑐𝑝_value(x::Union{Number, String}, ::ModelDict) = x
_𝑐𝑝_value(x::Dict{String}, 𝑀::ModelDict) = fromjson(iHasProps, x, 𝑀)

function _𝑐𝑝_value(x::Vector{Any}, 𝑀::ModelDict)
    elT = Union{eltype.(x)...}
    return if elT <: String
        collect(String, x)
    elseif elT <: Int64
        collect(Int64, x)
    elseif elT <: Union{Float64, Nothing}
        Float64[something(i, NaN64) for i ∈ x]
    elseif Dict{String, String} <: elT
        [_𝑐𝑝_isamodel(x) ? fromjson(iHasProps, x, 𝑀) : x for i ∈ x]
    else
        x
    end
end

function apply(::Val{:ColumnsPatched}, 𝐷::iDocument, 𝑀::ModelDict, 𝐼::Dict{String})
    Model.patch!(
        𝑀[getid(𝐼["column_source"])].data,
        Dict{String, Vector{Pair}}(
            col => Pair[_𝑐𝑝_key(x) => _𝑐𝑝_value(y, 𝑀) for (x, y) ∈ lst]
            for (col, lst) ∈ 𝐼["patches"]
        )
    )
end

parsereferences(𝐶) = parsereferences!(ModelDict(), 𝐶)

function parsereferences!(𝑀::ModelDict, 𝐶)
    if length(Model.MODEL_TYPES) ≢ length(_MODEL_TYPES)
        𝑅 = Serialize.Rules()
        lock(_LOCK) do
            for cls ∈ Model.MODEL_TYPES
                _MODEL_TYPES[tuple(values(Serialize.serialtype(cls, 𝑅))...)] = cls
            end
        end
    end

    for new ∈ 𝐶
        (getid(new) ∈ keys(𝑀)) && continue

        key = tuple((Symbol(new[i]) for i ∈ ("type", "subtype") if i ∈ keys(new))...)
        mdl = createreference(_MODEL_TYPES[key], new)
        isnothing(mdl) || (𝑀[bokehid(mdl)] = mdl)
    end

    for new ∈ 𝐶
        setreferencefromjson!(𝑀[getid(new)], 𝑀, new)
    end
    𝑀
end

function _reshape(data::Union{Vector{Int8}, Vector{UInt8}}; dtype::String, order::String, shape::Tuple, _...)
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
        sz  = shape[2:end]
        len = prod(sz)
        [
            reshape(view(arr, i:i+len-1), sz)
            for i ∈ 1:len:length(arr)
        ]
    end
end

const _𝐵𝐾 = "__buffer__"
const _𝑁𝐾 = "__ndarray__"

function insertbuffers!(𝐶::Union{Dict{String}, Vector}, 𝐵::Buffers)
    isempty(𝐵) && return
    todos = Union{Vector, Dict{String}}[𝐶]
    cnt   = 0
    while !isempty(todos)
        cur = pop!(𝐶)
        for (k, v) ∈ pairs(cur)
            if v isa Vector
                types = Set([typeof(i) for i ∈ v])
                if !(length(types) == 1 && first(types) <: Union{String, Number})
                    push!(todos, v)
                end
                continue
            elseif !(v isa Dict{String})
                continue
            end

            if haskey(v, _𝐵𝐾)
                cur[k] = _reshape(𝐵[v[_𝐵𝐾]]; v...)
            elseif haskey(v, _𝑁𝐾)
                cur[k] = _reshape(decodebase64(𝐵[v[_𝑁𝐾]]); v...)
            elseif v 
                push!(todos, v)
                continue
            end

            cnt   += 1
        end
    end
end

function patchdoc!(𝐷::iDocument, 𝐶::Dict{String}, 𝐵::Buffers)
    insertbuffers!(𝐶, 𝐵)
    𝑀 = parsereferences!(allmodels(𝐷), 𝐶["references"])
    for msg ∈ 𝐶["events"]
        apply(Val(Symbol(msg["kind"])), 𝐷, 𝑀, msg)
    end
end

export patchdoc!, parsereferences, parsereferences!, insertbuffers!
end
using .PatchDocReceive
