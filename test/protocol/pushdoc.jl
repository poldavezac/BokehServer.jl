@testset "pushdoc" begin
    doc  = BokehServer.Document()
    obj  =  ProtocolX(; id = 1)
    setfield!(doc, :title, "A")
    push!(getfield(doc, :roots), obj)

    truth = Dict{String, Any}(
        "defs"    => Nothing[],
        "roots"   => Any[
            Dict{String, Any}("id" => "1", "type" => "object", "name" => "$(nameof(ProtocolX))")
        ],
        "title"   => "A",
        "version" => "$(BokehServer.Protocol.PROTOCOL_VERSION)",
    )

    @test BokehServer.Protocol.pushdoc(doc).doc == truth


    JSON = BokehServer.Protocol.Messages.JSON

    truth = (; doc = (;
        defs    = [],
        roots   = [(type = :object, id = "10", name = nameof(ProtocolX))],
        title   = "B",
        version = "$(BokehServer.Protocol.PROTOCOL_VERSION)",
    ))

    @test doc.title == "A"
    @test BokehServer.bokehid.(doc) == [1]
    BokehServer.Events.eventlist!() do
        BokehServer.Protocol.pushdoc!(doc, JSON.parse(JSON.json(truth)), BokehServer.Protocol.Buffers())
    end
    @test doc.title == "B"
    @test BokehServer.bokehid.(doc) == [10]
end
