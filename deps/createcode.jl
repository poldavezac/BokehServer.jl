#!/usr/bin/env -S julia --startup-file=no --history-file=no --project=./deps
push!(LOAD_PATH, joinpath((@__DIR__), ".."), joinpath((@__DIR__), "src"))
ENV["CODE_CREATION"] = "True"
using CodeCreator
(abspath(PROGRAM_FILE) == @__FILE__) && CodeCreator.createcode()
