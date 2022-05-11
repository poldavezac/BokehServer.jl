@testset "send ACK" begin
    val   = collect(Bokeh.Protocol.message(Val(:ACK); msgid = 1001))
    @test Bokeh.Protocol.JSON.parse(val[1]) == Dict{String, Any}("msgid"=>"1001", "msgtype" => "ACK")
    @test val[2:end] == ["{}", "{}"]
end

@testset "send OK" begin
    val   = collect(Bokeh.Protocol.message(Val(:OK), "AAA"; msgid = 1001))
    @test Bokeh.Protocol.JSON.parse(val[1]) == Dict{String, Any}(
        "msgid"=>"1001", "msgtype" => "OK", "reqid" => "AAA"
    )
    @test val[2:end] == ["{}", "{}"]
end

@testset "send ERROR" begin
    try
        throw(ErrorException("?"))
    catch exc
        val   = collect(Bokeh.Protocol.message(Val(:ERROR), "AAA", "BBB"; msgid = 1001))
        @test Bokeh.Protocol.JSON.parse(val[1]) == Dict{String, Any}(
            "msgid"=>"1001", "msgtype" => "ERROR", "reqid" => "AAA"
        )
        let dico = Bokeh.Protocol.JSON.parse(val[end])
            @test typeof(dico) == Dict{String, Any}
            @test Set(collect(keys(dico))) == Set(["text", "traceback"])
            @test dico["text"] == "BBB"
            @test startswith(dico["traceback"], "?\nStacktrace:\n")
        end
    end
end

@testset "send PATCHDOC" begin
    val   = collect(Bokeh.Protocol.message(Val(:PATCHDOC), "AAA", ["A"=>"B"]))
    @test Bokeh.Protocol.JSON.parse(val[1]) == Dict{String, Any}(
        "msgid"=>"1001", "msgtype" => "PATCH-DOC", "num_buffers" => 1
    )
    @test val[2:end] == ["{}", "AAA", "A", "B"]
end

@testset "serialize" begin
    doc  = Bokeh.Document()
    mdl  = EventsX(; id = 1)
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

    E.eventlist() do
        lst = E.task_eventlist()
        push!(doc, mdl)
        mdl.a = 100
        val   = Bokeh.Protocol.patchdoc(E.task_eventlist(), doc, Set{Int64}())
        truth = (;
            events = [
                (; kind = :RootAdded, model = (; id = "1")),
                (; attr = :a, hint = nothing, kind = :ModelChanged, model = (; id = "1"), new = 100),
            ],
            references = [(; attributes = (; a = 100), id = "1", type = :EventsX)]
        )
        @test val == truth
    end
end

@testset "tojson" begin
    doc  = Bokeh.Document()
    mdl  = EventsX(; id = 1)
    E    = Bokeh.Events
    json(x) = Bokeh.Protocol.Messages.JSON.json(Bokeh.Protocol.serialize(x))

    val   = json(E.ModelChangedEvent(mdl, :a, 10, 20))
    truth = """{"attr":"a","hint":null,"kind":"ModelChanged","model":{"id":"1"},"new":20}"""
    @test val == truth

    val   = json(E.RootAddedEvent(doc, mdl, 1))
    truth = """{"kind":"RootAdded","model":{"id":"1"}}"""
    @test val == truth

    val   = json(E.RootRemovedEvent(doc, mdl, 1))
    truth = """{"kind":"RootRemoved","model":{"id":"1"}}"""
    @test val == truth

    E.eventlist() do
        lst = E.task_eventlist()
        push!(doc, mdl)
        mdl.a = 100
        val   = Bokeh.Protocol.Messages.JSON.json(Bokeh.Protocol.patchdoc(E.task_eventlist(), doc, Set{Int64}()))
        truth = (
            """{"events":[{"kind":"RootAdded","model":{"id":"1"}}"""*
            """,{"attr":"a","hint":null,"kind":"ModelChanged","model":{"id":"1"},"""*
            """"new":100}],"references":[{"attributes":{"a":100},"id":"1","type":"EventsX"}]}"""
        )
        @test val == truth

    end
end

@testset "patchdoc/handle" begin
    doc  = Bokeh.Document()
    mdl  = EventsX(; id = 100,a  = 10)
    E    = Bokeh.Events
    buf  = Bokeh.Protocol.Buffers(undef, 0)
    JSON = Bokeh.Protocol.Messages.JSON
    json1(x) = JSON.json(Bokeh.Protocol.serialize(x))
    json2(x) = JSON.json(Bokeh.Protocol.Serialize.serialref(x, Bokeh.Protocol.Serialize.Rules()))
    jsref(x) = JSON.parse(json1(x))
    js(x)    = JSON.parse(json2(x))
    @testset "add first root" begin
        E.eventlist() do
            cnt = Dict(
                "references" => [jsref(mdl)],
                "events" =>  [js(E.RootAddedEvent(doc, mdl, 1))],
            )

            @test isempty(doc.roots)
            Bokeh.Protocol.patchdoc!(doc, cnt, buf)
            @test length(doc.roots) == 1
            @test Bokeh.bokehid(doc.roots[1]) == 100
            @test doc.roots[1].a == 10
            @test doc.roots[1] ≢ mdl
        end
    end

    @testset "add root again" begin
        E.eventlist() do
            cnt = Dict(
                "references" => [],
                "events" =>  [js(E.RootAddedEvent(doc, mdl, 1))],
            )

            @test length(doc.roots) == 1
            @test_throws ErrorException Bokeh.Protocol.patchdoc!(doc, cnt, buf)
            @test length(doc.roots) == 1
        end
    end

    @testset "remove root" begin
        E.eventlist() do
            cnt = Dict(
                "references" => [],
                "events" =>  [js(E.RootRemovedEvent(doc, mdl, 1))],
            )

            @test length(doc.roots) == 1
            Bokeh.Protocol.patchdoc!(doc, cnt, buf)
            @test length(doc.roots) == 0
        end
    end

    ymdl  = EventsY()
    @testset "add y root" begin
        E.eventlist() do
            cnt = Dict(
                "references" => [jsref(ymdl), jsref(ymdl.a), jsref(mdl)],
                "events" =>  [
                    js(E.RootAddedEvent(doc, mdl, 1)),
                    js(E.RootAddedEvent(doc, ymdl, 1))
                ],
            )

            @test length(doc.roots) == 0
            Bokeh.Protocol.patchdoc!(doc, cnt, buf)
            @test length(doc.roots) == 2
            @test doc.roots[1].id ≡ mdl.id
            @test doc.roots[2].id ≡ ymdl.id
            @test doc.roots[2].a.id ≡ ymdl.a.id
        end
    end

    @testset "change attribute" begin
        E.eventlist() do
            other = EventsX()
            cnt = Dict(
                "references" => [jsref(other)],
                "events" =>  [js(E.ModelChangedEvent(ymdl, :a, nothing, other))],
            )

            @test length(doc.roots) == 2
            @test doc.roots[end].a.id ≢ other.id
            Bokeh.Protocol.patchdoc!(doc, cnt, buf)
            @test length(doc.roots) == 2
            @test doc.roots[end].a.id ≡ other.id
        end
    end
end
