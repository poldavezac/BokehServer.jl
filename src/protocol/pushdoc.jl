function pushdoc(self::iDocument)
    return (; doc = (;
        title   = self.title,
        version = Bokeh.PYTHON_VERSION,
        defs    = [],
        roots   = (;
            root_ids   = string.(bokehid.(self)),
            references = NamedTuple[serialize(i) for i ∈ values(allmodels(self))],
        ),
    ))
end

function pushdoc!(self::iDocument, μ::Dict{String})
    docmsg   = μ["doc"]
    newroots = let models = parsereferences(docmsg["roots"]["references"])
        [models[parse(Int64, i)] for i ∈ docmsg["roots"]["root_ids"]]
    end

    self.title = docmsg["title"]
    empty!(self)
    push!(self, newroots...)
    return self
end
