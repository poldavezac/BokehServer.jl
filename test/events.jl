EventsX = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
    a::Int = 1
    b::Int = 1
    c::Int = 1
end

EventsY = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
    a::EventsX = EventsX(; a = -1)
end

@testset "create model events" begin
    obj = EventsX()

    BokehJL.Events.eventlist!() do
        lst = BokehJL.Events.task_eventlist()
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

    doc = BokehJL.Document()
    push!(getfield(doc, :roots), ini)

    obj = EventsX()

    BokehJL.Events.eventlist!() do
        lst = BokehJL.Events.task_eventlist()
        @test isempty(lst)

        push!(doc, obj)
        @test length(lst.events) == 1
        @test first(lst.events) isa BokehJL.Events.RootAddedEvent
        @test first(lst.events).doc.id == doc.id
        @test first(lst.events).root.id == obj.id

        delete!(doc, obj)
        @test isempty(lst.events)

        delete!(doc, ini)
        @test length(lst.events) == 1
        @test first(lst.events) isa BokehJL.Events.RootRemovedEvent
        @test first(lst.events).doc.id == doc.id
        @test first(lst.events).root.id == ini.id

        doc.title = "A"
        @test length(lst.events) == 2
        @test last(lst.events) isa BokehJL.Events.TitleChangedEvent
        @test last(lst.events).doc.id == doc.id
        @test last(lst.events).title == "A"
    end
end

@testset "check model callback" begin
    obj1 = EventsX()
    obj2 = EventsX()
    calls1 = []
    calls2 = BokehJL.ModelChangedEvent[]

    BokehJL.onchange(obj1) do obj, attr, new, old 
        push!(calls1, (obj, attr, old, new))
    end

    BokehJL.onchange(obj2) do evt
        push!(calls2, evt)
    end

    BokehJL.Events.eventlist!() do
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
    doc  = BokehJL.Document()
    push!(getfield(doc, :roots), obj2)
    calls1 = BokehJL.Events.iDocEvent[]
    calls2 = BokehJL.RootAddedEvent[]

    BokehJL.onchange(doc) do evt
        push!(calls1, (evt))
    end

    BokehJL.onchange(doc) do evt::BokehJL.RootAddedEvent
        push!(calls2, (evt))
    end

    BokehJL.Events.eventlist!() do
        push!(doc, obj1)
        delete!(doc, obj2)
    end

    @test length(calls1) == 2
    @test length(calls2) == 1

    BokehJL.Events.eventlist!() do
        doc.title = "A"
    end

    @test length(calls1) == 3
    @test length(calls2) == 1
end

@testset "check action callback" begin
    obj = BokehJL.Models.Button()
    doc = BokehJL.Document()
    push!(getfield(doc, :roots), obj)
    calls = Any[]

    BokehJL.onchange(doc) do evt::BokehJL.Models.Actions.DocumentReady
        push!(calls, evt)
    end

    BokehJL.Events.eventlist!() do
        BokehJL.onchange(obj) do evt::BokehJL.Models.Actions.ButtonClick
            push!(calls, evt)
        end
    end
    @test obj.subscribed_events.values == Symbol[:button_click]

    BokehJL.Events.eventlist!() do
        BokehJL.Events.trigger(BokehJL.Models.Actions.DocumentReady(; doc = doc))
        BokehJL.Events.trigger(BokehJL.Models.Actions.ButtonClick(; model = obj))
    end

    @test length(calls) == 2
    @test calls[1] isa BokehJL.Models.Actions.DocumentReady
    @test calls[2] isa BokehJL.Models.Actions.ButtonClick
end
