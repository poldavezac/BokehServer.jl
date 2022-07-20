# Python's *bokeh* library in Julia

## Goals

It seemed *Julia* was missing a reactive plot library, meaning one which would
react to changes in the data when used with *Pluto* or *IJulia*. This package
tries to bring these features by relying on the excellent
(*bokeh*)[https://docs.bokeh.org/en/latest/index.html] library. The latter is
basically a python web server with a javascript client. This package reproduces
the python server and reuses the javascript part as is. This package's API is
loosely similar to its python counterpart.

## Examples

Examples are available in the *examples* directory. One such one would be

```julia
using BokehJL

BokehJL.Plotting.serve() do
    fig = BokehJL.figure(x_axis_label = "time", y_axis_label = "energy")
    y   = rand(1:100, 100)
    BokehJL.line!(fig; y, color = :blue)
    BokehJL.scatter!(fig; y, color = :red)

    fig
end
```

** Note ** Within a notebook, one needs a cell to return `BokehJL.Embeddings.notebook()`
for plots to be displayed and typescript <-> julia synchronisation to occur:

In the first cell, do:

```
using BokehJL
BokehJL.Embeddings.notebook(port = 7788)
```

Then another can contain

```julia
"A simple plot"
FIG = BokehJL.line(; x = 1:10, y = 1:10)

"The data source used by the plot"
DATA = FIG.renderers[1].data_source

"A button which adds a datapoint when clicked"
BTN = let btn = BokehJL.Models.Button(; label = "add a data point")

    # Note that the `onchange` call only reacts to `ButtonClick` events
    BokehJL.onchange(btn) do evt::BokehJL.Models.Actions.ButtonClick
        BokehJL.stream!(
            DATA,
            Dict("x" => [length(DATA.data["x"])+1], "y" => [rand(1:10)])
        )
    end
    btn
end

"A display with both the plot and the button"
BokehJL.layout([FIG, BTN])
```

## *bokeh* / *BokehJL* differences

* This package provdes all models already existing in *bokeh* and *bokehjs*.
This is done by programmatically parsing the python *bokeh* and creating our
own code. Hopefully further *bokeh* versions will not affect this too much.
* This package should work out-of-the-box both with `IJulia` and `Pluto`.
* Because `end` is a julia keyword, all class attributes starting with `end` in
*bokeh* start with `finish` in *BokehJL*. The protocol hides this from the
*bokehjs* library.
* This package does not yet have a mechanism for adding custom classes with
their typescript code.
* This package does not deliver a full web server. There is no authentification mechanism, for example.
The package does provide routes and a bare-bone web server. The idea is rather to have users add the routes 
to their own server rather than use this package's.
* This package does not provide a `bokeh` executable. Rather, the user should
call `BokehJL.Plotting.server(f)` where `f` must return the `BokehJL` layout
instance, say one plot. Check the doc on `BokehJL.serve` for other options.
