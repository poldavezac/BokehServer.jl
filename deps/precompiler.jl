#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
mktempdir() do root
    run(`julia --trace-compile=$(joinpath(root, "instr.jl")) deps/precompile_script.jl`)
    open(joinpath(root, "instr.jl")) do io
        for i ∈ eachline(io)
            if startswith(i, "precompile(Tuple{BokehJL")
                println(i)
            end
        end
    end
end
