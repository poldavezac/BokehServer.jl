@inline bokehfieldtype(@nospecialize(T::Type)) = T
@inline bokehrawtype(@nospecialize(ν))         = ν

function bokehwrite end
function bokehread end

struct Unknown end

bokehwrite(::Type{T}, ν::T) where {T} = ν
bokehwrite(::Type, ::Any) = Unknown()
bokehread(::Type{T}, @nospecialize(::iHasProps), @nospecialize(::Symbol), ν::T) where {T} = ν

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
