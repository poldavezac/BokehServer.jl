#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct StepInterpolator <: iStepInterpolator

    clip :: Bool = true

    data :: Model.Nullable{iColumnarDataSource} = nothing

    mode :: Model.EnumType{(:before, :after, :center)} = :after

    x :: Union{String, Vector{Float64}}

    y :: Union{String, Vector{Float64}}
end
