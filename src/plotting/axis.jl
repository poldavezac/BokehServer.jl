module AxesPlotting
using Dates
using ...AbstractTypes
using ...Model
using ...Models
const RangeArguments = Union{Symbol, Tuple, AbstractRange, Model.FactorSeq, Models.iRange}

Model.bokehconvert(::Type{Models.iRange}, ν::Union{Nothing, Missing}) = Models.DataRange1d()
Model.bokehconvert(::Type{Models.iRange}, ν::Model.FactorSeq) = Models.FactorRange(; factors = ν)
function Model.bokehconvert(::Type{Models.iRange}, ν::Union{Tuple{<:Number, <:Number}, AbstractRange})
    Models.Range1d(; start = first(ν), finish = last(ν))
end
function Model.bokehconvert(::Type{Models.iRange}, ν::Symbol)
    ν ≡ :user ? Models.Range1d() : ν ∈ (:categorical, :factor) ? Models.FactorRange() : Models.DataRange1d()
end

function Model.bokehconvert(::Type{Models.iScale}, ν::Symbol)
    return ν ≡ :log ? Models.LogScale() : ν ∈ (:categorical, :factor) ? Models.CategoricalScale() : Models.LinearScale()
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
newscale(::Models.iRange, scale::Symbol) = Model.bokehconvert(Models.iScale, scale)


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

const _LOCATIONS = (:center, :left, :below, :right, :above)

"""
    addaxis!(
            fig             :: Models.Plot,
            position        :: Symbol #= :x or :y =#;
            type            :: Union{Symbol, Nothing}              = :auto,
            range           :: RangeArguments                      = :data,
            scale           :: Symbol                              = :linear,
            location        :: Union{Nothing, Missing, Symbol}     = missing,
            num_minor_ticks :: Union{Missing, Int, Nothing}        = missing,
            label           :: Union{iBaseText, String, Missing}   = missing,
            rangename       :: String                              = "default",
            axisname        :: Union{Missing, String}              = missing,
            grid            :: Bool                                = true,
            dotrigger       :: Bool                                = true,
    )
    addaxis!(
            fig       :: Models.Plot,
            items     :: NamedTuple #= created by createaxis =#;
            location  :: Union{Nothing, Missing, Symbol} = missing,
            dotrigger :: Bool                            = true,
    )

Adds a new axis to the figure. It does not remove old ones!

# Arguments

* axis: either :x or :y
* type: any of (:categorical, :linear, :mercator, :log, :datetime)
* range: any of (:data, :user) or can be a tuple or a range to set fixed limits
* scale: depends on `range` and `type` when those are specified or should be (:linear, :categorical or :log)
* location: any of (:auto, :left, :below, :right, :above, :center)
* num_minor_ticks: either `nothing`, `:auto` or a positive integer
* label: the axis label
* rangename: if specified, implies the range is added to `extra_(xy)_ranges`.
* axisname: a name provided to the axis
* grid: whether to add a grid
"""
function addaxis!(
        fig             :: Models.Plot,
        axis            :: Symbol;
        type            :: Union{Symbol, Nothing}                   = :auto,
        range           :: Union{RangeArguments, Nothing}           = :data,
        scale           :: Symbol                                   = :linear,
        location        :: Union{Nothing, Missing, Symbol}          = missing,
        num_minor_ticks :: Union{Missing, Int, Nothing}             = missing,
        label           :: Union{Models.iBaseText, String, Missing} = missing,
        rangename       :: String                                   = "default",
        axisname        :: Union{Missing, String}                   = missing,
        grid            :: Bool                                     = true,
        dotrigger       :: Bool                                     = true,
)
    items = createaxis(axis; type, range, scale, num_minor_ticks, label, rangename, axisname, grid)
    addaxis!(fig, items; location, dotrigger)
    items
end

function addaxis!(plot, opts::Models.FigureOptions, axis::Symbol; dotrigger :: Bool = true)
    getprop(y) = let x = getproperty(opts, Symbol("$(axis)_$y"))
        x isa Model.EnumType ? x.value : x
    end

    addaxis!(
        plot, 
        axis;
        type            = getprop(:axis_type),
        range           = getprop(:range),
        location        = getprop(:axis_location),
        num_minor_ticks = let x = getprop(:minor_ticks)
            x == :auto ? missing : x
        end,
        label           = getprop(:axis_label),
        dotrigger
    )
end

function addaxis!(
        fig       :: Models.Plot,
        items     :: NamedTuple #= created by createaxis =#;
        location  :: Union{Nothing, Missing, Symbol} = missing,
        dotrigger :: Bool                            = true,
)
    isxaxis = items.axis ≡ :x
    ismissing(location) && (location = isxaxis ? :below : :left)
    if !isnothing(location) && (location ∉ _LOCATIONS)
        throw(ErrorException("Location should be Nothing or $_LOCATIONS"))
    end
    fname(x) = isxaxis ? x : Symbol(replace("$x", "x" => "y"))

    isempty(items.grids) || push!(fig.center, items.grids...; dotrigger)
    isnothing(location)  || isempty(items.axes) || push!(getproperty(fig, location), items.axes...; dotrigger)
    if items.rangename == "default"
        setproperty!(fig, fname(:x_range), items.range; dotrigger)
        setproperty!(fig, fname(:x_scale), items.scale; dotrigger)
    else
        push!(getproperty!(fig, fname(:extra_x_ranges)), rangename => items.range; dotrigger)
        push!(getproperty!(fig, fname(:extra_x_scales)), rangename => items.scale; dotrigger)
    end

    items
end

"""
    createaxis(
        axis            :: Symbol #= :x or :y =#;
        type            :: Union{Symbol, Nothing}                       = :auto,
        range           :: Union{RangeArguments, Nothing}               = :data,
        scale           :: Symbol                                       = :linear,
        num_minor_ticks :: Union{Missing, Int, Nothing}                 = missing,
        label           :: Union{Models.iBaseText, String, Missing}     = missing,
        rangename       :: String                                       = "default",
        axisname        :: Union{Missing, String}                       = missing,
        grid            :: Bool                                         = true,
    )

Creates a new axis and its companion models.
"""
function createaxis(
        position         :: Symbol;
        type            :: Union{Symbol, Nothing}                       = :auto,
        range           :: Union{RangeArguments, Nothing}               = :data,
        scale           :: Symbol                                       = :linear,
        num_minor_ticks :: Union{Missing, Int, Nothing}                 = missing,
        label           :: Union{Models.iBaseText, String, Missing}     = missing,
        rangename       :: String                                       = "default",
        axisname        :: Union{Missing, String}                       = missing,
        grid            :: Bool                                         = true,
)
    isxaxis = position ≡ :x
    rng     = Model.bokehconvert(Models.iRange, something(range, :data))
    sca     = newscale(rng, scale)
    axis    = if isnothing(type)
        nothing
    elseif rng isa Models.FactorRange
        Models.CategoricalAxis()
    elseif type ≡ :mercator
        Models.MercatorAxis(; dimension = isxaxis ? :lon : :lat)
    elseif (type ≡ :datetime || (range isa Union{Tuple, AbstractRange} && first(range) isa Dates.AbstractTime))
        Models.DatetimeAxis()
    elseif type ≡ :log
        Models.LogAxis()
    else
        Models.LinearAxis()
    end

    if !isnothing(axis)
        if !ismissing(label)
            setproperty!(axis, :axis_label, label; dotrigger = false)
        end
        if !ismissing(axisname)
            setproperty!(axis, :name, axisname; dotrigger = false)
        end

        if axis isa Models.iContinuousAxis
            isnothing(num_minor_ticks) && (num_minor_ticks = 0)
            ismissing(num_minor_ticks) && (num_minor_ticks = axis isa Models.LogAxis ? 10 : 5)
            (num_minor_ticks < 0) && (num_minor_ticks = 0)
            setproperty!(axis.ticker, :num_minor_ticks, num_minor_ticks; dotrigger = false)
        end

        setproperty!(axis, isxaxis ? :x_range_name : :y_range_name, rangename; dotrigger = false)
        grid && return (;
            axis = position,
            rangename,
            axisname,
            range = rng,
            scale = sca,
            axes  = Models.iAxis[axis],
            grids = [Models.Grid(; dimension = isxaxis ? 0 : 1, axis)]
        )
    end

    return (;
        axis = position,
        rangename,
        axisname,
        range = rng,
        scale = sca,
        axes  = Models.iAxis[],
        grids = Models.iGrid[],
    )
end

"""
    getaxis(
        fig       :: Models.Plot,
        position  :: Symbol #= ∈ (:x, :y) =#;
        rangename :: String = "default",
        axisname  :: Union{String, Missing} = missing
    )

Gets an axis and its companions
"""
function getaxis(
        fig       :: Models.Plot,
        position  :: Symbol;
        rangename :: String = "default",
        axisname  :: Union{String, Missing} = missing
)
    isxaxis      = position ≡ :x
    fname(x)     = isxaxis ? x : Symbol(replace("$x", "x" => "y"))
    getrngsca(x) = rangename == "default"       ?
        getproperty(fig, fname(Symbol("x_$x"))) :
        getproperty(fig, fname(Symbol("extra_x_$x")))[rangename]

    rng   = getrngsca(:range)
    sca   = getrngsca(:scale)
    grids = filter(fig.center) do x
        x isa Models.iGrid && x.dimension ≡ (isxaxis ? 0 : 1)
    end
    axes  = let rngfield = fname(:x_range_name)
        filt(x)  = (
            x isa Models.iAxis &&
            getproperty(x, rngfield) == rangename &&
            (ismissing(axisname) || x.name == axisname)
        )

        arr = Set{Models.iAxis}()
        for i ∈ grids
            push!(arr, i.axis)
        end
        for field ∈ (isxaxis ? (:above, :below) : (:left, :right)), i ∈ getproperty(fig, field)
            filt(i) && push!(arr, i)
        end
        collect(Models.iAxis, arr)
    end

    filter!(grids) do x
        x.axis ∈ axes
    end

    return (; axis = position, rangename, axisname, range = rng, scale = sca, axes, grids)
end

"""
    popaxis!(
            fig       :: Models.Plot, items #= NamedTuple created by getaxis =#;
            dotrigger :: Bool = true
    )

Removes an axis and its companion objects
"""
function popaxis!(
        fig       :: Models.Plot, items #= NamedTuple created by getaxis =#;
        dotrigger :: Bool = true
)
    fname(x) = items.axis ≡ :x ? x : Symbol(replace("$x", "x" => "y"))
    for field ∈ (:extra_x_scales, :extra_x_ranges)
        dic = getproperty(fig, fname(field))
        haskey(dic, items.rangename) && pop!(dic, items.rangename; dotrigger)
    end
    isempty(items.axes) && isempty(items.grids) && return

    filt = ∈(Int64[bokehid.(items.axes)..., bokehid.(items.grids)...]) ∘ bokehid
    for field ∈ (:center, :left, :right, :above, :below)
        arr = getproperty(fig, field)
        any(filt, arr) && filter!(!filt, arr; dotrigger)
    end
end

"""
    resetaxis!(
            fig             :: Models.Plot,
            axis            :: Symbol #= :x or :y =#;
            location        :: Union{Nothing, Missing, Symbol} = missing,
            dotrigger       :: Bool                            = true,
            kwa...
    )

    resetaxis!(
            fig       :: Models.Plot,
            items     :: Any #= NamedTuple created by createaxis =#;
            location  :: Union{Nothing, Missing, Symbol} = missing,
            dotrigger :: Bool                            = true,
    )

Removes an axis adds it again with new properties
"""
function resetaxis!(
        fig       :: Models.Plot,
        position  :: Symbol;
        location  :: Union{Nothing, Missing, Symbol} = missing,
        dotrigger :: Bool                            = true,
        kwa...
)
    resetaxis!(fig, createaxis(position; kwa...); location, dotrigger)
end

function resetaxis!(
        fig       :: Models.Plot,
        items     :: Any #= NamedTuple created by createaxis =#;
        location  :: Union{Nothing, Missing, Symbol} = missing,
        dotrigger :: Bool                            = true,
)
    old = getaxis(fig, items.isaxis; items.rangename, items.axisname)
    popaxis!(fig, old; dotrigger)
    addaxis!(fig, items; location, dotrigger)
end
end

using .AxesPlotting: addaxis!, getaxis, createaxis, popaxis!, resetaxis!
export addaxis!, getaxis, createaxis, popaxis!, resetaxis!
