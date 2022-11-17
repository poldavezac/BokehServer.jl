@testset "exception body" begin
    value = try
        baa*1
    catch
        try
            baa*1
        catch
            BokehServer.Server.ExceptionRoute.body(Base.current_exceptions())
        end
    end
    truth   = read(joinpath(@__DIR__, "error.html"), String)
    for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(value)))
        if '@' ∈ i
            @test '@' ∈ j
        else
            @test i == j
        end
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
    val = BokehServer.Server.staticbundle() 
    for field ∈ propertynames(truth)
        @test getfield(val, field) == getfield(truth, field)
    end

    truth.js_files[:] .= [
        replace(i, "http://127.0.0.1:5006" => "x")
        for i ∈ truth.js_files
    ]
    val = BokehServer.Server.staticbundle("x")
    for field ∈ propertynames(truth)
        @test getfield(val, field) == getfield(truth, field)
    end
end

struct TestApp <: BokehServer.Server.iApplication
    sessions :: BokehServer.Server.SessionList
    call     :: Function
    TestApp() = new(BokehServer.Server.SessionList(), identity)
end

BokehServer.Server.makeid(::TestApp) = "a"
Base.get!(x::TestApp, ::BokehServer.Server.HTTP.Stream) = last(first(x.sessions.sessions))

app = TestApp()
push!(app.sessions.sessions,  "1"=>BokehServer.Server.SessionContext("1", "2"))

@testset "autoload body" begin
    value   = BokehServer.Server.AutoloadRoute.body(
        TestApp(), "b", Dict("bokeh-autoload-element" => "aaa")
    )
    truth   = read(joinpath(@__DIR__, "autoload.html"), String)
    for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(value)))
        i = replace(i, "VERS" => string(BokehServer.Protocol.PROTOCOL_VERSION))
        @test i == j
    end
end

@testset "autoload" begin
    let stream = BokehServer.Server.HTTP.Stream(BokehServer.Server.HTTP.Request(), IOBuffer())
        BokehServer.Server.route(stream, Val(:OPTIONS), app, Val(Symbol("autoload.js")))
        resp = stream.message.response
        @test resp.status ≡ Int16(200)
        @test string.(resp.headers[1]) == string.("Content-Type" => "text/html")
        @test !isempty(String(take!(stream.stream)))
    end

    let stream = BokehServer.Server.HTTP.Stream(BokehServer.Server.HTTP.Request(), IOBuffer())
        push!(stream.message.headers, "Content-Type" => "application/x-www-form-urlencoded")
        stream.message.body = collect(UInt8, "bokeh-autoload-element=1")
        BokehServer.Server.route(stream, Val(:GET), app, Val(Symbol("autoload.js")))

        resp = stream.message.response
        @test resp.status ≡ Int16(200)
        @test string.(resp.headers[1]) == string.("Content-Type" => "application/javascript")
        @test !isempty(String(take!(stream.stream)))
    end
end

@testset "document body" begin
    session = BokehServer.Server.SessionContext("a", "b")
    value   = BokehServer.Server.DocRoute.body(TestApp(), session)
    truth   = read(joinpath(@__DIR__, "document.html"), String)
    for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(value)))
        @test i == j
    end
end

@testset "document" begin
    stream = BokehServer.Server.HTTP.Stream(BokehServer.Server.HTTP.Request(), IOBuffer())
    BokehServer.Server.route(stream, Val(:GET), app)
    resp = stream.message.response
    @test resp.status ≡ Int16(200)
    @test string.(resp.headers[1]) == string.("Content-Type" => "text/html")
    @test !isempty(String(take!(stream.stream)))
end

@testset "metadata" begin
    stream = BokehServer.Server.HTTP.Stream(BokehServer.Server.HTTP.Request(), IOBuffer())
    BokehServer.Server.route(stream, Val(:GET), app, Val(:metadata))
    resp = stream.message.response
    @test resp.status ≡ Int16(200)
    @test string.(resp.headers[1]) == string.("Content-Type" => "application/json")
    @test !isempty(String(take!(stream.stream)))
end
