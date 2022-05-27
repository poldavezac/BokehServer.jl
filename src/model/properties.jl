@inline bokehfieldtype(T::Type) = T
@inline bokehrawtype(ν)         = ν
@inline bokehwrite(@nospecialize(T::Type), @nospecialize(::iHasProps), ::Symbol, @nospecialize(ν)) = bokehwrite(T, ν)
@inline bokehwrite(@nospecialize(T::Type), @nospecialize(ν)) = convert(T, ν)
@inline bokehread(@nospecialize(T::Type), @nospecialize(::iHasProps), ::Symbol, @nospecialize(ν)) = bokeread(T, ν)
@inline bokehread(@nospecialize(T::Type), @nospecialize(ν)) = ν
@inline changeevent(@nospecialize(::Type), @nospecialize(a...)) = Bokeh.ModelChangedEvent(a...)

include("properties/numeric.jl")
include("properties/enum.jl")
include("properties/image.jl")
include("properties/color.jl")
include("properties/dataspec.jl")
include("properties/container.jl")
include("properties/other.jl")
