struct Unknown <: iBokehException
    msg::String
end
Unknown() = Unknown("")
@inline bokehstoragetype(@nospecialize(T::Type)) = T
@inline bokehunwrap(@nospecialize(ν))            = ν

bokehconvert(@nospecialize(𝑇::Type), @nospecialize(ν)) = ν isa 𝑇 ? ν : Unknown()
bokehread(::Type, @nospecialize(::iHasProps), @nospecialize(::Symbol), ν) = ν

include("properties/other.jl")
include("properties/numeric.jl")
include("properties/enum.jl")
include("properties/image.jl")
include("properties/color.jl")
include("properties/dataspec.jl")
include("properties/container.jl")
include("properties/datasource.jl")
include("properties/tuple.jl")
include("properties/union.jl")
