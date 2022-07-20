#!/usr/bin/env -S julia --startup-file=no --history-file=no --project=./docs
using Documenter
using Pkg
Pkg.activate(".")
using BokehJL

makedocs(sitename="BokehJL Documentation")
