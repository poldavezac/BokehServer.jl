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

    @test length(calls1) == 2
    @test length(calls2) == 1
end
