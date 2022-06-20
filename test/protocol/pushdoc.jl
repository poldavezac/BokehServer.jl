@testset "pushdoc" begin
    doc  = Bokeh.Document()
    obj  =  ProtocolX(; id = 1)
    setfield!(doc, :title, "A")
    push!(getfield(doc, :roots), obj)

    truth = (; doc = (;
        title   = "A",
        version = Bokeh.PYTHON_VERSION,
        defs    = [],
        roots   = (;
            root_ids   = ["1"],
            references = NamedTuple[Bokeh.Protocol.serialize(obj)]
        ),
    ))
    @test Bokeh.Protocol.pushdoc(doc) == truth


    JSON = Bokeh.Protocol.Messages.JSON

    truth = (; doc = (;
        title   = "B",
        version = Bokeh.PYTHON_VERSION,
        defs    = [],
        roots   = (;
            root_ids   = ["10"],
            references = NamedTuple[Bokeh.Protocol.serialize(ProtocolX(; id = 10))]
        ),
    ))

    @test doc.title == "A"
    @test Bokeh.bokehid.(doc) == [1]
    Bokeh.Events.eventlist!() do
        Bokeh.Protocol.pushdoc!(doc, JSON.parse(JSON.json(truth)), Bokeh.Protocol.Buffers())
    end
    @test doc.title == "B"
    @test Bokeh.bokehid.(doc) == [10]
end
