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

function Protocol.Serialize.serialref(::Type{Selection}, evt::Events.ModelChangedEvent, 𝑅::Protocol.Serialize.iRules)
    if evt.attr ∈ (:indices, :line_indices)
        evt = Events.ModelChangedEvent(evt.model, evt.attr, evt.old, evt.new .- 1)
    elseif evt.attr ≡ :multiline_indices
        evt = Events.ModelChangedEvent(
            evt.model, evt.attr, evt.old, Dict{String, Vector{Int64}}(i => j .- 1 for (i, j) in evt.new)
        )
    end
    return Protocol.Serialize.serialref(iHasProps, evt, 𝑅)
end

function Protocol.PatchDocReceive.fromjson(::Type{Selection}, attr:: Symbol, val)
    if(attr ∈ (:line_indices, :indices))
        Int64[i+1 for i ∈ val]
    elseif attr ≡ :multiline_indices
        Dict{String, Vector{Int64}}((i => Int64[k+1 for k ∈ j] for (i, j) ∈ val)...)
    else
        invoke(Protocol.PatchDocReceive.fromjson, Tuple{iHasProps, Symbol, Any}, mdl, attr, val; dotrigger)
    end
end

precompile(Plot, ())
precompile(ColumnDataSource, ())
precompile(GlyphRenderer, ())
