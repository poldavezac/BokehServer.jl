#!/usr/bin/env -S "julia --project=./test"
using Test: @test, @testset
using ArgParse

SETTINGS = let s = ArgParseSettings()
    @add_arg_table! s begin
        "--file"
            help = "an option with an argument"
            nargs= '+'
        "--test"
            help = "an option with an argument"
            nargs= '+'
    end
    parse_args(s)
end

const FILES = [Regex(i) for i ∈ SETTINGS["file"]]
const TESTS = [Regex(i) for i ∈ SETTINGS["test"]]

function acceptfile(path::String)
    isempty(FILES) && return true
    name = path[length(@__DIR__)+2:end]
    return !all(isnothing(match(i, name)) for i ∈ FILES)
end

function accepttestset(name::String)
    isempty(TESTS) && return true
    return !all(isnothing(match(i, name)) for i ∈ TESTS)
end

using Bokeh

for path ∈ readdir(@__DIR__; join = true)
    isfile(path) || continue
    (path != @__FILE__) || continue
    endswith(path, ".jl") || continue

    @testset "$(basename(path))" begin
        include(path) do expr
            if (
                expr isa Expr &&
                expr.head ≡ :macrocall &&
                expr.args[1] ≡ Symbol("@testset") &&
                (
                    !acceptfile(path) ||
                    !accepttestset(expr.args[3])
                )
            )
                expr.args[4] = Expr(:block)
            end
            expr
        end
    end
end
