module GlyphPlotting
using ...AbstractTypes
using ...Model
using ...Models

include("glyph/source.jl")
include("glyph/legend.jl")
include("glyph/visuals.jl")
include("glyph/glyph.jl")

end
using .GlyphPlotting

for 𝐹 ∈ names(GlyphPlotting)
    if 𝐹 ∉ (:step, :step!, :patch, :patch!)
        @eval export $𝐹
    end
end
