#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct StepInterpolator <: iStepInterpolator

    clip :: Bool = true

    data :: Union{Nothing, iColumnarDataSource} = nothing

    mode :: Model.EnumType{(:before, :after, :center)} = :after

    x :: Union{String, Vector{Float64}}

    y :: Union{String, Vector{Float64}}
end
export StepInterpolator
