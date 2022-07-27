function pushdoc(title :: AbstractString, roots, 𝑅::Serialize.iRules = Serialize.Rules())
    return Dict{String, Any}(
        "defs"  => Nothing[],
        "roots" => Dict{String, Any}(
            "references" => Dict{String, Any}[serialize(i, 𝑅) for i ∈ values(bokehmodels(roots))],
            "root_ids"   => string.(bokehid.(roots)),
        ),
        "title"   => "$title",
        "version" => "$(PROTOCOL_VERSION)",
    )
end

pushdoc(self::iDocument, 𝑅::Serialize.iRules = Serialize.Rules()) = (; doc = pushdoc(self.title, self, 𝑅))

function pushdoc!(self::iDocument, μ::Dict{String}, 𝐵::Buffers)
    docmsg   = μ["doc"]
    newroots = let models = deserialize!(
            Dict{Int64, iHasProps}(),
            docmsg["roots"]["references"],
            𝐵
        )
        [models[parse(Int64, i)] for i ∈ docmsg["roots"]["root_ids"]]
    end

    self.title = docmsg["title"]
    empty!(self)
    push!(self, newroots...)
    return self
end
