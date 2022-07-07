using BokehJL
HTTP = BokehJL.Server.HTTP

@BokehJL.wrap mutable struct ServerTestDOM <: BokehJL.Models.iLayoutDOM
    a::Int = 1
end
dom = ServerTestDOM(; a = 100)
show(IOBuffer(), MIME("text/html"), dom)

sleep(0.01)

BokehJL.Client.open(BokehJL.Embeddings.Notebooks.lastws()) do hdl::BokehJL.Client.MessageHandler
    doc = hdl.doc
    task_local_storage(BokehJL.Events.TASK_EVENTS, BokehJL.Events.EVENTS[]) do
        # by default, the bokeh client has its own event list
        # we impose the notebook one here
        dom.a = 10
    end
    wait(BokehJL.Events.EVENTS[].task)
        
    BokehJL.Client.receivemessage(hdl)  # need to handle the patchdoc
end
sleep(0.01)
BokehJL.Embeddings.Notebooks.stopserver()
sleep(0.01)

server = HTTP.Sockets.listen(HTTP.Sockets.InetAddr(HTTP.Sockets.ip"127.0.0.1", 5006))
task = @async BokehJL.Server.serve(
    5006,
    :app => (doc) -> begin
        fig = BokehJL.figure(x_axis_label = "time", y_axis_label = "energy")
        y   = rand(1:100, 100)
        BokehJL.line!(fig; y, color = :blue)
        BokehJL.scatter!(fig; y, color = :red)
        push!(doc, fig)
    end;
    server
)
sleep(0.01)
BokehJL.Client.open("ws://localhost:5006/app/ws") do _, __
end
close(server)
