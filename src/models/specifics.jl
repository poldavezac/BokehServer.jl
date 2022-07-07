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

precompile(Plot, ())
precompile(ColumnDataSource, ())
precompile(GlyphRenderer, ())
