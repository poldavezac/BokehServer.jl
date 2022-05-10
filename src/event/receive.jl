module Receive
using ...AbstractTypes
using ...Models
using ..Send

const ModelDict    = Dict{Int64, iHasProps}
const _MODEL_TYPES = Dict{NTuple{N, Symbol} where {N}, DataType}()
const _LOCK        = Threads.SpinLock()

getid(info::Dict{String}) :: Int64 = parse(Int64, info["id"])

createreference(::Type{T}, info::Dict{String}) where {T<:iHasProps} = T(; id = getid(info))

fromjson(T::Type, val, _) = convert(T, val)

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
    ftype = fieldtype(fieldtype(T, :original), attr)
    setproperty!(mdl, attr, fromjson(ftype, val, models))
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

function apply(::Val{:ModelChanged}, doc::iDocument, models::ModelDict, info :: Dict{String})
    setpropertyfromjson!(models[getid(info["model"])], Symbol(info["attr"]), info["new"], models)
end

function patchdoc!(doc::iDocument, contents::Dict{String}, buffers::Vector{<:Pair})
    if length(Models.MODEL_TYPES) ≢ length(_MODEL_TYPES)
        lock(_LOCK) do
            for cls ∈ Models.MODEL_TYPES
                _MODEL_TYPES[tuple(values(Send.jsontype(cls))...)] = cls
            end
        end
    end

    models = allmodels(doc)

    for new ∈ contents["references"]
        (getid(new) ∈ keys(models)) && continue

        key = tuple((Symbol(new[i]) for i ∈ ("type", "subtype") if i ∈ keys(new))...)
        mdl = createreference(_MODEL_TYPES[key], new)
        isnothing(mdl) || (models[bokehid(mdl)] = mdl)
    end

    for new ∈ contents["references"]
        setreferencefromjson!(models[getid(new)], models, new)
    end

    for msg ∈ contents["events"]
        apply(Val(Symbol(msg["kind"])), doc, models, msg)
    end
end

export patchdoc!
end
using .Receive

