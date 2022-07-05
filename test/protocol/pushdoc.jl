@testset "pushdoc" begin
    doc  = BokehJL.Document()
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
        version = "$(BokehJL.Protocol.PROTOCOL_VERSION)",
    ))
    @test BokehJL.Protocol.pushdoc(doc) == truth


    JSON = BokehJL.Protocol.Messages.JSON

    truth = (; doc = (;
        defs  = [],
        roots = (;
            references = [(attributes = (;), id = "10", type = nameof(ProtocolX))],
            root_ids = ["10"]
        ),
        title   = "B",
        version = "$(BokehJL.Protocol.PROTOCOL_VERSION)",
    ))

    @test doc.title == "A"
    @test BokehJL.bokehid.(doc) == [1]
    BokehJL.Events.eventlist!() do
        BokehJL.Protocol.pushdoc!(doc, JSON.parse(JSON.json(truth)), BokehJL.Protocol.Buffers())
    end
    @test doc.title == "B"
    @test BokehJL.bokehid.(doc) == [10]
end
