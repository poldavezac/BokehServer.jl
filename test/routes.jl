@testset "staticbundle" begin
    truth = (;
        js_files = [
            "http://localhost:5006/static/js/bokeh.min.js",
            "http://localhost:5006/static/js/bokeh-gl.min.js",
            "http://localhost:5006/static/js/bokeh-widgets.min.js",
            "http://localhost:5006/static/js/bokeh-tables.min.js",
            "http://localhost:5006/static/js/bokeh-mathjax.min.js"
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
        replace(i, "http://localhost:5006" => "x")
        for i ∈ truth.js_files
    ]
    val = Bokeh.Server.staticbundle(Val(:server); address = "x")
    for field ∈ propertynames(truth)
        @test getfield(val, field) == getfield(truth, field)
    end
end


_dummy_test(doc) = nothing
Base.get!(
    x::Bokeh.Server.Application{_dummy_test},
    ::Bokeh.Server.HTTP.Stream
) = last(first(x.sessions.sessions))

app = Bokeh.Server.Application(_dummy_test)
push!(app.sessions.sessions,  "1"=>Bokeh.Server.SessionContext("1", "2", Bokeh.Server.HTTP.Request()))

@testset "autoload.js" begin
    let stream = Bokeh.Server.HTTP.Stream(Bokeh.Server.HTTP.Request(), IOBuffer())
        Bokeh.Server.route(stream, Val(:OPTIONS), missing, Val(Symbol("autoload.js")))
        resp = stream.message.response
        @test resp.status ≡ Int16(200)
        @test string.(resp.headers[1]) == string.("Content-Type" => "text/html")
        @test isempty(read(stream.stream, String))
    end

    let stream = Bokeh.Server.HTTP.Stream(Bokeh.Server.HTTP.Request(), IOBuffer())
        push!(stream.message.headers, "Content-Type" => "application/x-www-form-urlencoded")
        stream.message.body = collect(UInt8, "bokeh-autoload-element=1")
        Bokeh.Server.route(stream, Val(:GET), app, Val(Symbol("autoload.js")))

        resp = stream.message.response
        @test resp.status ≡ Int16(200)
        @test string.(resp.headers[1]) == string.("Content-Type" => "application/javascript")
        @test !iszero(stream.stream.size)
    end
end

@testset "document" begin
    stream = Bokeh.Server.HTTP.Stream(Bokeh.Server.HTTP.Request(), IOBuffer())
    resp = Bokeh.Server.route(stream, Val(:GET), app, Val(:?))
    @test resp.status ≡ Int16(200)
    @test string.(resp.headers[1]) == string.("Content-Type" => "text/html")
    @test !iszero(stream.stream.size)
end

@testset "metadata" begin
    stream = Bokeh.Server.HTTP.Stream(Bokeh.Server.HTTP.Request(), IOBuffer())
    resp = Bokeh.Server.route(stream, Val(:GET), app, Val(:metadata))
    @test resp.status ≡ Int16(200)
    @test string.(resp.headers[1]) == string.("Content-Type" => "application/javascript")
    @test !iszero(stream.stream.size)
end
