module Figures
using ...Model
using ...Models: Plot, iAxis, iGrid, iPlot, iLegend, iHoverTool
using ...Models

struct PropertyVector{T}
    values::Vector{T}
end

function Base.propertynames(μ::PropertyVector; private :: Bool = false)
    vals = getfield(μ, values)
    return if isempty(vals)
        private ? (:values,) : ()
    elseif private
        (:values, propertynames(vals[1])...)
    else
        propertynames(vals[1])
    end
end

function Base.getproperty(μ::PropertyVector, σ::Symbol)
    vals = getfield(μ, :values)
    return σ ≡ :values ? vals : PropertyVector([getproperty(i, σ) for i ∈ vals])
end

function Base.setproperty!(μ::PropertyVector, σ::Symbol, value; dotrigger :: Bool = true)
    vals = getfield(μ, :values)
    (σ ≡ :values) && return vals
    for i ∈ vals
        setproperty!(i, σ, value; dotrigger)
    end
end

Base.eltype(μ::PropertyVector{T}) where {T} = T
Base.length(μ::PropertyVector) = length(μ.values)
Base.iterate(μ::PropertyVector, state = 1) = iterate(μ.values, state)

for 𝐹 ∈ (:length, :iterate, :size, :eachindex, :lastindex, :firstindex, :get, :haskey, :keys, :values)
    @eval Base.$𝐹(γ::PropertyVector, x...) = $𝐹(γ.values, x...)
end
Base.isempty(γ::PropertyVector)     = isempty(γ.values)
Base.getindex(γ::PropertyVector, x) = γ.values[x]
Base.getindex(γ::PropertyVector)    = γ.values[]

for 𝐹 ∈ (:in, :any, :all, :filter)
    @eval Base.$𝐹(ν, γ::PropertyVector) = $𝐹(ν, γ.values)
end

function Base.getproperty(μ::Plot, σ::Symbol)
    return if σ ≡ :xaxis
        PropertyVector(iAxis[(i for i ∈ μ.below if i isa iAxis)..., (i for i ∈ μ.above if i isa iAxis)...])
    elseif σ ≡ :yaxis
        PropertyVector(iAxis[(i for i ∈ μ.left if i isa iAxis)..., (i for i ∈ μ.right if i isa iAxis)...])
    elseif σ ≡ :axis
        PropertyVector(collect(iAxis, Model.bokehchildren(iAxis, μ)))
    elseif σ ≡ :xgrid
        axes = μ.xaxis
        PropertyVector(iGrid[i for i ∈ μ.center if i isa iGrid && i.axis ∈ axes])
    elseif σ ≡ :ygrid
        axes = μ.yaxis
        PropertyVector(iGrid[i for i ∈ μ.center if i isa iGrid && i.axis ∈ axes])
    elseif σ ≡ :grid
        PropertyVector(collect(iGrid, Model.bokehchildren(iGrid, μ)))
    elseif σ ≡ :legend
        PropertyVector(collect(iLegend, Model.bokehchildren(iLegend, μ)))
    elseif σ ≡ :hover
        PropertyVector([i for i ∈ μ.toolbar.tools if i isa iHoverTool])
    else
        invoke(getproperty, Tuple{iPlot, Symbol}, μ, σ)
    end
end

function Base.propertynames(μ::Plot; private :: Bool = false)
    return (invoke(propertynames, Tuple{iPlot}, μ; private)..., :xaxis, :yaxis, :xgrid, :ygrid)
end
end

using .Figures

"""
    figure(;
        # tool keywords
        active_drag    :: Union{Nothing, iDrag, String, Model.EnumType{(:auto,)}}                              = :auto
        active_inspect :: Union{Nothing, iInspectTool, String, Model.EnumType{(:auto,)}, Vector{iInspectTool}} = :auto
        active_multi   :: Union{Nothing, iGestureTool, String, Model.EnumType{(:auto,)}}                       = :auto
        active_scroll  :: Union{Nothing, iScroll, String, Model.EnumType{(:auto,)}}                            = :auto
        active_tap     :: Union{Nothing, iTap, String, Model.EnumType{(:auto,)}}                               = :auto
        tools          :: Union{String, Vector{Union{iTool, String}}}                                          = "pan,wheel_zoom,box_zoom,save,reset,help"
        tooltips       :: Union{Nothing, iTemplate, String, Vector{Tuple{String, String}}}                     = nothing

        # x-axis keywords
        x_axis_label    :: Union{Nothing, iBaseText, String}                                            = ""
        x_axis_location :: Union{Nothing, Model.EnumType{(:above, :below)}}                             = :below
        x_axis_type     :: Union{Nothing, Model.EnumType{(:auto, :linear, :log, :datetime, :mercator)}} = :auto
        x_minor_ticks   :: Union{Int64, Model.EnumType{(:auto,)}}                                       = :auto
        x_range         :: Any                                                                          = nothing

        # y-axis keywords
        y_axis_label    :: Union{Nothing, iBaseText, String}                                            = ""
        y_axis_location :: Union{Nothing, Model.EnumType{(:left, :right)}}                              = :left
        y_axis_type     :: Union{Nothing, Model.EnumType{(:auto, :linear, :log, :datetime, :mercator)}} = :auto
        y_minor_ticks   :: Union{Int64, Model.EnumType{(:auto,)}}                                       = :auto
        y_range         :: Any                                                                          = nothing
    )

Create a `Plot` object.
"""
function figure(; k...)
    opts = Models.FigureOptions(; (i for i ∈ k if hasfield(Models.FigureOptions, first(i)))...)
    plot = Models.Plot(; (i for i ∈ k if hasfield(Models.Plot, first(i)) && !hasfield(Models.FigureOptions, first(i)))...)
    addaxis!(plot, opts, :x; dotrigger = false) # no need to trigger when creating a brand new plot!
    addaxis!(plot, opts, :y; dotrigger = false)
    tools!(plot, opts; dotrigger = false)
    return plot
end

export figure
