
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
        @test length(lst.events) == 0

        obj.a = 2   
        @test length(lst.events) == 1
        itm = first(lst.events)
        @test (itm[1].model.id, itm[1].attr) == (obj.id, :a)
        @test (itm[2].old, itm[2].new) == (1, 2)

        obj.b += 2 
        @test length(lst.events) == 2
        itm = collect(lst.events)[end]
        @test (itm[1].model.id,  itm[1].attr) == (obj.id, :b)
        @test (itm[2].old, itm[2].new)  == (1, 3)

        obj.a = 3
        @test length(lst.events) == 2
        itm = first(lst.events)
        @test (itm[1].model.id, itm[1].attr) == (obj.id, :a)
        @test (itm[2].old, itm[2].new) == (1, 3)


        obj.a = 1
        @test length(lst.events) == 1
        @test first(keys(lst.events)).attr == :b
    end
end

@testset "create doc events" begin
    ini = EventsX()

    doc = Bokeh.Document()
    push!(doc.roots, ini)

    obj = EventsX()

    Bokeh.Events.eventlist() do
        lst = Bokeh.Events.task_eventlist()
        @test length(lst.events) == 0

        push!(doc, obj)
        @test length(lst.events) == 1
        @test first(keys(lst.events)) isa Bokeh.Events.RootAddedKey
        @test first(keys(lst.events)).doc.id == doc.id
        @test first(keys(lst.events)).root.id == obj.id

        delete!(doc, obj)
        @test length(lst.events) == 0

        delete!(doc, ini)
        @test length(lst.events) == 1
        @test first(keys(lst.events)) isa Bokeh.Events.RootRemovedKey
        @test first(keys(lst.events)).doc.id == doc.id
        @test first(keys(lst.events)).root.id == ini.id
    end
end

@testset "check callback" begin
    obj1 = EventsX()
    obj2 = EventsX()
    calls = []

    @Bokeh.addcallback! obj1.a push!(calls, (obj1, attribute, old, new))

    Bokeh.Events.eventlist() do
        obj1.a = 10
        obj1.b = 10
        obj2.a = 10

        Bokeh.Events.flushevents!(Bokeh.Events.task_eventlist())
    end

    @test calls == [(obj1, :a, 1, 10)]
end

@testset "send" begin
    doc  = Bokeh.Document()
    mdl  = EventsX(; id = 1)
    E    = Bokeh.Events
    json = E.Send.dojson

    val   = json(E.ModelChangedKey(mdl, :a) => E.ModelChangedEvent(10, 20))
    truth = """{"attr":"a","hint":null,"kind":"ModelChanged","model":{"id":"1"},"new":20}"""
    @test val == truth

    val   = json(E.RootAddedKey(doc, mdl)=>nothing)
    truth = """{"kind":"RootAdded","model":{"id":"1"}}"""
    @test val == truth


    val   = json(E.RootRemovedKey(doc, mdl)=>nothing)
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
                "events" =>  [js(E.RootAddedKey(doc, mdl)=>nothing)],
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
                "events" =>  [js(E.RootAddedKey(doc, mdl)=>nothing)],
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
                "events" =>  [js(E.RootRemovedKey(doc, mdl)=>nothing)],
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
                    js(E.RootAddedKey(doc, mdl)=>nothing),
                    js(E.RootAddedKey(doc, ymdl)=>nothing)
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
                "events" =>  [js(E.ModelChangedKey(ymdl, :a)=>E.ModelChangedEvent(nothing, other))],
            )

            @test length(doc.roots) == 2
            @test doc.roots[end].a.id ≢ other.id
            E.patchdoc!(doc, cnt, buf)
            @test length(doc.roots) == 2
            @test doc.roots[end].a.id ≡ other.id
        end
    end
end
