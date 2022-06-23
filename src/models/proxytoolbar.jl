#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ProxyToolbar <: iProxyToolbar

    autohide :: Bool = false

    logo :: Model.Nullable{Model.EnumType{(:normal, :grey)}} = :normal

    toolbars :: Vector{iToolbar} = iToolbar[]

    tools :: Vector{iTool} = iTool[]
end
