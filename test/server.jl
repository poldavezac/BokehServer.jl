HTTP = BokehServer.Server.HTTP
const TEST_PORT = 5032
BokehServer.Server.CONFIG.port = TEST_PORT

@testset "tokens" begin
    Tokens = BokehServer.Server.Tokens
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
            BokehServer.Server.serve(TEST_PORT, args...; kwa..., server)
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

@BokehServer.wrap mutable struct ServerTestObj <: BokehServer.iModel
    a::Int = 1
end

@testset "ws routes" begin
    with_logger(Logging.NullLogger()) do
        val = Ref{Bool}(false)
        testserve(:app => (doc) -> push!(doc, ServerTestObj(; a = 1), ServerTestObj(; a = 2))) do
            BokehServer.Client.open("ws://localhost:$TEST_PORT/app/ws") do _, doc
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

@BokehServer.wrap mutable struct ServerTestDOM <: BokehServer.Models.iLayoutDOM
    a::Int = 1
end

@testset "notebook" begin
    @test isnothing(BokehServer.Embeddings.Notebooks.SERVER[])
    io  = IOBuffer()
    dom = ServerTestDOM(; a = 100)
    show(io, MIME("text/html"), dom)
    @test !isempty(String(take!(io)))

    sleep(0.01)
    @test !isnothing(BokehServer.Embeddings.Notebooks.SERVER[])
    @test !isempty(BokehServer.Embeddings.Notebooks.SERVER[].lastid[])
    @test !isempty(BokehServer.Embeddings.Notebooks.SERVER[].routes)

    val = Ref(false)
    BokehServer.Client.open(BokehServer.Embeddings.Notebooks.lastws()) do hdl::BokehServer.Client.MessageHandler
        doc = hdl.doc

        @test length(doc) == 1
        task_local_storage(BokehServer.Events.TASK_EVENTS, BokehServer.Events.EVENTS[]) do
            # by default, the bokeh client has its own event list
            # we impose the notebook one here
            dom.a = 10
        end
        @test doc.roots[1].a ≡ 100
        @test !isnothing(BokehServer.Events.EVENTS[].task)
        wait(BokehServer.Events.EVENTS[].task)
        @test isnothing(BokehServer.Events.EVENTS[].task)
        
        BokehServer.Client.receivemessage(hdl)  # need to handle the patchdoc
        @test doc.roots[1].a ≡ 10
        val[] = true
    end
    sleep(0.01)
    @test val[]

    BokehServer.Embeddings.Notebooks.stopserver()
    sleep(0.01)
    @test isnothing(BokehServer.Embeddings.Notebooks.SERVER[])
end

@testset "figure" begin
    with_logger(Logging.NullLogger()) do
        val = Ref{Bool}(false)
        fig = BokehServer.figure(x_axis_label = "time", y_axis_label = "energy")
        testserve(
            :app => (doc) -> begin
                y   = rand(1:100, 100)
                BokehServer.line!(fig; y, color = :blue)
                BokehServer.scatter!(fig; y, color = :red)
                push!(doc, fig)
            end
        ) do
            BokehServer.Client.open("ws://localhost:$TEST_PORT/app/ws") do _, doc
                @test length(doc) == 1
                @test all(i isa BokehServer.Models.Plot for i ∈ doc)
                clfig = doc.roots[1]
                @test clfig ≢ fig
                for attr ∈ (:left, :right, :above, :below, :renderers)
                    @test [i.id for i ∈ getproperty(fig, attr)] == [i.id for i ∈ getproperty(clfig, attr)]
                end
                val[] = true
            end
            yield()
        end
        @test val[]
    end
end

function run_example(name::String)
    path = joinpath(@__DIR__, "..", "examples", "$name.jl")
    err  = Ref(false)
    task = @async try
        with_logger(Logging.NullLogger()) do
            Base.include(Module(), path)
        end
    catch exc
        err[] = true
        @error "failed $path" exception = (exc, Base.catch_backtrace())
    end
    for _ = 1:100
        istaskstarted(task) || sleep(0.1)
    end
    @test istaskstarted(task)
    @test !istaskdone(task)

    val = Ref{Any}(nothing)
    BokehServer.Client.open("ws://localhost:$TEST_PORT/plot/ws") do ws, doc
        val[] = doc
        close(ws)
    end
    @test !istaskdone(task)
    stop = @async Base.throwto(task, InterruptException())
    wait(task)

    @test !isempty(val[].roots)
    @test istaskdone(task)
    @test !istaskfailed(task)
    @test !err[]
end

@testset "categorical_scatter_jitter" begin run_example("categorical_scatter_jitter") end
@testset "latex_normal_distribution"  begin run_example("latex_normal_distribution") end
@testset "les_mis"                    begin run_example("les_mis") end
@testset "lines"                      begin run_example("lines") end
@testset "periodic"                   begin run_example("periodic") end
@testset "scatter"                    begin run_example("scatter") end
@testset "selection_histogram"        begin run_example("selection_histogram") end
@testset "burtin"                     begin run_example("burtin") end
@testset "boxplot"                    begin run_example("boxplot") end
