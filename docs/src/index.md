# BokehJL: a Bokeh server in Julia

## Goals

It seemed *Julia* was missing a reactive plot library, meaning one which would
react to changes in the data when used with *Pluto* or *IJulia*. This package
tries to bring these features by relying on the excellent
(*bokeh*)[https://docs.bokeh.org/en/latest/index.html] library. The latter is
basically a python web server with a javascript client. This package reproduces
the python server and reuses the javascript part as is. This package's API is
loosely similar to its python counterpart.

## Getting Started

A number of examples are provided in the `examples` directory. All of them involve starting a server which deals with a single dashboard.
Other options are available by looking at the `BokehJL.Server.server` documentation.

We try to keep a similar API to the one provided by *python bokeh*. The main differences are due to *Julia*'s aversion to instance or class methods.
A python call `fig.scatter([1, 2, 3], [3, 2, 1])` becomes `scatter!(fig; x = [1, 2, 3], y = [3, 2, 1])`. Note that:

1. Julia relies on free functions. Thus the call usually involves adding the current plot as first argument.
2. Julia suggests using a `!` when a function mutates its first argument. Thus our free functions:

   * without a `!`, will create a plot, feed it to the `!`-ended free function, finally returning said plot.
   * with a `!`, will require a plot as first argument. The function usually adds one or more renderers to the plot.

3. We decided to heavily rely on keywords. Usually, the plot is the single positional argument required by our API.
   This is different from *python bokeh* which prefers to defines a list of positional arguments and a list of keywords for its API.

### Using Jupyter or Pluto

Example notebooks are `examples/jupyter_notebook.ipynb` and `examples/pluto_notebook.jl`.

Using the library requires two initial lines:

```julia
using BokehJL # import our library
BokehJL.Embeddings.notebook()  # provide javascript headers to your browser. 
```

Any layout or plot returned by a cell is then displayed in the notebook.
Changes occurring in julia in other cells will affect this display:

```julia
begin
# display a time series, with default indices on the `x` axis.
# keep a reference to `plot` for additional changes
plot = BokehJL.line(; y = randn(Float64, 100) .+ (1:100))
plot
end
```

```
begin
# update the time series in another cell
push!(
    plot.renderers[1].data_source,
    Dict("y" => randn(Float64, 100) .+ (100:-1:1), "x" => 101:200)
)
nothing
end
```

**Warning** We need the second line to be the last in the cell! This is so the *bokehjs*
library is added to the browser page. In particular, `Jupyter` will only succeed 
the second time a plot is created if we forget this line.


In the background, a *websocket* server is created which will synchronize your
*BokehJL* objects in *Julia* with their *typescript* counterparts. It will also
manage the event mechanism provided by *BokehJL*.

### Using a BokehJL server

Examples abound in the `examples` directory. They all involve using:

```julia
BokehJL.Plotting.serve() do
    plot = figure() # create a plot
    ...
    plot # return the plot
end
```

** Warning ** For simple cases, *BokehJL* objects should be created within the
`do ... end` scope. This is because of our event mechanism which requires
adding an event manager in the task's local storage. This is implicitely done
for the user within this scope, although other strategies are available to
advanced users.

## Available plots

One can create a plot using:

```@docs
BokehJL.figure
```

The following types of plots are available, with and without the `!`:

```@docs
BokehJL.annularwedge!
```

```@docs
BokehJL.annulus!
```

```@docs
BokehJL.arc!
```

```@docs
BokehJL.areastack!
```

```@docs
BokehJL.barstack!
```

```@docs
BokehJL.bezier!
```

```@docs
BokehJL.boxplot!
```

```@docs
BokehJL.circle!
```

```@docs
BokehJL.ellipse!
```

```@docs
BokehJL.glyph!
```

```@docs
BokehJL.graph!
```

```@docs
BokehJL.harea!
```

```@docs
BokehJL.hbar!
```

```@docs
BokehJL.hextile!
```

```@docs
BokehJL.image!
```

```@docs
BokehJL.imagergba!
```

```@docs
BokehJL.imageurl!
```

```@docs
BokehJL.line!
```

```@docs
BokehJL.linestack!
```

```@docs
BokehJL.multiline!
```

```@docs
BokehJL.multipolygons!
```

```@docs
BokehJL.oval!
```

```@docs
BokehJL.patches!
```

```@docs
BokehJL.quad!
```

```@docs
BokehJL.quadratic!
```

```@docs
BokehJL.ray!
```

```@docs
BokehJL.rect!
```

```@docs
BokehJL.scatter!
```

```@docs
BokehJL.segment!
```

```@docs
BokehJL.text!
```

```@docs
BokehJL.varea!
```

```@docs
BokehJL.vbar!
```

```@docs
BokehJL.wedge!
```

### Layouts

Multiple plots can be displayed together using:

```@docs
BokehJL.layout
```

Their axes can be linked, either using the event mechanisms or by sharing a `Range1d` object.

```
plot1 = BokehJL.scatter(;
    x       = randn(Float64, 100),
    y       = randn(Float64, 100),
)
plot2 = BokehJL.scatter(;
    x       = randn(Float64, 100),
    y       = randn(Float64, 100),
)

# make sure plot2 reacts to plot1 mutations
BokehJL.onchange(plot1.x_range) do evt::BokehJL.ModelChangedEvent
    setproperty!(plot2.x_range, evt.attr, evt.new)
end

# make sure plot1 reacts to plot2 mutations
BokehJL.onchange(plot2.x_range) do evt::BokehJL.ModelChangedEvent
    setproperty!(plot1.x_range, evt.attr, evt.new)
end

BokehJL.layout([plot1, plot2])
```

```
plot1 = BokehJL.scatter(;
    x       = randn(Float64, 100),
    y       = randn(Float64, 100),
    x_range = BokehJL.Models.Range1d(; start = -10, finish = 10)
)
plot2 = BokehJL.scatter(;
    x       = randn(Float64, 100),
    y       = randn(Float64, 100),
    x_range = plot1.x_range
)
BokehJL.layout([plot1, plot2])
```

## The package architecture

*BokehJL* provides the same services as *python*'s *bokeh*:

* Means for mirroring the *typescript* library *bokehjs*.
* An event mechanism for reacting to changes to the *Julia* objects.
* A *websocket* server for synchronizing objects between *Julia* and *typescript*.

The code is divided in:

* a `core` directory which provides:

    * macros for mirroring javascript objects, namely `@model`, see the `core/model` directory.
    * some type extensions and conversions mechanisms for seemlessly converting *typescript* values to *Julia*, namely `bokehconvert`, see the `core/model/properties` directory.
    * an event mechanism for reacting to changes in objects wrapped with `@model`, see `core/events`
    * a server, see `core/server` and its protocol, see `core/protocol` for dealing with synchronisation.

* a `models` directory, created by automatically parsing the python code. It contains all structures corresponding to *typescript* classes.
* a `plotting` directory, providing a plotting interface.
