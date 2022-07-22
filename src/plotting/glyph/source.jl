"""
    _👻bokehspecs(𝑇::Type{<:Models.iModel})

Iterates over `(field, fieltype)` tuples, only selecting `fieldtype <: iSpec` ones.
"""
function _👻bokehspecs(𝑇::Type{<:Models.iModel})
    return (
        i
        for i ∈ Model.bokehfields(𝑇)
        if let j = last(i)
            (j <: Model.iSpec) || j ≡ Model.NullDistanceSpec || j ≡ Model.NullStringSpec
        end
    )
end

"""
    _👻runchecks(rend::Models.GlyphRenderer)

Checks that the data-source has all required columns
"""
function _👻runchecks(rend::Models.GlyphRenderer)
    cols   = Set{String}()
    hascol = ∈(keys(rend.data_source.data))
    errs   = String[]
    for name ∈ (:glyph, :muted_glyph, :selection_glyph, :nonselection_glyph, :hover_glyph)
        glyph = getproperty(rend, name)
        (glyph isa Models.iGlyph) || continue
        for (col, _) ∈ _👻bokehspecs(typeof(glyph))
            val   = getfield(glyph, col)
            isnothing(val) && continue

            field = val.field
            ismissing(field) || hascol(field) || push!(errs, "$name.$col = \"$field\"")
        end
    end
    isempty(errs) || throw(ErrorException("Missing or miss-spelled fields: $(join(errs, ", "))"))
end

"""
    _👻datasource!(𝐹::Function, kwargs, 𝑇::Type)

iterate over all iSpec properties and see what to do with the data_source
"""
function _👻datasource!(𝐹::Function, kwargs, 𝑇::Type)
    pairs = Tuple{Symbol, Any, Type}[]
    specs = Dict(_👻bokehspecs(𝑇))

    # look through iSpec properties, deal with arrays
    for (col, p𝑇) ∈ specs
        if haskey(kwargs, col)
            arg = kwargs[col]
        elseif col ∈ Models.glyphargs(𝑇)
            val = Model.themevalue(𝑇, col)
            isnothing(val) && throw(ErrorException("Missing argument $𝑇.$col"))
            arg = something(val)
        else
            continue
        end
        push!(pairs, (col, arg, p𝑇))
    end

    # deal with color & alpha ...
    isinprops = ∈(Model.bokehproperties(𝑇))
    for (col, arg) ∈ collect(kwargs)
        (arg isa AbstractVector) || continue
        isinprops(col) && continue

        # check whether col is trait (color, alpha, ...)
        opts = let val = split("$col", '_')
            filter(
                isinprops,
                if length(val) ≡ 1
                    [Symbol("$(i)_$col") for i ∈ _👻VISUALS]
                elseif val[1] ∈ _👻PREFIXES && length(val) ≡ 3
                    [Symbol("$(val[2])_$(val[3])")]
                else
                    []
                end
            )
        end

        (opts ⊈ keys(specs)) && continue
        p𝑇 = specs[opts[1]]
        any(p𝑇 ≢ specs[opts[i]] for i ∈ 2:length(opts)) && continue

        push!(pairs, (col, arg, p𝑇))
    end

    for (col, arg, p𝑇) ∈ pairs
        cnv = Model.bokehconvert(p𝑇, arg)
        msg = if cnv isa Model.Unknown && !(arg isa AbstractArray)
            throw(ErrorException("Not supported: `$𝑇.$col::$(p𝑇) = $arg::$(typeof(arg))"))
        else
            𝐹(col, arg, cnv, p𝑇)
        end

        (msg ≡ arg) || push!(kwargs, col => msg)
    end
end

"""
    _👻datasource!(kwargs::Dict{Symbol}, ::Missing, 𝑇::Type)

iterate over all iSpec properties and create a data_source
"""
function _👻datasource!(kwargs::Dict{Symbol}, ::Missing, 𝑇::Type)
    data = Dict{String, AbstractArray}()

    # add missing :x or :y
    if (:x, :y) ⊆ Models.glyphargs(𝑇)
        if !haskey(kwargs, :x) && get(kwargs, :y, nothing) isa AbstractArray
            kwargs[:x] = 1:length(kwargs[:y])
        elseif !haskey(kwargs, :y) && get(kwargs, :x, nothing) isa AbstractArray
            kwargs[:y] = 1:length(kwargs[:x])
        end
    end

    _👻datasource!(kwargs, 𝑇) do col, arg, cnv, p𝑇
        if cnv isa Model.iSpec && !ismissing(cnv.field)
            throw(ErrorException("Argument `$col` has a source-type entry, yet no source was provided"))
        elseif cnv isa Model.Unknown && arg isa AbstractArray
            # no conversion for :x and :y as the indexes can be factors or numbers
            data["$col"] = col ∈ (:x, :y) ? arg : Model.datadictarray(p𝑇, arg)
            (; field = "$col")
        else
            arg
        end
    end

    return Models.ColumnDataSource(; data)
end

"""
    _👻datasource!(kwargs::Dict{Symbol}, src::Models.ColumnDataSource, 𝑇::Type)

iterate over all iSpec properties and check that the provided fields are in the data_source
"""
function _👻datasource!(kwargs::Dict{Symbol}, src::Models.ColumnDataSource, 𝑇::Type)
    data = src.data
    _👻datasource!(kwargs, 𝑇) do col, arg, cnv, _
        if arg isa AbstractArray
            throw(ErrorException("Argument `$col` is a vector even though a data source has also been provided"))
        else
            arg
        end
    end
    return src
end

function _👻datasource!(kwargs::Dict{Symbol}, src::AbstractDict, 𝑇::Type)
    _👻datasource!(kwargs, Models.ColumnDataSource(; data = Model.bokehconvert(DataDict, src)), 𝑇)
end

function _👻datasource!(kwargs::Dict{Symbol}, src, 𝑇::Type)
    dic = if applicable(eachcol, src) && applicable(names, src)
        zip(names(src), eachcol(src)) # this should be a DataFrames.DataFrame 
    else
        pairs(src)
    end
    _👻datasource!(kwargs, Dict((string(i) => j for (i, j) ∈ dic)...), 𝑇)
end
