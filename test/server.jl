HTTP = BokehJL.Server.HTTP
const TEST_PORT = rand(1:9999)
BokehJL.Server.CONFIG.port = TEST_PORT

@testset "tokens" begin
    Tokens = BokehJL.Server.Tokens
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
        task = @async try
            BokehJL.Server.serve(TEST_PORT, args...; kwa..., server)
        catch exc
            @error "Failed serve" exception = (exc, Base.catch_backtrace())
        end
        sleep(0.01)
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

@BokehJL.wrap mutable struct ServerTestObj <: BokehJL.iModel
    a::Int = 1
end

@testset "ws routes" begin
    with_logger(Logging.NullLogger()) do
        val = Ref{Bool}(false)
        testserve(:app => (doc) -> push!(doc, ServerTestObj(; a = 1), ServerTestObj(; a = 2))) do
            BokehJL.Client.open("ws://localhost:$TEST_PORT/app/ws") do _, doc
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

@BokehJL.wrap mutable struct ServerTestDOM <: BokehJL.Models.iLayoutDOM
    a::Int = 1
end

@testset "notebook" begin
    @test isnothing(BokehJL.Embeddings.Notebooks.SERVER[])
    io  = IOBuffer()
    dom = ServerTestDOM(; a = 100)
    show(io, MIME("text/html"), dom)
    @test !isempty(String(take!(io)))

    sleep(0.01)
    @test !isnothing(BokehJL.Embeddings.Notebooks.SERVER[])
    @test !isempty(BokehJL.Embeddings.Notebooks.SERVER[].lastid[])
    @test !isempty(BokehJL.Embeddings.Notebooks.SERVER[].routes)

    val = Ref(false)
    BokehJL.Client.open(BokehJL.Embeddings.Notebooks.lastws()) do hdl::BokehJL.Client.MessageHandler
        doc = hdl.doc

        @test length(doc) == 1
        task_local_storage(BokehJL.Events.TASK_EVENTS, BokehJL.Events.EVENTS[]) do
            # by default, the bokeh client has its own event list
            # we impose the notebook one here
            dom.a = 10
        end
        @test doc.roots[1].a ≡ 100
        @test !isnothing(BokehJL.Events.EVENTS[].task)
        wait(BokehJL.Events.EVENTS[].task)
        @test isnothing(BokehJL.Events.EVENTS[].task)
        
        BokehJL.Client.receivemessage(hdl)  # need to handle the patchdoc
        @test doc.roots[1].a ≡ 10
        val[] = true
    end
    sleep(0.01)
    @test val[]

    BokehJL.Embeddings.Notebooks.stopserver()
    sleep(0.01)
    @test isnothing(BokehJL.Embeddings.Notebooks.SERVER[])
end
