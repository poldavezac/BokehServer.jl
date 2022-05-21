HTTP = Bokeh.Server.HTTP

@testset "http routes" begin
    @test Threads.nthreads() > 1
    with_logger(Logging.NullLogger()) do
        server = HTTP.Sockets.listen(HTTP.Sockets.InetAddr(HTTP.Sockets.ip"127.0.0.1", 5006))
        try
            task = @async Bokeh.Server.serve(:app => (doc) -> nothing; server)
            yield()
            @test istaskstarted(task)
            @test !istaskdone(task)
            req = @async HTTP.get(
                "http://127.0.0.1:5006/app/autoload.js?bokeh-autoload-element=1",
                retry = false
            )
            wait(req)
            @test !isempty(String(req.result.body))

            req = @async HTTP.get("http://127.0.0.1:5006/app/?", retry = false)
            wait(req)
            @test !isempty(String(req.result.body))

            req = @async HTTP.get("http://127.0.0.1:5006/app/metadata", retry = false)
            wait(req)
            @test !isempty(String(req.result.body))
        finally
            close(server)
        end
    end
end
