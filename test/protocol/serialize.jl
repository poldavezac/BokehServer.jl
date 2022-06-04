@testset "basic events" begin
    doc  = Bokeh.Document()
    mdl  = ProtocolX(; id = 1)
    E    = Bokeh.Events
    ser  = Bokeh.Protocol.Serialize.serialize

    val   = ser(E.ModelChangedEvent(mdl, :a, 10, 20))
    truth = (; attr = :a, hint = nothing, kind = :ModelChanged,  model = (; id = "1"), new = 20)
    @test val == truth

    val   = ser(E.RootAddedEvent(doc, mdl, 1))
    truth = (kind = :RootAdded, model = (; id = "1"))
    @test val == truth


    val   = ser(E.RootRemovedEvent(doc, mdl, 1))
    truth = (kind = :RootRemoved, model = (; id = "1"))
    @test val == truth

    E.eventlist!() do
        push!(doc, mdl)
        mdl.a = 100
        val   = Bokeh.Protocol.patchdoc(E.task_eventlist().events, doc, Set{Int64}())
        truth = (;
            events = [
                (; kind = :RootAdded, model = (; id = "1")),
                (; attr = :a, hint = nothing, kind = :ModelChanged, model = (; id = "1"), new = 100),
            ],
            references = [(; attributes = (; a = 100), id = "1", type = nameof(ProtocolX))]
        )
        @test val == truth
    end
end

@testset "datasource events" begin
    doc  = Bokeh.Document()
    mdl  = ProtocolX(; id = 1)
    E    = Bokeh.Events
    ser  = Bokeh.Protocol.Serialize.serialize

    val   = ser(E.ModelChangedEvent(mdl, :a, 10, 20))
    truth = (; attr = :a, hint = nothing, kind = :ModelChanged,  model = (; id = "1"), new = 20)
    @test val == truth

    val   = ser(E.RootAddedEvent(doc, mdl, 1))
    truth = (kind = :RootAdded, model = (; id = "1"))
    @test val == truth


    val   = ser(E.RootRemovedEvent(doc, mdl, 1))
    truth = (kind = :RootRemoved, model = (; id = "1"))
    @test val == truth

    E.eventlist!() do
        push!(doc, mdl)
        mdl.a = 100
        val   = Bokeh.Protocol.patchdoc(E.task_eventlist().events, doc, Set{Int64}())
        truth = (;
            events = [
                (; kind = :RootAdded, model = (; id = "1")),
                (; attr = :a, hint = nothing, kind = :ModelChanged, model = (; id = "1"), new = 100),
            ],
            references = [(; attributes = (; a = 100), id = "1", type = nameof(ProtocolX))]
        )
        @test val == truth
    end
end
