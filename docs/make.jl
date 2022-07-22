#!/usr/bin/env -S julia --startup-file=no --history-file=no --project=./docs
using Pkg
Pkg.develop(PackageSpec(path=pwd()))
Pkg.instantiate()

using Documenter
using BokehJL

makedocs(sitename="BokehJL Documentation")
deploydocs(; repo="poldavezac/BokehJL", devbranch = "main")
