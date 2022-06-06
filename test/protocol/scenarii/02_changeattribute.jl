@testset "change number" begin
    @runscenario X(; a = 10) X(; a = 50) begin
        doc.roots[1].a = 1
        doc.roots[2].a = 1
        doc.roots[1].a = 10  # reverting just for fun
    end
end

@testset "change vector" begin
    (srv, _ ) = @runscenario Cnt(; a = [X(;a =2)]) push!(doc.roots[1].a, X(;a = 3))
    @test length(srv.roots[1].a) == 2

    (srv, _ ) = @runscenario Cnt(; a = [X(;a =2)]) depushleteat!(doc.roots[1].a, 1)
    @test length(srv.roots[1].a) == 0
end

@testset "change dict" begin
    (srv, _ ) = @runscenario Cnt(; b = Dict("a"=>X(;a =2))) push!(doc.roots[1].b, "b"=>X(;a = 3))
    @test length(srv.roots[1].b) == 2

    (srv, _ ) = @runscenario Cnt(; b = Dict("a"=>X(;a =2))) delete!(doc.roots[1].b, "a")
    @test length(srv.roots[1].b) == 0
end

@testset "change datasource" begin
    (srv, _ ) = @runscenario Cds("a" => [0., 1.]) push!(doc.roots[1].data, "a" => [2., 3.])
    @test length(srv.roots[1].data["a"]) == 4

    (srv, _ ) = @runscenario Cds("a" => [0., 1.]) merge!(doc.roots[1].data, "a" => [2.])
    @test length(srv.roots[1].data["a"]) == 1

    (srv, _ ) = @runscenario Cds("a" => [X(;a=1)]) push!(doc.roots[1].data, "a" => [X(;a = 2)])
    @test length(srv.roots[1].data["a"]) == 2
end
