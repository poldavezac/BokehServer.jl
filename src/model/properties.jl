@inline bokehfieldtype(@nospecialize(T::Type)) = T
@inline bokehrawtype(@nospecialize(ν))         = ν
@inline bokehwrite(@nospecialize(T::Type), @nospecialize(ν)) = convert(bokehfieldtype(T), ν)
@inline bokehread(@nospecialize(T::Type), @nospecialize(::iHasProps), ::Symbol, @nospecialize(ν)) = bokehread(T, ν)
@inline bokehread(@nospecialize(T::Type), @nospecialize(ν)) = ν
@inline changeevent(@nospecialize(::Type), @nospecialize(a...)) = Bokeh.ModelChangedEvent(a...)

include("properties/other.jl")
include("properties/numeric.jl")
include("properties/enum.jl")
include("properties/image.jl")
include("properties/color.jl")
include("properties/dataspec.jl")
include("properties/container.jl")
