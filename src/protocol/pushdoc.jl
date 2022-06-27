function pushdoc(self::iDocument, 𝑅::Serialize.iRules = Serialize.Rules())
    return (; doc = (;
        defs    = [],
        roots   = (;
            references = NamedTuple[serialize(i, 𝑅) for i ∈ values(allmodels(self))],
            root_ids   = string.(bokehid.(self)),
        ),
        title   = self.title,
        version = Bokeh.PYTHON_VERSION,
    ))
end

function pushdoc!(self::iDocument, μ::Dict{String}, 𝐵::Buffers)
    docmsg   = μ["doc"]
    newroots = let models = parsereferences(docmsg["roots"]["references"], 𝐵)
        [models[parse(Int64, i)] for i ∈ docmsg["roots"]["root_ids"]]
    end

    self.title = docmsg["title"]
    empty!(self)
    push!(self, newroots...)
    return self
end
