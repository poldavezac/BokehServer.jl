#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
push!(LOAD_PATH, "../")
using Documenter
using BokehJL

makedocs(sitename="BokehJL Documentation")
