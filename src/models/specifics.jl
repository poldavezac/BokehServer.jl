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
    serializeattribute(::Type{Selection}, α::Symbol, η, 𝑅::Protocol.Serialize.iRules)

Serialize values and move indices from a 1-based index to a 0-based index
"""
function Protocol.Serialize.serializeattribute(::Type{Selection}, α::Symbol, η, 𝑅::Protocol.Serialize.iRules)
    return if α ∈ (:indices, :line_indices)
        η .- 1
    elseif α ≡ :multiline_indices
        Dict{String, Any}(i => j .- 1 for (i, j) ∈ η)
    else
        Protocol.Serialize.serialref(η, 𝑅)
    end
end

"""
    deserialize(::Type{Selection}, α::Symbol, η, 𝑀::Protocol.Deserialize.Workbench)

Read the JSON values and move indices from a 0-based index to a 1-based index
"""
function Protocol.Deserialize.deserialize(::Type{Selection}, α:: Symbol, η, 𝑀::Protocol.Deserialize.Workbench)
    return if(α ∈ (:line_indices, :indices))
        Int64[i+1 for i ∈ η]
    elseif α ≡ :multiline_indices
        Dict{String, Vector{Int64}}((i => Int64[k+1 for k ∈ j] for (i, j) ∈ η)...)
    else
        invoke(
            Protocol.Deserialize.deserialize,
            Tuple{iHasProps, Symbol, Any, Protocol.Deserialize.Workbench},
            mdl, α, η; dotrigger
        )
    end
end

"""
    ColumnDataSource(args::Vararg{Pair{<:AbstractString, <:AbstractVector}}; kwa...)

Create a `ColumnDataSource`.

Columns can be specified using either or both positional and keyword arguments. Keyword arguments
which are *not* a `ColumnDataSource` field name are considered to be a 

```julia
CDS = ColumnDataSource("x" => 1:5; y = 1:5, selection_policy = IntersectRenderers())
@assert "x" ∈ keys(CDS.data)
@assert "y" ∈ keys(CDS.data)
@assert CDS.selection_policy isa IntersectRenderers
```
"""
function ColumnDataSource(args::Vararg{Pair{<:AbstractString, <:AbstractVector}}; kwa...)
    data = get(Dict{String, AbstractVector}, kwa, :data)
    for (i, j) ∈ args
        push!(data, "$i" => j)
    end
    for (i, j) ∈ kwa
        Model.hasbokehproperty(ColumnDataSource, i) || push!(data, "$i" => j)
    end
    return ColumnDataSource(; data, (i for i ∈ kwa if hasfield(ColumnDataSource, first(i)))...)
end

precompile(Plot, ())
precompile(ColumnDataSource, ())
precompile(GlyphRenderer, ())
