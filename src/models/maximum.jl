#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct Maximum <: iMaximum

    field :: String = required

    initial :: Union{Nothing, Float64} = -Inf
end
export Maximum
