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
    return fromjson(T.a, k, 𝑀) => fromjson(T.b, v, 𝑀)
end

function fromjson(
        T      :: Type{<:Union{AbstractDict, AbstractSet, AbstractVector}},
        val    :: Union{Dict, Vector},
        𝑀 :: ModelDict
)
    elT = eltype(T)
    return T([fromjson(elT, i, 𝑀) for i ∈ val])
end

function setpropertyfromjson!(mdl::T, attr:: Symbol, val, 𝑀::ModelDict) where {T <: iHasProps}
    setproperty!(mdl, attr, fromjson(fieldtype(T, attr), val, 𝑀))
end

function setreferencefromjson!(mdl::iHasProps, 𝑀::ModelDict, 𝐼 :: Dict{String})
    for (key, val) ∈ 𝐼["attributes"]
        setpropertyfromjson!(mdl, Symbol(key), val, 𝑀, 𝐵)
    end
end

for (name, action) ∈ (:RootAdded => :push!, :RootRemoved => :delete!)
    @eval function apply(::Val{$(Meta.quot(name))}, 𝐷::iDocument, 𝑀::ModelDict, 𝐼 :: Dict{String}, 𝐵)
        $action(𝐷, 𝑀[getid(𝐼["model"])])
    end
end

function apply(::Val{:TitleChanged}, 𝐷::iDocument, ::ModelDict, 𝐼 :: Dict{String})
    𝐷.title = 𝐼["title"]
end

function apply(::Val{:ModelChanged}, 𝐷::iDocument, 𝑀::ModelDict, 𝐼 :: Dict{String})
    setpropertyfromjson!(𝑀[getid(𝐼["model"])], Symbol(𝐼["attr"]), 𝐼["new"], 𝑀)
end

function apply(::Val{:ColumnDataChanged}, 𝐷::iDocument, 𝑀::ModelDict, 𝐼 :: Dict{String})
    merge!(𝑀[getid(𝐼["column_source"])].data, DataDict(i => _𝑏_fro(j, 𝐵) for (i, j) ∈ 𝐼["new"]))
end

function apply(::Val{:ColumnsStreamed}, 𝐷::iDocument, 𝑀::ModelDict, 𝐼 :: Dict{String})
    push!(𝑀[getid(𝐼["column_source"])].data, 𝐼["data"]; rollover = 𝐼["rollover"])
end

const _𝑐𝑝_SLICE  = AbstractDict{<:AbstractString, <:Union{Nothing, Integer}}
const _𝑐𝑝_RANGES = Union{Integer, _𝑐𝑝_SLICE}

_𝑐𝑝_fro(𝑥::Integer) = 𝑥+1
_𝑐𝑝_fro(𝑥::Tuple{<:Integer, <:_𝑐𝑝_RANGES, <:_𝑐𝑝_RANGES}) = (𝑥[1]+1, _𝑐𝑝_fro(𝑥[2]), _𝑐𝑝_fro(𝑥[3]))
_𝑐𝑝_fro(𝑥::_𝑐𝑝_SLICE) =  (;
    start = let x = get(𝑥, "start", nothing)
        isnothing(x) ? 1 : x + 1
    end,
    step = let x = get(𝑥, "step", nothing)
        isnothing(x) ? 1 : x
    end,
    stop = get(𝑥, "stop", nothing)
)

function apply(::Val{:ColumnsPatched}, 𝐷::iDocument, 𝑀::ModelDict, 𝐼::Dict{String})
    merge!(
        𝑀[getid(𝐼["column_source"])].data,
        Dict{String, Vector{Pair}}(
            col => Pair[_𝑐𝑝_fro(x) => y for (x, y) ∈ lst]
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
        setreferencefromjson!(𝑀[getid(new)], 𝑀, new, 𝐵)
    end
    𝑀
end

function insertbuffers!(𝐶::Union{Dict{String}, Vector}, 𝐵::Buffers)
    isempty(𝐵) && return
    todos = Union{Vector, Dict{String}}[𝐶]
    cnt   = 0
    while !isempty(todos)
        cur = pop!(𝐶)
        @assert !(cur isa Dict && (haskey(cur, "__ndarray__") || haskey(cur, "__buffer__")))

        for (k, v) ∈ pairs(cur)
            if v isa Dict{String} && (haskey(v, "__buffer__") || haskey(v, "__ndarray__"))
                isbuff = haskey(v, "__buffer__")
                buf    = let val = 𝐵[v[isbuff ? "__buffer__" : "__ndarray__"]]
                    isbuff ? decodebase64(val) : val
                end

                cur[k] = let arr = reinterpret(
                        let tpe = v["dtype"]
                            v == "uint8" ? UInt8 : v == "uint16" ? UInt16 : v == "uint32" ? UInt32 :
                            v == "int8" ? Int8 : v == "int16" ? Int16 : v == "int32" ? Int32 :
                            v == "float32" ? Float32 : v == "float64" ? Float64 : throw(ErrorException("Unknown type $tpe"))
                        end,
                        v["shape"]
                    )
                    if v["order"] ≡ :little && Base.ENDIAN_BOM ≡ 0x01020304
                        ltoh.(arr)
                    elseif v["order"] ≡ :big && Base.ENDIAN_BOM ≡ 0x04030201
                        htol.(arr)
                    else
                        arr
                    end
                end
                cnt += 1
                (length(𝐵) == cnt) && return
            elseif v isa Vector{<:Union{String, Number, Symbol}}
                continue
            elseif v isa Union{Dict{String}, Vector}
                push!(todos, v)
            end
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
