# BokehServer: a Bokeh server in Julia

## Goals

It seemed *Julia* was missing a reactive plot library, meaning one which would
react to changes in the data when used with *Pluto* or *IJulia*. This package
tries to bring these features by relying on the excellent
(*Bokeh*)[https://docs.bokeh.org/en/latest/index.html] library. The latter is
basically a python web server with a javascript client. This package reproduces
the python server and reuses the javascript part as is. This package's API is
loosely similar to its python counterpart.

## Getting Started

A number of examples are provided in the `examples` directory. These usually involve starting a server:

```julia
BokehServer.serve() do
    BokehServer.line(rand(Float64, 100))
end
```

One could also create a stand-alone html page:

```julia
BokehServer.html() do
    BokehServer.line(rand(Float64, 100))
end
```

We try to keep a similar API to the one provided by [Bokeh](https://docs.bokeh.org/en/latest/index.html). The main
differences are due to *Julia*'s aversion to instance or class methods. A
python call `fig.line([1, 2, 3])` becomes `line!(fig; y = [1, 2, 3])`. In other words:

1. Julia relies on free functions. Thus the call requires adding the current plot as first argument.
2. Julia suggests using a `!` when a function mutates its first argument. Thus our free functions:

   * without a `!`, will create a plot, feed it to the `!`-ended free function, finally returning said plot.
   * with a `!`, will require a plot as first argument. The function usually adds one or more renderers to the plot.

3. Julia makes a clear distinction between positional and keyword arguments, whereas python doesn't. We recreated something similar to
   python's: one will obtain the same plot when writing `line!(fig, 1:10, (1:10).^2)` or `line!(fig; x = 1:10, y = (1:10).^2)`.

### Gallery

Checkout [Bokeh](https://docs.bokeh.org/en/latest/index.html)'s gallery or try the files in the `examples` directory.

### Using Jupyter or Pluto

Example notebooks are `examples/jupyter_notebook.ipynb` and `examples/pluto_notebook.jl`.

Using the library requires two initial lines:

```julia
using BokehServer # import our library
# provide javascript headers to your browser, default port is 5006
BokehServer.Embeddings.notebook(; port = 4321)
```

!!! note "Initializing a notebook environment"

    We need the `notebook` call to be the last in the cell! This is so
    the *bokehjs* library is added to the browser page.

Any layout or plot returned by a cell is then displayed in the notebook.
Changes occurring in julia in other cells will affect this display.

The following will display a time series, with default indices on the `x` axis.

```
plot = BokehServer.line(; y = randn(Float64, 100) .+ (1:100))
```

We can update the previous cell from another:

```
push!(
    plot.renderers[1].data_source,
    Dict("y" => randn(Float64, 100) .+ (100:-1:1), "x" => 101:200)
);
```

In the background, a *websocket* server is created which will synchronize your
*BokehServer* objects in *Julia* with their *typescript* counterparts. It will also
manage the event mechanism provided by *BokehServer*.

### Starting a server or creating a stand-alone html page

Examples abound in the `examples` directory. They all involve using:

```julia
BokehServer.serve() do
    plot = figure() # create a plot
    ...
    plot # return the plot
end
```

!!! note "Stand-alone HTML pages"

    To create a stand-alone page, simply replace `serve` by `html`.

!!! note "The do ... end scope"

    *BokehServer* objects should be created strictly within the `do ... end` scope. This is
    because of the event mechanism is initialized only within this scope.

## Available plots

One can create a plot using:

```@docs
BokehServer.figure
```

The following types of plots are available, with and without the `!`:

```@raw html
    <script type="text/javascript" src="https://cdn.bokeh.org/bokeh/release/bokeh-2.4.2.min.js"></script>
    <script type="text/javascript" src="https://cdn.bokeh.org/bokeh/release/bokeh-gl-2.4.2.min.js"></script>
    <script type="text/javascript" src="https://cdn.bokeh.org/bokeh/release/bokeh-widgets-2.4.2.min.js"></script>
    <script type="text/javascript" src="https://cdn.bokeh.org/bokeh/release/bokeh-tables-2.4.2.min.js"></script>
    <script type="text/javascript" src="https://cdn.bokeh.org/bokeh/release/bokeh-mathjax-2.4.2.min.js"></script>
```

BOXPLOT

```@docs
BokehServer.boxplot!
```

ANNULARWEDGE

```@docs
BokehServer.annularwedge!
```

ANNULUS

```@docs
BokehServer.annulus!
```

ARC

```@docs
BokehServer.arc!
```

AREASTACK

```@docs
BokehServer.areastack!
```

BARSTACK

```@docs
BokehServer.barstack!
```

BEZIER

```@docs
BokehServer.bezier!
```

CIRCLE

```@docs
BokehServer.circle!
```

ELLIPSE

```@docs
BokehServer.ellipse!
```

```@docs
BokehServer.graph!
```

```@docs
BokehServer.harea!
```

```@docs
BokehServer.hbar!
```

```@docs
BokehServer.hextile!
```

```@docs
BokehServer.image!
```

```@docs
BokehServer.imagergba!
```

```@docs
BokehServer.imageurl!
```

LINE

```@docs
BokehServer.line!
```

```@docs
BokehServer.linestack!
```

MULTILINE

```@docs
BokehServer.multiline!
```

```@docs
BokehServer.multipolygons!
```

OVAL

```@docs
BokehServer.oval!
```

```@docs
BokehServer.patches!
```

```@docs
BokehServer.quad!
```

```@docs
BokehServer.quadratic!
```

```@docs
BokehServer.ray!
```

```@docs
BokehServer.rect!
```

```@docs
BokehServer.scatter!
```

```@docs
BokehServer.segment!
```

```@docs
BokehServer.text!
```

```@docs
BokehServer.varea!
```

```@docs
BokehServer.vbar!
```

```@docs
BokehServer.wedge!
```

## Layouts

Multiple plots can be displayed together using:

```@docs
BokehServer.layout
```

### Document roots

As in [Bokeh](https://docs.bokeh.org/en/latest/index.html), users can add and remove roots from a `Document`. This can be done 
using functions `push!(::iDocument, ::iModel)` and `pop!(::iDocument, ::iModel)`:

```julia
doc = BokehServer.Document()
fig = BokehServer.figure()
push!(doc, fig)
@assert length(doc) == 1
pop!(doc, fig)
@assert length(doc) == 0
```

### Linking axes

Their axes can be linked, either using the event mechanisms or by sharing a `Range1d` object.

```
plot1 = BokehServer.scatter(;
    x       = randn(Float64, 100),
    y       = randn(Float64, 100),
)
plot2 = BokehServer.scatter(;
    x       = randn(Float64, 100),
    y       = randn(Float64, 100),
)

# make sure plot2 reacts to plot1 mutations
BokehServer.onchange(plot1.x_range) do evt::BokehServer.ModelChangedEvent
    setproperty!(plot2.x_range, evt.attr, evt.new)
end

# make sure plot1 reacts to plot2 mutations
BokehServer.onchange(plot2.x_range) do evt::BokehServer.ModelChangedEvent
    setproperty!(plot1.x_range, evt.attr, evt.new)
end

BokehServer.layout([plot1, plot2])
```

```
plot1 = BokehServer.scatter(;
    x       = randn(Float64, 100),
    y       = randn(Float64, 100),
    x_range = BokehServer.Range1d(; start = -10, finish = 10)
)
plot2 = BokehServer.scatter(;
    x       = randn(Float64, 100),
    y       = randn(Float64, 100),
    x_range = plot1.x_range
)
BokehServer.layout([plot1, plot2])
```

## The `ColumnDataSource` structure

As in [Bokeh](https://docs.bokeh.org/en/latest/index.html), the `ColumnDataSource` structure is central to
updating plots. The same methods are available for dealing with its mutations:

```@docs
BokehServer.Source
```

```@docs
BokehServer.stream!
```

```@docs
BokehServer.update!
```

```@docs
BokehServer.patch!
```

!!! note

    One can also use `Base.push!` instead of `Base.stream!`.

    One can also use `Base.merge!` instead of `Base.update!` or `Base.patch!`.


## The event mechanism

As with [Bokeh](https://docs.bokeh.org/en/latest/index.html) events can be both triggered from and dealt with both in
*typescript* and *Julia*.

### Creating callbacks in *Julia*

Julia event callbacks are created using `BokehServer.onchange`:

```@docs
BokehServer.onchange
```

As can be seen in the examples:

1. Events are triggered on `Document` or `Model` instances.
2. One can use event types in the signature to filter which events
should trigger a given callback.

Document event types are:

```@docs
BokehServer.RootAddedEvent
```

```@docs
BokehServer.RootRemovedEvent
```

```@docs
BokehServer.TitleChangedEvent
```

Model event types are:

```@docs
BokehServer.ModelChangedEvent
```

```@docs
BokehServer.ColumnsPatchedEvent
```

```@docs
BokehServer.ColumnsStreamedEvent
```

```@docs
BokehServer.ColumnDataChangedEvent
```

UI event types are:

```@docs
BokehServer.DocumentReady
```

```@docs
BokehServer.ButtonClick
```

```@docs
BokehServer.MenuItemClick
```

```@docs
BokehServer.LODStart
```

```@docs
BokehServer.LODEnd
```

```@docs
BokehServer.RangesUpdate
```

```@docs
BokehServer.SelectionGeometry
```

```@docs
BokehServer.Reset
```

```@docs
BokehServer.Tap
```

```@docs
BokehServer.DoubleTap
```

```@docs
BokehServer.Press
```

```@docs
BokehServer.PressUp
```

```@docs
BokehServer.MouseEnter
```

```@docs
BokehServer.MouseLeave
```

```@docs
BokehServer.MouseMove
```

```@docs
BokehServer.PanEnd
```

```@docs
BokehServer.PanStart
```

```@docs
BokehServer.PinchStart
```

```@docs
BokehServer.Rotate
```

```@docs
BokehServer.RotateStart
```

```@docs
BokehServer.RotateEnd
```

```@docs
BokehServer.MouseWheel
```

```@docs
BokehServer.Pan
```

```@docs
BokehServer.Pinch
```

### Details

Events can only be triggered if an event manager has been provided. This is normally done automatically,
although, as in [Bokeh](https://docs.bokeh.org/en/latest/index.html), only is specific cases:

* when initializing a new document
* when responding to a *typescript* message
* when in a `Pluto` or `Jupyter` environment, for cells coming after a call to `BokehServer.Embeddings.notebook()`.

As opposed to [Bokeh](https://docs.bokeh.org/en/latest/index.html), event managers collect all events before triggering
callback and finally synchronizing with *typescript*. Some events might
disappear at any point during collection or callbacks, say if a document root
is mutated then simply removed from the document.

The collection is done thanks to a task-specific manager, hidden inside the `task_local_storage()` dictionnary.

Advanced users could change the manager behavior by creating custom
`BokehServer.Server.Application` types, overloading
`Server.eventlist(::iApplication)`, and providing instances of these
applications to the server. An example is the
`BokehServer.Embeddings.Notebooks.NotebookApp` which deals with the specifics of
working in `Pluto` or `Jupyter` environment.

### Javascript callbacks

Users can provide javascript code, to be executed client-side. This is done using a `CustomJS` object.
The latter is then provided to the model *triggering* the change. One or both these actions can be done using:

```docs
js_onchange
```

```docs
js_onevent
```

```docs
@js_link
```

## Themes

Themes provided by [Bokeh](https://docs.bokeh.org/en/latest/index.html) are also available here.

One can set either a global theme or one specific to a document:

```julia
# set the global theme
BokehServer.Themes.setvalues!(:caliber) # or :dark_minimal, :light_minimal, :contrast, :night_sky or :default

# set the doc theme
BokehServer.Themes.setvalues!(mydoc.theme, :caliber)
```

In most cases where user creates new *BokehServer* objects, a default document has been added
to the `task_local_storage` dictionnary, and its theme is the one applied to those objects.

!!! note

    A new document always inherits a *copy* of the current global theme.

```@autodocs
Modules = [BokehServer.Themes]
```

## Custom models

Custom models can be created and used. Examples are in the `examples/extensions` directory.

These models should follow the following pattern

```
@BokehServer.model mutable struct MyModel <: BokehServer.iModel
    __implementation__ = "path to typescript, relative to current code directory"

    a :: Int = 10
    b :: Vector{Float64} =  [1., 2., 3.]
end
```

Typescript code is required as well. The user is invited to refer to python *Bokeh*.
Other fields `__javascript__`, `__css__`, `__dependencies__` can also be used. Again,
better documentation is available in the python library.


### Creating a template of a derived type

The julia hierarchy system is very different from python's. In particular, one needs to redeclare
all fields for every new structure. A template can be created as follows:

```
julia> path = joinpath(dirname(pathof(BokehServer)), "template.jl")
julia> run(`$path Slider`)  # Slider or any python Bokeh model class name
```

## The package architecture

*BokehServer* provides the same services [Bokeh](https://docs.bokeh.org/en/latest/index.html):

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
