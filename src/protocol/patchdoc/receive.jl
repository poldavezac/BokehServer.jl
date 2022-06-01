module PatchDocReceive
using ...Model
using ..AbstractTypes
using ..Serialize

const ModelDict    = Dict{Int64, iHasProps}
const _MODEL_TYPES = Dict{NTuple{N, Symbol} where {N}, DataType}()
const _LOCK        = Threads.SpinLock()

getid(info::Dict{String}) :: Int64 = parse(Int64, info["id"])

createreference(::Type{T}, info::Dict{String}) where {T<:iHasProps} = T(; id = getid(info))

fromjson(::Type, val, _) = val

fromjson(::Type{<:iHasProps}, val::Dict, models::ModelDict) = models[getid(val)]

function fromjson(::Type{<:Pair}, val::Dict, models::ModelDict)
    @assert length(val) == 1
    (k, v) = first(val)
    return fromjson(T.a, k, models) => fromjson(T.b, v, models)
end

function fromjson(
        T      :: Type{<:Union{AbstractDict, AbstractSet, AbstractVector}},
        val    :: Union{Dict, Vector},
        models :: ModelDict
)
    elT = eltype(T)
    return T([fromjson(elT, i, models) for i ∈ val])
end

function setpropertyfromjson!(mdl::T, attr:: Symbol, val, models::ModelDict) where {T <: iHasProps}
    setproperty!(mdl, attr, fromjson(fieldtype(T, attr), val, models))
end

function setreferencefromjson!(mdl::iHasProps, models::ModelDict, info :: Dict{String})
    for (key, val) ∈ info["attributes"]
        setpropertyfromjson!(mdl, Symbol(key), val, models)
    end
end

for (name, action) ∈ (:RootAdded => :push!, :RootRemoved => :delete!)
    @eval function apply(::Val{$(Meta.quot(name))}, doc::iDocument, models::ModelDict, info :: Dict{String})
        $action(doc, models[getid(info["model"])])
    end
end

function apply(::Val{:TitleChanged}, doc::iDocument, ::ModelDict, info :: Dict{String})
    doc.title = info["title"]
end

function apply(::Val{:ModelChanged}, doc::iDocument, models::ModelDict, info :: Dict{String})
    setpropertyfromjson!(models[getid(info["model"])], Symbol(info["attr"]), info["new"], models)
end

function apply(::Val{:ColumnDataChangedEvent}, doc::iDocument, models::ModelDict, info :: Dict{String})
    Model.merge!(models[getid(info["model"])].data, info["new"])
end

function apply(::Val{:ColumnsStreamedEvent}, doc::iDocument, models::ModelDict, info :: Dict{String})
    Model.stream!(models[getid(info["model"])].data, info["column_source"])
end

_𝑎_patch(x::Int)   = x
_𝑎_patch(x::Dict)  = x["step"] ≡ 1 ? (x["start"] : x["stop"]) : (x["start"] : x["step"] : x["stop"])
_𝑎_patch(x::Tuple) = (x[1], _𝑎_patch(x[2]), _𝑎_patch(x[3]))

function apply(::Val{:ColumnsPatchedEvent}, doc::iDocument, models::ModelDict, info :: Dict{String})
    Model.patch!(
        models[getid(info["model"])].data,
        (
            col => _𝑎_patch(x) => y
            for (col, lst) ∈ info["patches"]
            for (x, y) ∈ lst
        )...
    )
end

parsereferences(contents) = parsereferences!(ModelDict(), contents)

function parsereferences!(models::ModelDict, contents)
    if length(Model.MODEL_TYPES) ≢ length(_MODEL_TYPES)
        𝑅 = Serialize.Rules()
        lock(_LOCK) do
            for cls ∈ Model.MODEL_TYPES
                _MODEL_TYPES[tuple(values(Serialize.serialtype(cls, 𝑅))...)] = cls
            end
        end
    end

    for new ∈ contents
        (getid(new) ∈ keys(models)) && continue

        key = tuple((Symbol(new[i]) for i ∈ ("type", "subtype") if i ∈ keys(new))...)
        mdl = createreference(_MODEL_TYPES[key], new)
        isnothing(mdl) || (models[bokehid(mdl)] = mdl)
    end

    for new ∈ contents
        setreferencefromjson!(models[getid(new)], models, new)
    end
    models
end

function patchdoc!(doc::iDocument, contents::Dict{String}, buffers::Vector{<:Pair})
    models = parsereferences!(allmodels(doc), contents["references"])
    for msg ∈ contents["events"]
        apply(Val(Symbol(msg["kind"])), doc, models, msg)
    end
end

export patchdoc!, parsereferences, parsereferences!
end
using .PatchDocReceive
