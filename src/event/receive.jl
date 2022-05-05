module Receive
using ...AbstractTypes
using ..Send

const Models       = Dict{Int64, iHasProps}
const _MODEL_TYPES = Dict{NamedTuple, DataType}()

createreference(::Type{T}, info::Dict{String}) where {T<:iHasProps} = T(; id = info["id"])

fromjson(T::Type, val, _) = convert(T, val)

fromjson(::Type{<:iHasProps}, val::Dict, models::Models) = models[val["id"]]

function fromjson(::Type{<:Pair}, val::Dict, models::Models)
    @assert length(val) == 1
    (k, v) = first(val)
    return fromjson(T.a, k, models) => fromjson(T.b, v, models)
end

function fromjson(
        T      :: Type{<:Union{AbstractDict, AbstractSet, AbstractVector}},
        val    :: Union{Dict, Vector},
        models :: Models
)
    elT = eltype(T)
    return T([fromjson(elT, i, models) for i ∈ val])
end

function setpropertyfromjson!(mdl::iHasProps, attr:: Symbol, val, models::Models)
    ftype = fieldtype(field(mdl, :original), attr)
    setproperty!(mdl, attr, fromjson(ftype, val, models))
end

function setreferencefromjson!(mdl::iHasProps, models::Models, info :: Dict{String})
    for (key, val) ∈ info
        setpropertyfromjson!(mdl, Symbol(key), val, models)
    end
end

for (name, action) ∈ (:AddRoot => :push!, :RemoveRoot => :delete!)
    @eval function apply(::Val{$(Meta.quot(name))}, doc::iDocument, models::Models, info :: Dict{String})
        $action(doc, models[info["model"]["id"]])
    end
end

function apply(::Val{:ModelChanged}, doc::iDocument, models::Models, info :: Dict{String})
    setpropertyfromjson!(models["model"][info["id"]], Symbol(info["attr"]), info["new"], models)
end

function patchdoc!(doc::iDocument, contents::Dict{String}, buffers::Vector{<:Pair})
    if length(Models._MODELS) ≢ length(_MODEL_TYPES)
        for cls ∈ Models._MODELS
            _MODEL_TYPES[tuple(values(Send.jsontype(cls))...)] = cls
        end
    end

    models = allmodels(doc)

    for new ∈ contents["references"]
        (info["id"] ∈ keys(models)) && continue

        key = tuple(info[i] for i ∈ ("type", "subtype")...)
        mdl = createreference(_MODEL_TYPES[key], info)
        isnothing(mdl) || (models[bokeid(mdl)] = mdl)
    end

    for new ∈ contents["references"]
        setreferencefromjson!(models[info["id"]], new, models)
    end

    for msg ∈ messages
        apply(Val(Symbol(msg["kind"])), doc, models, msg)
    end
end

export patchdoc!
end
using .Receive

