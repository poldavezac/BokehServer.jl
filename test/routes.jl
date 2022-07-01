@testset "exception body" begin
    value = try
        baa*1
    catch
        try
            baa*1
        catch
            Bokeh.Server.ExceptionRoute.body(Base.current_exceptions())
        end
    end

    truth   = read(joinpath(@__DIR__, "error.html"), String)
    @testset for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(value)))
        @test i == j
    end
end

@testset "staticbundle" begin
    truth = (;
        js_files = [
            "http://127.0.0.1:5006/static/js/bokeh.min.js",
            "http://127.0.0.1:5006/static/js/bokeh-gl.min.js",
            "http://127.0.0.1:5006/static/js/bokeh-widgets.min.js",
            "http://127.0.0.1:5006/static/js/bokeh-tables.min.js",
            "http://127.0.0.1:5006/static/js/bokeh-mathjax.min.js"
        ],
        js_raw = ["Bokeh.set_log_level(\"info\");"],
        css_files = String[],
        css_raw = String[],
        hashes = Dict{String, String}()
    )
    val = Bokeh.Server.staticbundle(:server) 
    for field ∈ propertynames(truth)
        @test getfield(val, field) == getfield(truth, field)
    end

    truth.js_files[:] .= [
        replace(i, "http://127.0.0.1:5006" => "x")
        for i ∈ truth.js_files
    ]
    val = Bokeh.Server.staticbundle(Val(:server); address = "x")
    for field ∈ propertynames(truth)
        @test getfield(val, field) == getfield(truth, field)
    end
end

struct TestApp <: Bokeh.Server.iApplication end
Bokeh.Server.makeid(::TestApp) = "a"

_dummy_test(doc) = nothing
Base.get!(
    x::Bokeh.Server.Application{_dummy_test},
    ::Bokeh.Server.HTTP.Stream
) = last(first(x.sessions.sessions))

app = Bokeh.Server.Application(_dummy_test)
push!(app.sessions.sessions,  "1"=>Bokeh.Server.SessionContext("1", "2"))

@testset "autoload body" begin
    value   = Bokeh.Server.AutoloadRoute.body(
        TestApp(), "b", Dict("bokeh-autoload-element" => "aaa")
    )
    truth   = read(joinpath(@__DIR__, "autoload.html"), String)
    @testset for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(value)))
        @test i == j
    end
end

@testset "autoload" begin
    let stream = Bokeh.Server.HTTP.Stream(Bokeh.Server.HTTP.Request(), IOBuffer())
        Bokeh.Server.route(stream, Val(:OPTIONS), app, Val(Symbol("autoload.js")))
        resp = stream.message.response
        @test resp.status ≡ Int16(200)
        @test string.(resp.headers[1]) == string.("Content-Type" => "text/html")
        @test !isempty(String(take!(stream.stream)))
    end

    let stream = Bokeh.Server.HTTP.Stream(Bokeh.Server.HTTP.Request(), IOBuffer())
        push!(stream.message.headers, "Content-Type" => "application/x-www-form-urlencoded")
        stream.message.body = collect(UInt8, "bokeh-autoload-element=1")
        Bokeh.Server.route(stream, Val(:GET), app, Val(Symbol("autoload.js")))

        resp = stream.message.response
        @test resp.status ≡ Int16(200)
        @test string.(resp.headers[1]) == string.("Content-Type" => "application/javascript")
        @test !isempty(String(take!(stream.stream)))
    end
end

@testset "document body" begin
    session = Bokeh.Server.SessionContext("a", "b")
    value   = Bokeh.Server.DocRoute.body(TestApp(), session)
    truth   = read(joinpath(@__DIR__, "document.html"), String)
    @testset for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(value)))
        @test i == j
    end
end

@testset "document" begin
    stream = Bokeh.Server.HTTP.Stream(Bokeh.Server.HTTP.Request(), IOBuffer())
    Bokeh.Server.route(stream, Val(:GET), app)
    resp = stream.message.response
    @test resp.status ≡ Int16(200)
    @test string.(resp.headers[1]) == string.("Content-Type" => "text/html")
    @test !isempty(String(take!(stream.stream)))
end

@testset "metadata" begin
    stream = Bokeh.Server.HTTP.Stream(Bokeh.Server.HTTP.Request(), IOBuffer())
    Bokeh.Server.route(stream, Val(:GET), app, Val(:metadata))
    resp = stream.message.response
    @test resp.status ≡ Int16(200)
    @test string.(resp.headers[1]) == string.("Content-Type" => "application/json")
    @test !isempty(String(take!(stream.stream)))
end
