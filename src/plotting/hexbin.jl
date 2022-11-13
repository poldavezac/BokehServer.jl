
"""
    hexbin!(
        ::Plot, x::AbstractVector, y::AbstractVector, size::Real; 
        orientation::Symbol = :pointytop,
    )

Perform a simple equal-weight hexagonal binning.
"""
function hexbin!(
        fig::Plot,
        x::AbstractVector,
        y::AbstractVector,
        size::Real;
        weights     :: Union{AbstractVector, Nothing} = nothing,
        orientation :: Symbol = :pointytop,
        palette               = :Greens,
        fill_color            = nothing,
        aspect_scale :: Real  = 1.,
        k ... 
)
    bins = hexbinitems(x, y, size; orientation, aspect_scale, weights)
    if isnothing(fill_color)
        fill_color = (;
            field = "c",
            transform = Models.LinearColorMapper(palette, minimum(bins.c), maximum(bins.c))
        )
    end

    return hextile!(
        fig;
        q = "q",
        r = "r",
        size,
        orientation = "$orientation",
        aspect_scale,
        source = Source("q" => bins.q, "r" => bins.r, "c" => bins.c),
        fill_color,
        k...
    )
end

function hexbin(a...; kw...)
    kwargs = (; (k for k ∈ kw if hasfield(Models.FigureOptions, first(k)))...)
    plt = figure(; kwargs...)
    hexbin!(
        plt,
        a...;
        (k for k ∈ kw if !haskey(kwargs, first(k)))...,
        dotrigger = false
    )
    return plt
end

export hexbin!, hexbin

const _HEX_FLAT = (2.0/3.0, 0.0, -1.0/3.0, √(3.0)/3.0)
const _HEX_POINTY = (√(3.0)/3.0, -1.0/3.0, 0.0, 2.0/3.0)

"""
    hexbin(
        x:: AbstractVector,
        y:: AbstractVector,
        size:: Real,
        orientation:: Symbol,
        aspect_scale:: Real = 1.
        weights :: Union{AbstractVector, Nothing} = nothing
    )

Computes a hexagonal binning
"""
function hexbinitems(
        x:: AbstractVector,
        y:: AbstractVector,
        size:: Real;
        orientation:: Symbol,
        aspect_scale:: Real = 1.,
        weights :: Union{AbstractVector, Nothing} = nothing,
        _...
)
    q, r = let coords = orientation ≡ :flattop ? _HEX_FLAT : _HEX_POINTY
        q = Vector{Int32}(undef, length(x))
        r = Vector{Int32}(undef, length(x))

        γx = (orientation ≢ :pointytop ? aspect_scale : 1.) / size
        γy = 1 / ((orientation ≢ :pointytop ? aspect_scale : 1.) * size)
        for i ∈ eachindex(q)
            xv = x[i] * γx
            yv = y[i] * γy
             
            qv = coords[1] * xv + coords[2] * yv
            rv = coords[3] * xv + coords[4] * yv

            diff = -(qv + rv)

            rq = round(qv)
            rdiff = round(diff)
            rr = round(rv)

            dy = abs(rdiff - diff)
            dr = abs(rr - rv)

            cond = let dq = abs(rq - qv)
                (dq > dy) & (dq > dr)
            end

            q[i] = convert(Int32, cond ? -(rdiff + rr) : rq)
            r[i] = convert(Int, !cond && dy ≤ dr ? -rq + rdiff : rr)
        end
        q, r
    end

    vals = Dict{Tuple{Int, Int}, Float32}()
    for i ∈ 1:length(q)
        key = q[i], r[i]
        vals[key] = convert(Float32, get(vals, key, 0) + (isnothing(weights) ? 1f0 : weights[i]))
    end
    return (;
        q = collect(i for (i, _) ∈ keys(vals)),
        r = collect(i for (_, i) ∈ keys(vals)),
        c = collect(values(vals)),
    )
end
