function pushdoc(self::Events.Document)
    return (; doc = (;
        title   = self.title,
        version = Bokeh.PYTHON_VERSION,
        defs    = [],
        roots   = (;
            root_ids   = bokehid.(self),
            references = [serialize(i) for i ∈ values(allmodels(self))],
        ),
    ))
end

function pushdoc!(self::Events.Document, μ::Dict{String})
    docmsg   = μ["doc"]
    newroots = let models = parsereferences(docmsg["roots"]["references"])
        [models[parse(Int64, i)] for i ∈ docmsg["roots"]["root_ids"]]
    end

    self.title = docmsg["title"]
    empty!(doc)
    push!(doc, newroots...)
    return doc
end
