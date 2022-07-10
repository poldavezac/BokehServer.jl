module Transforms
using ...Model
using ...Models

""" Create a ``DataSpec`` dict to generate a ``CumSum`` expression
for a ``ColumnDataSource``.

Examples:

    .. code-block:: python

        p.wedge(start_angle=cumsum("angle", include_zero=True),
                end_angle=cumsum("angle"),
                ...)

    will generate a ``CumSum`` expressions that sum the ``"angle"`` column
    of a data source. For the ``start_angle`` value, the cumulative sums
    will start with a zero value. For ``end_angle``, no initial zero will
    be added (i.e. the sums will start with the first angle value, and
    include the last).

"""
function cumsum(field::AbstractString, include_zero:: Bool = false)
    return (; expression = Models.CumSum(; field, include_zero))
end

""" Create a ``DataSpec`` dict that applies a client-side ``Dodge``
transformation to a ``ColumnDataSource`` column.

Args:
    field (str) : a field name to configure ``DataSpec`` with

    value (float) : the fixed offset to add to column data

    range (Range, optional) : a range to use for computing synthetic
        coordinates when necessary, e.g. a ``FactorRange`` when the
        column data is categorical (default::None)

Returns:
    dict

"""
dodge(field::AbstractString, value::AbstractFloat; k...) = (; field, transform = Models.Dodge(; value, k...))

""" Create a ``DataSpec`` dict that applies a client-side
``CategoricalColorMapper`` transformation to a ``ColumnDataSource``
column.

Args:
    field (str) : a field name to configure ``DataSpec`` with

    palette (seq[color]) : a list of colors to use for colormapping

    factors (seq) : a sequences of categorical factors corresponding to
        the palette

    start (int, optional) : a start slice index to apply when the column
        data has factors with multiple levels. (default::0)

    end (int, optional) : an end slice index to apply when the column
        data has factors with multiple levels. (default::None)

    nan_color (color, optional) : a default color to use when mapping data
        from a column does not succeed (default::"gray")

Returns:
    dict

"""
function factor_cmap(field::AbstractString, palette::AbstractVector, factors::Model.FactorSeq; k...)
    return (; field, transform = Models.CategoricalColorMapper(; palette, factors, k...))
end

""" Create a ``DataSpec`` dict that applies a client-side
``CategoricalPatternMapper`` transformation to a ``ColumnDataSource``
column.

Args:
    field (str) : a field name to configure ``DataSpec`` with

    patterns (seq[string]) : a list of hatch patterns to use to map to

    factors (seq) : a sequences of categorical factors corresponding to
        the palette

    start (int, optional) : a start slice index to apply when the column
        data has factors with multiple levels. (default::0)

    end (int, optional) : an end slice index to apply when the column
        data has factors with multiple levels. (default::None)

Returns:
    dict

Added in version 1.1.1

"""
function factor_hatch(field::AbstractString, patterns::AbstractVector, factors::Model.FactorSeq; k...)
    return (; field, transform = Models.CategoricalPatternMapper(; patterns, factors, k...))
end

""" Create a ``DataSpec`` dict that applies a client-side
``CategoricalMarkerMapper`` transformation to a ``ColumnDataSource``
column.

.. note::
    This transform is primarily only useful with ``scatter``, which
    can be parameterized by glyph type.

Args:
    field (str) : a field name to configure ``DataSpec`` with

    markers (seq[string]) : a list of markers to use to map to

    factors (seq) : a sequences of categorical factors corresponding to
        the palette

    start (int, optional) : a start slice index to apply when the column
        data has factors with multiple levels. (default::0)

    end (int, optional) : an end slice index to apply when the column
        data has factors with multiple levels. (default::None)

Returns:
    dict

"""
function factor_mark(field::AbstractString, markers::AbstractVector, factors::Model.FactorSeq; k...)
    return (; field, transform = Models.CategoricalMarkerMapper(; markers, factors, k...))
end

""" Create a ``DataSpec`` dict that applies a client-side ``Jitter``
transformation to a ``ColumnDataSource`` column.

Args:
    field (str) : a field name to configure ``DataSpec`` with

    width (float) : the width of the random distribution to apply

    mean (float, optional) : an offset to apply (default::0)

    distribution (str, optional) : ``"uniform"`` or ``"normal"``
        (default::``"uniform"``)

    range (Range, optional) : a range to use for computing synthetic
        coordinates when necessary, e.g. a ``FactorRange`` when the
        column data is categorical (default::None)

Returns:
    dict

"""
jitter(field::AbstractString, width::AbstractFloat; k...)  = (; field, transform = Models.Jitter(; width, k...))

""" Create a ``DataSpec`` dict that applyies a client-side
``LinearColorMapper`` transformation to a ``ColumnDataSource`` column.

Args:
    field (str) : a field name to configure ``DataSpec`` with

    palette (seq[color]) : a list of colors to use for colormapping

    low (float) : a minimum value of the range to map into the palette.
        Values below this are clamped to ``low``.

    high (float) : a maximum value of the range to map into the palette.
        Values above this are clamped to ``high``.

    low_color (color, optional) : color to be used if data is lower than
        ``low`` value. If None, values lower than ``low`` are mapped to the
        first color in the palette. (default::None)

    high_color (color, optional) : color to be used if data is higher than
        ``high`` value. If None, values higher than ``high`` are mapped to
        the last color in the palette. (default::None)

    nan_color (color, optional) : a default color to use when mapping data
        from a column does not succeed (default::"gray")

"""
function linear_cmap(
        field      :: AbstractString,
        palette    :: AbstractVector,
        low        :: AbstractFloat,
        high       :: AbstractFloat;
        k...
)
    return (; field, transform = Models.LinearColorMapper(; palette, low, high, k...))
end

""" Create a ``DataSpec`` dict that applies a client-side ``LogColorMapper``
transformation to a ``ColumnDataSource`` column.

Args:
    field (str) : a field name to configure ``DataSpec`` with

    palette (seq[color]) : a list of colors to use for colormapping

    low (float) : a minimum value of the range to map into the palette.
        Values below this are clamped to ``low``.

    high (float) : a maximum value of the range to map into the palette.
        Values above this are clamped to ``high``.

    low_color (color, optional) : color to be used if data is lower than
        ``low`` value. If None, values lower than ``low`` are mapped to the
        first color in the palette. (default::None)

    high_color (color, optional) : color to be used if data is higher than
        ``high`` value. If None, values higher than ``high`` are mapped to
        the last color in the palette. (default::None)

    nan_color (color, optional) : a default color to use when mapping data
        from a column does not succeed (default::"gray")

"""
function log_cmap(
        field      :: AbstractString,
        palette    :: AbstractVector,
        low        :: AbstractFloat,
        high       :: AbstractFloat;
        k...
)
    return (; field, transform = Models.LogColorMapper(; palette, low, high, k...))
end

""" Create a Create a ``DataSpec`` dict to generate a ``Stack`` expression
for a ``ColumnDataSource``.

Examples:

    .. code-block:: python

        p.vbar(bottom=stack("sales", "marketing"), ...

    will generate a ``Stack`` that sums the ``"sales"`` and ``"marketing"``
    columns of a data source, and use those values as the ``top``
    coordinate for a ``VBar``.

"""
stack(fields::Vararg{AbstractString}) = (; expression = Models.Stack(fields))
end
