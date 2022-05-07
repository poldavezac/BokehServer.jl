@Bokeh.model mutable struct EventsX <: Bokeh.iModel
    a::Int = 1
    b::Int = 1
    c::Int = 1
end

@Bokeh.model mutable struct EventsY <: Bokeh.iModel
    a::EventsX = EventsX(; a = -1)
end

@testset "create model events" begin
    obj = EventsX()

    Bokeh.Events.eventlist() do
        lst = Bokeh.Events.task_eventlist()
        @test isempty(lst)

        obj.a = 2   
        @test length(lst.events) == 1
        itm = first(lst.events)
        @test (itm.model.id, itm.attr) == (obj.id, :a)
        @test (itm.old, itm.new) == (1, 2)

        obj.b += 2 
        @test length(lst.events) == 2
        itm = lst.events[end]
        @test (itm.model.id,  itm.attr) == (obj.id, :b)
        @test (itm.old, itm.new)  == (1, 3)

        obj.a = 3
        @test length(lst.events) == 2
        itm = last(lst.events)
        @test (itm.model.id, itm.attr) == (obj.id, :a)
        @test (itm.old, itm.new) == (1, 3)

        obj.a = 1
        @test length(lst.events) == 1
        @test first(lst.events).attr == :b
    end
end

@testset "create doc events" begin
    ini = EventsX()

    doc = Bokeh.Document()
    push!(doc.roots, ini)

    obj = EventsX()

    Bokeh.Events.eventlist() do
        lst = Bokeh.Events.task_eventlist()
        @test isempty(lst)

        push!(doc, obj)
        @test length(lst.events) == 1
        @test first(lst.events) isa Bokeh.Events.RootAddedEvent
        @test first(lst.events).doc.id == doc.id
        @test first(lst.events).root.id == obj.id

        delete!(doc, obj)
        @test isempty(lst.events)

        delete!(doc, ini)
        @test length(lst.events) == 1
        @test first(lst.events) isa Bokeh.Events.RootRemovedEvent
        @test first(lst.events).doc.id == doc.id
        @test first(lst.events).root.id == ini.id
    end
end

@testset "check model callback" begin
    obj1 = EventsX()
    obj2 = EventsX()
    calls1 = []
    calls2 = Bokeh.ModelChangedEvent[]

    Bokeh.onchange(obj1) do obj, attr, new, old 
        push!(calls1, (obj, attr, old, new))
    end

    Bokeh.onchange(obj2) do evt
        push!(calls2, evt)
    end

    Bokeh.Events.eventlist() do
        obj1.a = 10
        obj1.b = 10
        obj2.a = 10

        Bokeh.Events.flushevents!(Bokeh.Events.task_eventlist())
    end

    @test length(calls1) == 2
    @test length(calls2) == 1
end

@testset "check document callback" begin
    obj1 = EventsX()
    obj2 = EventsX()
    doc  = Bokeh.Document()
    push!(doc.roots, obj2)
    calls1 = Bokeh.Events.iDocumentEvent[]
    calls2 = Bokeh.RootAddedEvent[]

    Bokeh.onchange(doc) do evt
        push!(calls1, (evt))
    end

    Bokeh.onchange(doc) do evt::Bokeh.RootAddedEvent
        push!(calls2, (evt))
    end

    Bokeh.Events.eventlist() do
        push!(doc, obj1)
        delete!(doc, obj2)
        Bokeh.Events.flushevents!(Bokeh.Events.task_eventlist())
    end

    @show length(calls1), length(calls2)
    @test length(calls1) == 2
    @test length(calls2) == 1
end

@testset "send" begin
    doc  = Bokeh.Document()
    mdl  = EventsX(; id = 1)
    E    = Bokeh.Events
    json = E.Send.dojson

    val   = json(E.ModelChangedEvent(mdl, :a, 10, 20))
    truth = """{"attr":"a","hint":null,"kind":"ModelChanged","model":{"id":"1"},"new":20}"""
    @test val == truth

    val   = json(E.RootAddedEvent(doc, mdl))
    truth = """{"kind":"RootAdded","model":{"id":"1"}}"""
    @test val == truth


    val   = json(E.RootRemovedEvent(doc, mdl))
    truth = """{"kind":"RootRemoved","model":{"id":"1"}}"""
    @test val == truth

    E.eventlist() do
        lst = E.task_eventlist()
        push!(doc, mdl)
        mdl.a = 100
        val   = E.json(E.task_eventlist(), doc, Set{Int64}())
        truth = (
            """{"events":[{"kind":"RootAdded","model":{"id":"1"}}"""*
            """,{"attr":"a","hint":null,"kind":"ModelChanged","model":{"id":"1"},"""*
            """"new":100}],"references":[{"attributes":{"a":100},"id":"1","type":"EventsX"}]}"""
        )
        @test val == truth

    end
end

@testset "receive" begin
    doc  = Bokeh.Document()
    mdl  = EventsX(; id = 100,a  = 10)
    E    = Bokeh.Events
    buf  = Bokeh.Protocol.Buffers(undef, 0)
    JSON = E.Send.JSON
    jsref(x) = JSON.parse(E.Send.dojson(E.Send.jsreference(x)))
    js(x)    = JSON.parse(E.Send.dojson(x))
    @testset "add first root" begin
        E.eventlist() do
            cnt = Dict(
                "references" => [jsref(mdl)],
                "events" =>  [js(E.RootAddedEvent(doc, mdl))],
            )

            @test isempty(doc.roots)
            E.patchdoc!(doc, cnt, buf)
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
                "events" =>  [js(E.RootAddedEvent(doc, mdl))],
            )

            @test length(doc.roots) == 1
            E.patchdoc!(doc, cnt, buf)
            @test length(doc.roots) == 2
            @test doc.roots[2] ≡ doc.roots[1]
        end
    end

    @testset "remove root" begin
        E.eventlist() do
            cnt = Dict(
                "references" => [],
                "events" =>  [js(E.RootRemovedEvent(doc, mdl))],
            )

            @test length(doc.roots) == 2
            E.patchdoc!(doc, cnt, buf)
            @test length(doc.roots) == 0
        end
    end

    ymdl  = EventsY()
    @testset "add y root" begin
        E.eventlist() do
            cnt = Dict(
                "references" => [jsref(ymdl), jsref(ymdl.a), jsref(mdl)],
                "events" =>  [
                    js(E.RootAddedEvent(doc, mdl)),
                    js(E.RootAddedEvent(doc, ymdl))
                ],
            )

            @test length(doc.roots) == 0
            E.patchdoc!(doc, cnt, buf)
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
            E.patchdoc!(doc, cnt, buf)
            @test length(doc.roots) == 2
            @test doc.roots[end].a.id ≡ other.id
        end
    end
end
