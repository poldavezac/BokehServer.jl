@testset "pushdoc" begin
    doc  = Bokeh.Document()
    obj  =  ProtocolX(; id = 1)
    setfield!(doc, :title, "A")
    push!(getfield(doc, :roots), obj)

    truth = (; doc = (;
        defs    = [],
        roots   = (;
            references = [(attributes = (;), id = "1", type = nameof(ProtocolX))],
            root_ids   = ["1"],
        ),
        title   = "A",
        version = Bokeh.PYTHON_VERSION,
    ))
    @test Bokeh.Protocol.pushdoc(doc) == truth


    JSON = Bokeh.Protocol.Messages.JSON

    truth = (; doc = (;
        defs  = [],
        roots = (;
            references = [(attributes = (;), id = "10", type = nameof(ProtocolX))],
            root_ids = ["10"]
        ),
        title   = "B",
        version = Bokeh.PYTHON_VERSION,
    ))

    @test doc.title == "A"
    @test Bokeh.bokehid.(doc) == [1]
    Bokeh.Events.eventlist!() do
        Bokeh.Protocol.pushdoc!(doc, JSON.parse(JSON.json(truth)), Bokeh.Protocol.Buffers())
    end
    @test doc.title == "B"
    @test Bokeh.bokehid.(doc) == [10]
end
