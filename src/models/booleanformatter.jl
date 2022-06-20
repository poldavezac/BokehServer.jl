#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BooleanFormatter <: iBooleanFormatter

    icon :: Model.EnumType{(:check, Symbol("check-circle"), Symbol("check-circle-o"), Symbol("check-square"), Symbol("check-square-o"))} = :check
end
