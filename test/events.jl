EventsX = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
    a::Int = 1
    b::Int = 1
    c::Int = 1
end

EventsY = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
    a::EventsX = EventsX(; a = -1)
end

@testset "event compare" begin
    m1 = EventsX()
    m2 = EventsX()
    args = [m1, :a, 1, 10]
    e1 = BokehServer.Events.ModelChangedEvent(args...)
    for (i, j) ∈ enumerate((m2, :b, 2, 11))
        a2 = copy(args)
        a2[i] = j
        e2 = BokehServer.Events.ModelChangedEvent(a2...)
        @test !BokehServer.Model.compare(e1, e2)
    end
    e2 = BokehServer.Events.ModelChangedEvent(args...)
    @test BokehServer.Model.compare(e1, e2)
end

@testset "create model events" begin
    obj = EventsX()

    BokehServer.Events.eventlist!() do
        lst = BokehServer.Events.task_eventlist()
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

    doc = BokehServer.Document()
    push!(getfield(doc, :roots), ini)

    obj = EventsX()

    BokehServer.Events.eventlist!() do
        lst = BokehServer.Events.task_eventlist()
        @test isempty(lst)

        push!(doc, obj)
        @test length(lst.events) == 1
        @test first(lst.events) isa BokehServer.Events.RootAddedEvent
        @test first(lst.events).doc.id == doc.id
        @test first(lst.events).root.id == obj.id

        delete!(doc, obj)
        @test isempty(lst.events)

        delete!(doc, ini)
        @test length(lst.events) == 1
        @test first(lst.events) isa BokehServer.Events.RootRemovedEvent
        @test first(lst.events).doc.id == doc.id
        @test first(lst.events).root.id == ini.id

        doc.title = "A"
        @test length(lst.events) == 2
        @test last(lst.events) isa BokehServer.Events.TitleChangedEvent
        @test last(lst.events).doc.id == doc.id
        @test last(lst.events).title == "A"
    end
end

@testset "check model callback" begin
    obj1 = EventsX()
    obj2 = EventsX()
    calls1 = []
    calls2 = BokehServer.ModelChangedEvent[]

    BokehServer.onchange(obj1) do obj, attr, new, old 
        push!(calls1, (obj, attr, old, new))
    end

    BokehServer.onchange(obj2) do evt
        push!(calls2, evt)
    end

    BokehServer.Events.eventlist!() do
        obj1.a = 10
        obj1.b = 10
        obj2.a = 10
    end

    @test length(calls1) == 2
    @test length(calls2) == 1
end

@testset "check document callback" begin
    obj1 = EventsX()
    obj2 = EventsX()
    doc  = BokehServer.Document()
    push!(getfield(doc, :roots), obj2)
    calls1 = BokehServer.Events.iDocEvent[]
    calls2 = BokehServer.RootAddedEvent[]

    BokehServer.onchange(doc) do evt
        push!(calls1, (evt))
    end

    BokehServer.onchange(doc) do evt::BokehServer.RootAddedEvent
        push!(calls2, (evt))
    end

    BokehServer.Events.eventlist!() do
        push!(doc, obj1)
        delete!(doc, obj2)
    end

    @test length(calls1) == 2
    @test length(calls2) == 1

    BokehServer.Events.eventlist!() do
        doc.title = "A"
    end

    @test length(calls1) == 3
    @test length(calls2) == 1
end

@testset "check action callback" begin
    obj = BokehServer.Models.Button()
    doc = BokehServer.Document()
    push!(getfield(doc, :roots), obj)
    calls = Any[]

    BokehServer.onchange(doc) do evt::BokehServer.DocumentReady
        push!(calls, evt)
    end

    BokehServer.Events.eventlist!() do
        BokehServer.onchange(obj) do evt::BokehServer.ButtonClick
            push!(calls, evt)
        end
    end
    @test obj.subscribed_events.values == Symbol[:button_click]

    BokehServer.Events.eventlist!() do
        BokehServer.Events.trigger(BokehServer.DocumentReady(; doc = doc))
        BokehServer.Events.trigger(BokehServer.ButtonClick(; model = obj))
    end

    @test length(calls) == 2
    @test calls[1] isa BokehServer.DocumentReady
    @test calls[2] isa BokehServer.ButtonClick
end
