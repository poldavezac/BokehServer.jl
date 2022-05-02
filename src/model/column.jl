"""
Provides a type-specific way of specifying a data source column as field value.

This can be created using col"my_col_name"
"""
struct Column
    column :: String 

    Column(x::Union{AbstractString, Symbol}) = new(string(x))
end

"Create a Column object"
macro col_str(x) Column(Symbol(x)) end

export Column, @col_str
