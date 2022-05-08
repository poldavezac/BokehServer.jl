struct TestApp <: Bokeh.Server.iApplication end
Bokeh.Server.makeid(::TestApp) = "a"

@testset "document route" begin
    session = Bokeh.Server.SessionContext("a", "b", Bokeh.Server.HTTP.Request())
    value   = Bokeh.Server.DocRoute.body(TestApp(), session)
    truth   = read(joinpath(@__DIR__, "document.html"), String)
    @testset for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(value)))
        @test i == j
    end
end

@testset "autoload route" begin
    session = Bokeh.Server.SessionContext("a", "b", Bokeh.Server.HTTP.Request())
    value   = Bokeh.Server.AutoloadRoute.body(
        TestApp(), session, Dict("bokeh-autoload-element" => "aaa")
    )
    truth   = read(joinpath(@__DIR__, "autoload.html"), String)
    @testset for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(value)))
        @test i == j
    end
end
