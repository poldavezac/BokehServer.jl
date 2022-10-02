Model.stream!(μ::ColumnDataSource, args...; kwa...) = Model.stream!(μ.data, args...; kwa...)
Model.patch!(μ::ColumnDataSource, args...; kwa...)  = Model.patch!(μ.data, args...; kwa...)
Model.update!(μ::ColumnDataSource, args...; kwa...) = Model.update!(μ.data, args...; kwa...)
Base.push!(μ::ColumnDataSource, args...; kwa...)    = Model.stream!(μ.data, args...; kwa...)
Base.merge!(μ::ColumnDataSource, args...; kwa...)   = Model.update!(μ.data, args...; kwa...)

TableColumn(field :: AbstractString, arr::Vector; kwa...) = TableColumn(field, eltype(arr); kwa...)

function TableColumn(field :: AbstractString, T::Type; kwa...)
    TableColumn(;
        field,
        formatter = 
            T <: Int64  ? DateFormatter()   :
            T <: Number ? NumberFormatter() :
            StringFormatter(),
        kwa...
    )
end

function DataTable(source::ColumnDataSource; columns = keys(source.data), kwa...)
    if !(columns isa AbstractVector) || !all(i isa TableColumn for i ∈ columns)
        columns = [TableColumn(i, eltype(source.data[i])) for i ∈ columns]
    end
    DataTable(; source, columns, kwa...)
end

Model.bokehconvert(::Type{<:iTitle}, x :: AbstractString) = Title(; text = "$x")
Model.bokehconvert(::Type{<:iTicker}, ticks :: AbstractVector{<:Real}) = FixedTicker(; ticks)

using ..Events
using ..Protocol

"""
    encodefield(::Type{Selection}, α::Symbol, η, 𝑅::Protocol.Encoder)

Serialize values and move indices from a 1-based index to a 0-based index
"""
function Protocol.Encoding.encodefield(::Type{Selection}, α::Symbol, η, 𝑅::Protocol.Encoder)
    return if α ∈ (:indices, :line_indices)
        η .- 1
    elseif α ≡ :multiline_indices
        Dict{String, Any}(i => j .- 1 for (i, j) ∈ η)
    else
        Protocol.Encoding.encode(η, 𝑅)
    end
end

"""
    decodefield(::Type{Selection}, α::Symbol, η, 𝑀::Protocol.Deserialize.Workbench)

Read the JSON values and move indices from a 0-based index to a 1-based index
"""
function Protocol.Decoding.decodefield(::Type{Selection}, α:: Symbol, η)
    return if(α ∈ (:line_indices, :indices))
        Int64[i+1 for i ∈ η]
    elseif α ≡ :multiline_indices
        Dict{String, Vector{Int64}}((i => Int64[k+1 for k ∈ j] for (i, j) ∈ η)...)
    else
        η
    end
end

"""
    Source(args::Vararg{Pair{<:AbstractString, <:AbstractVector}}; kwa...)

Create a `ColumnDataSource`.

Columns can be specified using either or both positional and keyword arguments. Keyword arguments
which are *not* a `ColumnDataSource` field name are considered to be a 

```julia
CDS = Source("x" => 1:5; y = 1:5, selection_policy = IntersectRenderers())
@assert "x" ∈ keys(CDS.data)
@assert "y" ∈ keys(CDS.data)
@assert CDS.selection_policy isa IntersectRenderers
```
"""
function Source(args::Vararg{Pair{<:AbstractString, <:AbstractVector}}; kwa...)
    data = get(Dict{String, AbstractVector}, kwa, :data)
    for (i, j) ∈ args
        push!(data, "$i" => j)
    end
    for (i, j) ∈ kwa
        Model.hasbokehproperty(ColumnDataSource, i) || push!(data, "$i" => j)
    end
    return ColumnDataSource(; data, (i for i ∈ kwa if hasfield(ColumnDataSource, first(i)))...)
end
export Source

function _👻js_on(μ::iHasProps, attr::Union{AbstractString, Symbol}, σs)
    @nospecialize μ σs
    info = Dict{String, Vector{iCallback}}(pairs(getproperty(μ, attr))...)
    for (i, j) ∈ σs
        push!(get!(info, "$i", iCallback[]), (j isa iCallback ? j : CustomJS(; j...)))
    end
    setproperty!(μ, attr, info)
end

"""
    js_onchange(μ::iHasProps, σ::Union{AbstractString, Symbol}; k...) = js_onchange(μ, σ => CustomJS(; k...))
    js_onchange(μ::iHasProps, σs::Vararg{Pair{<:Union{AbstractString, Symbol}}})

Adds a javascript callback to the model for a given bokeh field mutation
"""
function js_onchange(μ::iHasProps, σs::Vararg{Pair{<:Union{AbstractString, Symbol}}})
    @nospecialize μ σs
    vals = [(i isa Symbol ? i : Symbol(split(i, ':')[end])) => j for (i, j) ∈ σs]
    err = [i for (i, _) ∈ vals if !Model.hasbokehproperty(typeof(μ), i)]
    isempty(err) || throw(ErrorException("$μ is missing fields $err"))

    _👻js_on(μ, :js_property_callbacks, ("change:$i"=>j  for (i, j) ∈ vals))
end

"""
    js_onevent(μ::iHasProps, σ::Union{AbstractString, Symbol}; k...) = js_onevent(μ, σ => CustomJS(; k...))
    js_onevent(μ::iHasProps, σs::Vararg{Pair{<:Union{AbstractString, Symbol}}})

Adds a javascript callback to the model for a given bokeh event
"""
js_onevent(μ::iHasProps, σs::Vararg{Pair{<:Union{AbstractString, Symbol}}}) = _👻js_on(μ, :js_event_callbacks, σs)

for 𝐹 ∈ (:js_onchange, :js_onevent)
    @eval $𝐹(μ::iHasProps, σ::Union{AbstractString, Symbol}; k...) = $𝐹(μ, σ => CustomJS(; k...))
    @eval export $𝐹
end

"""
    @js_link expr

Creates a CustomJS to link two model attributes together

# Examples

    `@js_link plot.x_range.start = range_slider.value[0]`

    is equivalent to:

    ```
    js_onchange(
        ranger_slider, :value;
        args = Dict{String, Any}("left"=>plot.x_range, "right"=> "range_slider"),
        code = "left.start = right.value[0]"
    )
    ```
"""
macro js_link(expr::Expr)
    return _js_link_code(expr)
end

export @js_link

function _js_link_code(expr::Expr)
    check(x) = (x || throw(ErrorException("Could not deal with $expr")))
    check(expr.head ≡ :(=))
    check(length(expr.args) ≡ 2)

    left = expr.args[begin]
    check((left isa Expr) && (left.head ≡ :(.)))
    check(left.args[end] isa QuoteNode && left.args[end].value isa Symbol)

    check(expr.args[end] isa Expr)
    rightvals = Set{Union{Expr, Symbol}}()
    rightopts = Any[expr.args[end]]
    while !isempty(rightopts)
        val = pop!(rightopts)
        (val isa Expr) || continue
        if val.head ≡ :call
            append!(rightopts, val.args[2:end])
        elseif val.head ≡ :ref
            append!(rightopts, val.args)
        elseif val.head ≡ :(.)
            push!(rightvals, val)
        else
            check(false)
        end
    end
    check(length(rightvals) == 1)

    right = first(rightvals)
    check((right isa Expr) && (right.head ≡ :(.)))
    check(right.args[end] isa QuoteNode && right.args[end].value isa Symbol)

    code = replace("$(expr.args[end])", "$(right.args[1])" => "this")
    return :($(js_onchange)($(right.args[1]), $(Meta.quot(right.args[2].value));
        args = Dict{String, Any}("other" => $(left.args[1])),
        code = $("other.$(left.args[end]) = $code")
    ))
end

precompile(Plot, ())
precompile(ColumnDataSource, ())
precompile(GlyphRenderer, ())
