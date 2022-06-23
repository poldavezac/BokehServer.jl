module AxesPlotting
using ...Model
using ...Models
using ...AbstractTypes

Model.bokehconvert(::Type{Models.iAxis}, ν::Union{Nothing, Missing}) = Models.DataRange1d()
Model.bokehconvert(::Type{Models.iAxis}, ν::Model.FactorSeq) = Models.FactorRange(; factors = ν)
function Model.bokehconvert(::Type{Models.iAxis}, ν::Union{Tuple{<:Number, <:Number}, AbstractRange})
    Models.Range1d(; start = first(ν), finish = last(ν))
end
function Model.bokehconvert(::Type{Models.iAxis}, ν::Symbol)
    ν ≡ :user ? Models.Range1d() : ν ≡ :factor ? Models.FactorRange() : Models.DataRange1d()
end

function Model.bokehconvert(::Type{Models.iScale}, ν::Symbol)
    return ν ≡ :log ? Models.LogScale() : ν ≡ :categorical ? Models.CategoricalScale() : Models.LinearScale()
end

"""
    newscale(rng::iRange, scale::iScale) :: Union{iScale, Missing}

Provides a new scale if needed, or returns `missing` if not.
"""
newscale(::Models.FactorRange, ::Models.CategoricalScale) = missing
newscale(::Models.FactorRange, ::Models.iScale)           = Models.CategoricalScale()
newscale(::Models.iRange,      ::Models.CategoricalScale) = Models.LinearScale()
newscale(::Models.iRange,      ::Models.iScale)           = missing

"""
    newscale(rng::Models.iRange, scale::iScale) :: iScale

Provides a new scale if needed, or returns `missing` if not.
"""
newscale(rng::Models.FactorRange, :: Symbol) = Models.CategoricalScale()
newscale(::Models.iRange, scale::Symbol) = bokehconvert(iScale, scale)


"""
    initscale!(fig::Models.Plot; dotrigger::Bool = true)

Initializes scales according to current ranges
"""
function initscale!(fig::Models.Plot; dotrigger::Bool = true)
    for i ∈ (:x, :y)
        scale = Symbol("$(i)_scale")
        value = newscale(getproperty(opts, Symbol("$(i)_range")), getproperty(opts, scale))
        ismissing(value) || setproperty!(fig, scale, value; dotrigger)
        
        extrascales = getproperty(fig, Symbol("extra_$(i)_scales"))
        for (i, j) ∈ getproperty(fig, Symbol("extra_$(i)_ranges"))
            out = newscale(j, get(extrascales, i, missing))
            ismissing(out) || push!(extrascales, i=>out)
        end
    end
end

const _LOCATIONS = (:center, :left, :bottom, :right, :above)

"""
    axis!(
            fig             :: Models.Plot,
            isxaxis         :: Bool;
            type            :: Union{Symbol, Nothing}              = :auto,
            range           :: Union{Symbol, Tuple, AbstractRange} = :data,
            scale           :: Symbol                              = :linear,
            location        :: Union{Nothing, Missing, Symbol}     = missing,
            num_minor_ticks :: Union{Missing, Int, Nothing}        = missing,
            label           :: Union{iBaseText, String, Missing}   = missing,
            rangename       :: String                              = "default",
            axisname        :: Union{Missing, String}              = missing,
            grid            :: Bool                                = true,
            dotrigger       :: Bool                                = true,
    )

Adds a new axis to the figure. It does not remove old ones!

# Arguments

* isxaxis: either true or false.
* type: any of (:categorical, :linear, :mercator, :log, :datetime)
* range: any of (:data, :user) or can be a tuple or a range to set fixed limits
* scale: depends on `range` and `type` when those are specified or should be (:linear, :categorical or :log)
* location: any of (:auto, :left, :bottom, :right, :above, :center)
* num_minor_ticks: either `nothing`, `:auto` or a positive integer
* label: the axis label
* rangename: if specified, implies the range is added to `extra_(xy)_ranges`.
* axisname: a name provided to the axis
* grid: whether to add a grid
"""
function axis!(
        fig             :: Models.Plot,
        isxaxis         :: Bool;
        type            :: Union{Symbol, Nothing}                   = :auto,
        range           :: Union{Symbol, Tuple, AbstractRange}      = :data,
        scale           :: Symbol                                   = :linear,
        location        :: Union{Nothing, Missing, Symbol}          = missing,
        num_minor_ticks :: Union{Missing, Int, Nothing}             = missing,
        label           :: Union{Models.iBaseText, String, Missing} = missing,
        rangename       :: String                                   = "default",
        axisname        :: Union{Missing, String}                   = missing,
        grid            :: Bool                                     = true,
        dotrigger       :: Bool                                     = true,
)
    ismissing(location) && (location = isxaxis ? :bottom : :left)
    if !isnothing(location) && (location ∉ _LOCATIONS)
        throw(ErrorException("Location should be Nothing or $_LOCATIONS"))
    end

    rng  = Model.bokehconvert(Models.iRange, range)
    sca  = newscale(rng, scale)
    axis = if isnothing(type)
        nothing
    elseif rng isa FactorRange
        Models.CategoricalAxis()
    elseif type ≡ :mercator
        Models.MercatorAxis(; dimension = isxaxis ? :lon : :lat)
    elseif (type ≡ :datetime || (!(range isa Symbol) && first(range) isa Dates.AbstractTime))
        Models.DatetimeAxis()
    elseif type ≡ :log
        Models.LogAxis()
    else
        Models.LinearAxis()
    end

    if !isnothing(axis)
        if !ismissing(label)
            setproperty(axis, :axis_label, label; dotrigger = false)
        end
        if !ismissing(name)
            setproperty(axis, :name, name; dotrigger = false)
        end

        if axis isa Models.iContinuousAxis
            isnothing(num_minor_ticks) && (num_minor_ticks = 0)
            ismissing(num_minor_ticks) && (num_minor_ticks = axis isa Models.LogAxis ? 10 : 5)
            (num_minor_ticks < 0) && (num_minor_ticks = 0)
            setproperty!(axis.ticker, :num_minor_ticks, num_minor_ticks; dotrigger = false)
        end

        grid && push!(plot.center, Grid(dimension=isaxis ? 0 : 1, axis); dotrigger)
        isnothing(location) || push!(getproperty(plot, location), axis; dotrigger)
    end

    if rangename == "default"
        if isxaxis
            setproperty!(fig, :x_range, rng; dotrigger)
            setproperty!(fig, :x_scale, sca; dotrigger)
        else
            setproperty!(fig, :y_range, rng; dotrigger)
            setproperty!(fig, :y_scale, sca; dotrigger)
        end
    elseif isxaxis
        setproperty!(axis, :x_range_name, rangename; dotrigger)
        push!(getproperty!(fig, :extra_x_ranges), rangename => rng ; dotrigger)
        push!(getproperty!(fig, :extra_x_scales), rangename => sca ; dotrigger)
    else
        setproperty!(axis, :y_range_name, rangename; dotrigger)
        push!(getproperty!(fig, :extra_y_ranges), rangename => rng ; dotrigger)
        push!(getproperty!(fig, :extra_y_scales), rangename => sca ; dotrigger)
    end
    axis
end
end

using .AxesPlotting: axis!
