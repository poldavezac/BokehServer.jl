@testset "change number" begin
    @runscenario X(; a = 10) X(; a = 50) begin
        doc[1].a = 1
        doc[2].a = 1
        doc[1].a = 10  # reverting just for fun
    end
end

@testset "change vector" begin
    (srv, _ ) = @runscenario Cnt(; a = [X(;a =2)]) push!(doc[1].a, X(;a = 3))
    @test length(srv[1].a) == 2

    (srv, _ ) = @runscenario Cnt(; a = [X(;a =2)]) deleteat!(doc[1].a, 1)
    @test length(srv[1].a) == 0
end

@testset "change dict" begin
    (srv, _ ) = @runscenario Cnt(; b = Dict("a"=>X(;a =2))) push!(doc[1].b, "b"=>X(;a = 3))
    @test length(srv[1].b) == 2

    (srv, _ ) = @runscenario Cnt(; b = Dict("a"=>X(;a =2))) delete!(doc[1].b, "a")
    @test length(srv[1].b) == 0
end

@testset "change datasource" begin
    @eval cback = Type[]

    @eval function newcds()
        let x = Cds(data = Dict("a" => [0., 1.]))
            Bokeh.Events.onchange(x) do e
                push!(cback, typeof(e))
            end
            x
        end
    end

    (srv, _ ) = @runscenario(newcds(), Bokeh.stream!(doc[1].data, "a" => [2., 3.]))
    @test length(srv[1].data["a"]) == 4
    @test cback == Type[Bokeh.Events.ColumnsStreamedEvent]

    (srv, _ ) = @runscenario(newcds(), Bokeh.update!(doc[1].data, "a" => [2.])) 
    @test length(srv[1].data["a"]) == 1
    @test cback == Type[Bokeh.Events.ColumnsStreamedEvent, Bokeh.Events.ColumnDataChangedEvent]

    (srv, _ ) = @runscenario Cds(data = Dict("a" => [X(;a=1)])) Bokeh.stream!(doc[1].data, Dict("a" => [X(;a = 2)]))
    @test length(srv[1].data["a"]) == 2
end
