using BokehServer
HTTP = BokehServer.Server.HTTP

@BokehServer.wrap mutable struct ServerTestDOM <: BokehServer.Models.iLayoutDOM
    a::Int = 1
end
dom = ServerTestDOM(; a = 100)
show(IOBuffer(), MIME("text/html"), dom)

sleep(0.01)

BokehServer.Client.open(BokehServer.Embeddings.Notebooks.lastws()) do hdl::BokehServer.Client.MessageHandler
    doc = hdl.doc
    task_local_storage(BokehServer.Events.TASK_EVENTS, BokehServer.Events.EVENTS[]) do
        # by default, the bokeh client has its own event list
        # we impose the notebook one here
        dom.a = 10
    end
    wait(BokehServer.Events.EVENTS[].task)
        
    BokehServer.Client.receivemessage(hdl)  # need to handle the patchdoc
end
sleep(0.01)
BokehServer.Embeddings.Notebooks.stopserver()
sleep(0.01)

server = HTTP.Sockets.listen(HTTP.Sockets.InetAddr(HTTP.Sockets.ip"127.0.0.1", 5006))
task = @async BokehServer.Server.serve(
    5006,
    :app => (doc) -> begin
        fig = BokehServer.figure(x_axis_label = "time", y_axis_label = "energy")
        y   = rand(1:100, 100)
        BokehServer.line!(fig; y, color = :blue)
        BokehServer.scatter!(fig; y, color = :red)
        push!(doc, fig)
    end;
    server
)
sleep(0.01)
BokehServer.Client.open("ws://localhost:5006/app/ws") do _, __
end
close(server)
