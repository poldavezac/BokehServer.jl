struct Unknown end
@inline bokehfieldtype(T::Type)        = T
@inline bokehrawtype(@nospecialize(ν)) = ν

bokehconvert(𝑇::Type, ν) = ν isa 𝑇 ? ν : Unknown()
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
include("properties/either.jl")
