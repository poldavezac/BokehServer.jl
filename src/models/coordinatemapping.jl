#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CoordinateMapping <: iCoordinateMapping

    x_scale :: iScale = LinearScale()

    x_source :: iRange = DataRange1d()

    x_target :: iRange

    y_scale :: iScale = LinearScale()

    y_source :: iRange = DataRange1d()

    y_target :: iRange
end
