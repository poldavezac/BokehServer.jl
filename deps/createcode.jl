#!/usr/bin/env -S julia --startup-file=no --history-file=no --project=./deps
push!(LOAD_PATH, joinpath((@__DIR__), ".."), joinpath((@__DIR__), "src"))
using CodeCreator

if abspath(PROGRAM_FILE) == @__FILE__
    if isempty(ARGS)
        CodeCreator.createcode()
    elseif "--python" ∈ ARGS || "-p" ∈ ARGS
        CodeCreator.customcode(stdout, (i for i in ARGS if i ∉ ("--python", "-p"))...)
    elseif "--template" ∈ ARGS || "-t" ∈ ARGS
        CodeCreator.template(stdout, (i for i in ARGS if i ∉ ("--template", "-t"))...)
    else
        println("""
        ./deps/createcode.jl

        -h, --help: help message
        -p, --python: followed by python module names,
            it prints out the julia structs for Bokeh
            custom models in these modules.
        -t, --template: followed by a Bokeh model,
            it prints out its julia struct
        """)
    end
end
