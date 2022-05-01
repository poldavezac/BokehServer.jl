using Test: @test, @testset
using Bokeh

for file ∈ readdir(@__DIR__; join = true)
    (isfile(file) && (file != @__FILE__) && endswith(file, ".jl")) || continue

    @testset "$(basename(file))" begin
        include(file)
    end
end
