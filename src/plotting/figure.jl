module Figures
using ...Model
using ...Models: Plot, iAxis, iGrid, iPlot
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
    (σ ≡ :values) && return getfield(μ, σ)
    for i ∈ getfield(μ, :values)
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
    elseif σ ≡ :xgrid
        axes = μ.xaxis
        PropertyVector(iGrid[i for i ∈ μ.center if i isa iGrid && i.axis ∈ axes])
    elseif σ ≡ :ygrid
        axes = μ.yaxis
        PropertyVector(iGrid[i for i ∈ μ.center if i isa iGrid && i.axis ∈ axes])
    else
        invoke(getproperty, Tuple{iPlot, Symbol}, μ, σ)
    end
end

function Base.propertynames(μ::Plot; private :: Bool = false)
    return (invoke(propertynames, Tuple{iPlot}, μ; private)..., :xaxis, :yaxis, :xgrid, :ygrid)
end
end

using .Figures

function figure(; k...)
    opts = Models.FigureOptions(;
        (i=>j for (i, j) ∈ k if hasfield(Models.FigureOptions, i))...
    )

    plot = Models.Plot()
    addaxis!(plot, opts, :x; dotrigger = false) # no need to trigger when creating a brand new plot!
    addaxis!(plot, opts, :y; dotrigger = false)
    tools!(plot, opts; dotrigger = false)
    return plot
end

export figure
