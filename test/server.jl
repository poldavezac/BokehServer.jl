struct TestApp <: Bokeh.Server.iApplication end
Bokeh.Server.makeid(::TestApp) = "a"

@testset "document route" begin
    @eval @Bokeh.model mutable struct X1 <: Bokeh.iModel
        a::Int64 = 1
    end

    session = Bokeh.Server.SessionContext("a", "b", Bokeh.Server.HTTP.Request())
    value   = Bokeh.Server.DocRoute.body(TestApp(), session)
    truth   = read(joinpath(@__DIR__, "document.html"), String)
    @testset for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(value)))
        @test i == j
    end
end
