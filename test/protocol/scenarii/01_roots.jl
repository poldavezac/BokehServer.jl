@testset "add roots" begin
    (srv, _) = @runscenario begin
        push!(doc, X(; a = 1))
        push!(doc, X(; a = 2))
    end
    @test length(srv.roots) == 2
end

@testset "remove roots" begin
    (srv, _) = @runscenario X(; a = 1) X(; a = 2) delete!(doc, doc.roots[1])
    @test length(srv.roots) == 1
end

@testset "add complex root" begin
    (srv, _) = @runscenario push!(doc, Cnt(; a = [X(;a =2)], b = Dict("a"=>X(;a = 3))))
    @test length(srv.roots) == 1
end
