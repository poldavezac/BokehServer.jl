#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
"""Example implementation of two double ended sliders as extension widgets"""

using BokehServer

@BokehServer.model mutable struct IonRangeSlider <: BokehServer.Models.iInputWidget
    # The special class attribute ``__implementation__`` should contain a string
    # of JavaScript or TypeScript code that implements the web browser
    # side of the custom extension model or a string name of a file with the implementation.

    __implementation__ = "ion_range_slider.ts"
    __javascript__ = [
        "https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js",
        "https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.1.4/js/ion.rangeSlider.js",
    ]

    # In Bokeh3, we add the css to the typescript code because of the use of shadow-roots 
    # __css__ = [
    #     "https://cdnjs.cloudflare.com/ajax/libs/normalize/4.2.0/normalize.css",
    #     "https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.1.4/css/ion.rangeSlider.css",
    #     "https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.1.4/css/ion.rangeSlider.skinFlat.min.css",
    # ]

    # Below are all the "properties" for this model. Bokeh properties are
    # class attributes that define the fields (and their types) that can be
    # communicated automatically between Python and the browser. Properties
    # also support type validation. More information about properties in
    # can be found here:
    #
    #    https://docs.bokeh.org/en/latest/docs/reference/core/properties.html#bokeh-core-properties

    """Enable or disable the slider."""
    disable :: Bool = true

    """Show or hide the grid beneath the slider."""
    grid :: Bool = true

    """The minimum allowable value."""
    start :: Float64 = 0.

    """The maximum allowable value."""
    finish :: Float64 = 1.

    """The start and end values for the range."""
    range  :: Tuple{Float64, Float64}

    """The step between consecutive values. """
    step  :: Float64 = .1

    align :: Union{Tuple{BokehServer.Model.EnumType{(:start, :center, :end)}, BokehServer.Model.EnumType{(:start, :center, :end)}}, BokehServer.Model.EnumType{(:auto, :start, :center, :end)}} = :auto

    aspect_ratio :: Union{Nothing, Float64, BokehServer.Model.EnumType{(:auto,)}} = nothing

    classes :: Vector{String} = String[]

    context_menu :: Union{Nothing, BokehServer.Models.Menu} = nothing

    css_classes :: Vector{String} = String[]

    description :: Union{Nothing, BokehServer.Models.Tooltip, String} = nothing

    disabled :: Bool = false

    flow_mode :: BokehServer.Model.EnumType{(:block, :inline)} = :block

    height :: Union{Nothing, BokehServer.Model.NonNegativeInt} = nothing

    height_policy :: BokehServer.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    margin :: Union{Nothing, Int64, Tuple{Int64, Int64}, NTuple{4, Int64}} = nothing

    max_height :: Union{Nothing, BokehServer.Model.NonNegativeInt} = nothing

    max_width :: Union{Nothing, BokehServer.Model.NonNegativeInt} = nothing

    min_height :: Union{Nothing, BokehServer.Model.NonNegativeInt} = nothing

    min_width :: Union{Nothing, BokehServer.Model.NonNegativeInt} = nothing

    resizable :: Union{Bool, BokehServer.Model.EnumType{(:width, :height, :both)}} = false

    sizing_mode :: Union{Nothing, BokehServer.Model.EnumType{(:stretch_width, :stretch_height, :stretch_both, :scale_width, :scale_height, :scale_both, :fixed)}} = nothing

    styles :: Union{BokehServer.Models.Styles, Dict{String, Union{Nothing, String}}} = Dict{String, Union{Nothing, String}}()

    stylesheets :: Vector{Union{Dict{String, Union{BokehServer.Models.Styles, Dict{String, Union{Nothing, String}}}}, String}} = Union{Dict{String, Union{BokehServer.Models.Styles, Dict{String, Union{Nothing, String}}}}, String}[]

    title :: String = ""

    visible :: Bool = true

    width :: Union{Nothing, BokehServer.Model.NonNegativeInt} = nothing

    width_policy :: BokehServer.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end

BokehServer.serve() do
    x = 0.005 .*(2:197)
    source = BokehServer.Source("x" => x, "y" => x)

    plot = BokehServer.figure(width=400, height=400)
    BokehServer.line!(plot; x = "x", y = "y", source=source, line_width=3, line_alpha=0.6, color="#ed5565")

    slider = BokehServer.Slider(;start=0, finish=5, step=0.1, value=1, title="Bokeh Slider - Power")
    BokehServer.js_onchange(slider, :value;
        args=Dict{String, Any}("source"=>source),
        code="""
            const data = source.data;
            const f = cb_obj.value
            const x = data['x']
            const y = data['y']
            for (let i = 0; i < x.length; i++) {
                y[i] = Math.pow(x[i], f)
            }
            source.change.emit();
        """)

    ion_range_slider = IonRangeSlider(start=0.01, finish=0.99, step=0.01, range=(first(x), last(x)),
        title="Ion Range Slider - Range")
    BokehServer.js_onchange(ion_range_slider, :range;
       args=Dict{String, Any}("source"=>source),
       code="""
           const data = source.data;
           const f = cb_obj.range
           const x = data['x']
           const y = data['y']
           const pow = (Math.log(y[100])/Math.log(x[100]))
           console.log(pow)
           const delta = (f[1] - f[0])/x.length
           for (let i = 0; i < x.length; i++) {
               x[i] = delta*i + f[0]
               y[i] = Math.pow(x[i], pow)
           }
           source.change.emit();
       """)

    BokehServer.layout([plot; slider; ion_range_slider])
end
