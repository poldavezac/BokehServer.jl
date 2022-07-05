#!/usr/bin/env -S "julia --project=./test"
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
    endswith(path, ".jl")             || return false
    (basename(path) == "__init__.jl") && return false
    (path == @__FILE__)               && return false
    isempty(FILES)                    && return true
    name = path[length(@__DIR__)+2:end]
    return !all(isnothing(match(i, name)) for i ∈ FILES)
end

accepttestset(name::Expr) = isempty(TESTS)
function accepttestset(name::String)
    isempty(TESTS) && return true
    return !all(isnothing(match(i, name)) for i ∈ TESTS)
end

ENV["BOKEH_CONFIG"] = string((; throwonerror = true))

function hasacceptedchild(expr::Expr)
    todos = [expr]
    while !isempty(todos)
        cur = pop!(todos)
        if (
            cur isa Expr &&
            cur.head ≡ :macrocall &&
            cur.args[1] ≡ Symbol("@testset")
        )
            accepttestset(cur.args[3]) && return true
            if length(cur.args) > 3
                append!(todos, filter(((x)->x isa Expr), cur.args[4].args))
            end
        elseif cur isa Expr
            append!(todos, filter(((x)->x isa Expr), cur.args))
        end
    end
    return false
end

function istestsetexpr(expr)
    return (
        expr isa Expr &&
        expr.head ≡ :macrocall &&
        expr.args[1] ≡ Symbol("@testset")
    )
end

function applycmdargs(expr)
    if expr isa Expr && expr.head ≡ :module
        foreach(applycmdargs, expr.args)
    elseif istestsetexpr(expr) && !hasacceptedchild(expr)
        expr.args[4] = Expr(:block)
    end
    return expr
end

function hasacceptedfile(dir::String)
    any(
        isfile(path) ? acceptfile(path) : hasacceptedfile(path)
        for path ∈ readdir(dir; join = true)
    )
end

function visitfiles(dir::String; force :: Bool = false)
    mdl = Module()
    mdleval = Base.Fix1(mdl.eval, mdl)
    mdleval(quote
        using Core
        using Base
        using Logging
        using BokehJL
        using Test: @test, @testset, @test_throws
        using Main: istestsetexpr

        Core.eval(x...) = Base.eval($mdl, x...)
    end)
    hasacceptedfile(dir) || return

    cmd = applycmdargs
    if isfile(joinpath(dir, "__init__.jl"))
        Base.include(mdl, joinpath(dir, "__init__.jl"))
        (:test_include ∈ names(mdl)) && (cmd = applycmdargs∘mdl.test_include)
    end
    for path ∈ readdir(dir; join = true)
        if isdir(path)
            mdleval(:(@testset $("$(basename(path))") begin
                $visitfiles($path; force = $(acceptfile(path)))
            end))
        else

            acceptfile(path) && mdleval(:(@testset $("$(basename(path))") begin
                $(Base.include)($cmd, $mdl, $path)
            end))
        end
    end
end

visitfiles(@__DIR__)
