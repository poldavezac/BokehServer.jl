module Stacks
using ..Transforms
using ..Plotting
using ...Models

function _stack(kw, stackers::AbstractVector{<:AbstractString}, spec::Symbol)
    haskey(kw, spec) && throw(BokehException(
        "Stack properties '$specs' cannot appear in keyword args"
    ))

    fields = [
        stackers[1],
        (Models.Stack(; fields = collect(stackers[1:i])) for i ∈ 2:length(stackers))...
    ]
    return (
        Dict{Symbol, Any}(
            :name => val,
            spec  => fields[i],
            (
                k => (v isa Union{Vector, Tuple} ? v[i] : v)
                for (k, v) ∈ kw
            )...
        )
        for (i, val) ∈ enumerate(stackers)
    )
end

function _stack(kw, stackers::AbstractVector{<:AbstractString}, spec1::Symbol, spec2::Symbol)
    any(haskey(kw, i) for i ∈ (spec1, spec2)) && throw(BokehException(
        "Stack properties '$specs' cannot appear in keyword args"
    ))

    fields = [
        0.,
        stackers[1],
        (Models.Stack(; fields = collect(stackers[1:i])) for i ∈ 2:length(stackers))...
    ]
    return (
        Dict{Symbol, Any}(
            :name => val,
            spec1 => fields[i],
            spec2 => fields[i+1],
            (
                k => (v isa Union{Vector, Tuple} ? v[i] : v)
                for (k, v) ∈ kw
            )...
        )
        for (i, val) ∈ enumerate(stackers)
    )
end

const _STACK_ARG = Union{AbstractVector{<:AbstractString}, Tuple{Vararg{AbstractString}}}

function linestack!(plot::Models.Plot; x, y, kw...)
    return if x isa _STACK_ARG && y isa _STACK_ARG
        throw(BokehException("Only one of x or y may be a list of fields"))
    elseif y isa _STACK_ARG
        Models.GlyphRenderer[Plotting.line!(plot; x, i...) for i ∈ _stack(kw, y, :y)]
    elseif x isa _STACK_ARG
        Models.GlyphRenderer[Plotting.line!(plot; y, i...) for i ∈ _stack(kw, x, :x)]
    else
        Models.GlyphRenderer[Plotting.line!(plot; x, y, kw...)]
    end
end

function areastack!(plot::Models.Plot; x, y, kw...)
    return if x isa _STACK_ARG && y isa _STACK_ARG
        throw(BokehException("Only one of x or y may be a list of fields"))
    elseif y isa _STACK_ARG
        Models.GlyphRenderer[Plotting.varea!(plot; x, i...) for i ∈ _stack(kw, y, :y1, :y2)]
    elseif x isa _STACK_ARG
        Models.GlyphRenderer[Plotting.harea!(plot; y, i...) for i ∈ _stack(kw, x, :x1, :x2)]
    else
        Models.GlyphRenderer[Plotting.varea!(plot; x, y1 = 0., y2 = y, i...)]
    end
end

function barstack!(plot::Models.Plot; x, y, kw...)
    return if x isa _STACK_ARG && y isa _STACK_ARG
        throw(BokehException("Only one of x or y may be a list of stackers"))
    elseif y isa _STACK_ARG
        Models.GlyphRenderer[Plotting.vbar!(plot; x, i...) for i ∈ _stack(kw, y, :bottom, :top)]
    elseif x isa _STACK_ARG
        Models.GlyphRenderer[Plotting.hbar!(plot; y, i...) for i ∈ _stack(kw, x, :left, :right)]
    else
        Models.GlyphRenderer[Plotting.vbar!(plot; bottom = 0., top = y, x, i...)]
    end
end

for 𝐹 ∈ (:linestack, :barstack, :areastack)
    @eval function $𝐹(; kw...)
        plot = Plotting.figure(; (i for i ∈ kw if hasfield(Models.FigureOptions, first(i)))...)
        $(Symbol("$(𝐹)!"))(plot; (i for i ∈ kw if !hasfield(Models.FigureOptions, first(i)))..., dotrigger = false)
        plot
    end

    let doc = """ 
        Generate multiple `$("$𝐹"[1:end-5])` renderers for levels stacked either
        left to right or bottom to top.

        The user must provide values for both `x` and `y`. Only one of these may be
        a list of fields. 

        ## Example

        ```julia
        plot = $𝐹(; x = ["a", "b", "c"], y = 0, source = Dict("a"=>[1,2], "b" => [3,4], "c"=>[5, 6]))
        @assert plot isa BokehServer.Models.Plot
        ```
        """
        eval(:(@doc($doc, $𝐹)))
    end

    let doc = """ 
        Generate multiple `$("$𝐹"[1:end-5])` renderers for levels stacked either
        left to right or bottom to top.

        The user must provide values for both `x` and `y`. Only one of these may be
        a list of fields.

        ## Example

        ```julia
        plot = BokehServer.figure()
        renderers = $(𝐹)!(plot; x = ["a", "b", "c"], y = 0, source = Dict("a"=>[1,2], "b" => [3,4], "c"=>[5, 6]))
        @assert renderers isa Vector{BokehServer.Models.GlyphRenderer}
        ```
        """
        eval(:(@doc($doc, $(Symbol("$(𝐹)!")))))
    end
end
end

using .Stacks: linestack, linestack!, areastack, areastack!, barstack, barstack!
export linestack, linestack!, areastack, areastack!, barstack, barstack!
