using ..Protocol.Serialize
Serialize.serialattribute(η::iGlyph, ::Serialize.iRules, σ::Symbol, ::Type{<:Model.iSpec}) = Model.tonamedtuple(getfield(η, σ))
