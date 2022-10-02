#!/usr/bin/env -S julia --startup-file=no --history-file=no
using Pkg
path = joinpath(@__DIR__, "deps")
Pkg.activate(path)
Pkg.instantiate()
include(joinpath(path, "createcode.jl"))
CodeCreator.template(stdout, ARGS[1])
