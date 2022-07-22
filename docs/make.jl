#!/usr/bin/env -S julia --startup-file=no --history-file=no --project=./docs
using Pkg
Pkg.develop(PackageSpec(path=pwd()))
Pkg.instantiate()

using Documenter
using BokehServer

makedocs(sitename="BokehServer Documentation")
deploydocs(; repo="poldavezac/BokehServer.jl", devbranch = "main")
