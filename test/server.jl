HTTP = Bokeh.Server.HTTP
const TEST_PORT = rand(1:9999)

@testset "tokens" begin
    Tokens = Bokeh.Server.Tokens
    sid   = [Tokens.sessionid() for _ = 1:10]
    @test all(length.(sid) .== 44)

    token = [Tokens.token(i; extra = 100, index = j) for (j,i) ∈ enumerate(sid)]
    @test Tokens.sessionid.(token) == sid
    @test all(Tokens.payload(x)["extra"] == 100 for x ∈ token)
    @test [Tokens.payload(x)["index"] for x ∈ token] == 1:length(token)
end

function testserve(𝐹::Function, args...; kwa...)
    val    = Ref{Bool}(false)
    server = HTTP.Sockets.listen(HTTP.Sockets.InetAddr(HTTP.Sockets.ip"127.0.0.1", TEST_PORT))
    task   = @async nothing
    try
        task = @async Bokeh.Server.serve(TEST_PORT, args...; kwa..., server)
        yield()
        @test istaskstarted(task)
        @test !istaskdone(task)
        val[] = true
        𝐹()
    finally
        close(server)
        istaskdone(task) || wait(task)
    end
    @test val[]
end

@testset "http routes" begin
    with_logger(Logging.NullLogger()) do
        testserve(:app => (doc) -> nothing) do
            req = @async HTTP.get(
                "http://127.0.0.1:$TEST_PORT/app/autoload.js?bokeh-autoload-element=1",
                retry = false
            )
            wait(req)
            @test !isempty(String(req.result.body))

            req = @async HTTP.get("http://127.0.0.1:$TEST_PORT/app/?", retry = false)
            wait(req)
            @test !isempty(String(req.result.body))

            req = @async HTTP.get("http://127.0.0.1:$TEST_PORT/app/metadata", retry = false)
            wait(req)
            @test !isempty(String(req.result.body))
        end
    end
end

@Bokeh.wrap mutable struct ServerTestObj <: Bokeh.iModel
    a::Int = 1
end

@testset "ws routes" begin
    with_logger(Logging.NullLogger()) do
        val = Ref{Bool}(false)
        testserve(:app => (doc) -> push!(doc, ServerTestObj(; a = 1), ServerTestObj(; a = 2))) do
            Bokeh.Client.open("ws://localhost:$TEST_PORT/app/ws") do _, doc
                val[] = true
                @test length(doc) == 2
                @test all(i isa ServerTestObj for i ∈ doc)
                @test getproperty.(getfield(doc, :roots), :a) == [1, 2]
            end
            yield()
        end
        @test val[]
    end
end

@Bokeh.wrap mutable struct ServerTestDOM <: Bokeh.Models.iLayoutDOM
    a::Int = 1
end

@testset "notebook" begin
    with_logger(Logging.NullLogger()) do
        @test isnothing(Bokeh.Embeddings.Notebooks.SERVER[])
        io = IOBuffer()
        show(io, MIME("text/html"), ServerTestDOM(; a = 100))
        @test !isempty(String(take!(io)))

        sleep(0.01)
        @test !isnothing(Bokeh.Embeddings.Notebooks.SERVER[])
        @test !isempty(Bokeh.Embeddings.Notebooks.SERVER[].lastid[])
        @test !isempty(Bokeh.Embeddings.Notebooks.SERVER[].routes)

        val = Ref(false)
        Bokeh.Client.open(Bokeh.Embeddings.Notebooks.lastws()) do _, doc
            @test length(doc) == 1
            val[] = true
        end
        sleep(0.01)
        @test val[]

        Bokeh.Embeddings.Notebooks.stopserver()
        sleep(0.01)
        @test isnothing(Bokeh.Embeddings.Notebooks.SERVER[])
    end
end
