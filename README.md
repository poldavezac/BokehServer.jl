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
