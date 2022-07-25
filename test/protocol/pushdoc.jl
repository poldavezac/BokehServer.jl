@testset "pushdoc" begin
    doc  = BokehServer.Document()
    obj  =  ProtocolX(; id = 1)
    setfield!(doc, :title, "A")
    push!(getfield(doc, :roots), obj)

    truth = (; doc = Dict{String, Any}(
        "defs"    => Nothing[],
        "roots"   => Dict{String, Any}(
            "references" => [Dict{String, Any}("attributes" => Dict{String, Any}(), "id" => "1", "type" => "$(nameof(ProtocolX))")],
            "root_ids"   => ["1"],
        ),
        "title"   => "A",
        "version" => "$(BokehServer.Protocol.PROTOCOL_VERSION)",
    ))

    @test BokehServer.Protocol.pushdoc(doc) == truth


    JSON = BokehServer.Protocol.Messages.JSON

    truth = (; doc = (;
        defs  = [],
        roots = (;
            references = [(attributes = (;), id = "10", type = nameof(ProtocolX))],
            root_ids = ["10"]
        ),
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
