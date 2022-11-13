function pushdoc(title :: AbstractString, roots; deferred :: Bool = false)
    𝑅 = Encoder(; deferred)
    return (;
        doc = Dict{String, Any}(
            "defs"    => Nothing[],
            "roots"   => [serialize(i, 𝑅) for i ∈ roots],
            "title"   => "$title",
            "version" => "$(PROTOCOL_VERSION)",
        ),
        buffers = 𝑅.buffers
    )
end
pushdoc(self::iDocument; k...) = pushdoc(self.title, self; k...)
pushdoc!(self::iDocument, μ::AbstractDict{String, Any}, 𝐵::Buffers) = deserialize!(self, μ, 𝐵)

function onreceive!(μ::msg"PULL-DOC-REPLY,PUSH-DOC", 𝐷::iDocument, λ::Events.iEventList, a...)
    patchdoc(()->pushdoc!(𝐷, μ.contents, µ.buffers), 𝐷, λ, a...)
end
