JSON = BokehServer.Protocol.Messages.JSON

@testset "send" begin
    doc  = BokehServer.Document()
    mdl  = ProtocolX(; id = 1)
    E    = BokehServer.Events
    json(x) = JSON.json(BokehServer.Protocol.serialize(x))

    val   = json(E.ModelChangedEvent(mdl, :a, 10, 20))
    truth = """{"attr":"a","hint":null,"kind":"ModelChanged","model":{"id":"1"},"new":20}"""
    @test JSON.parse(val) == JSON.parse(truth)

    val   = json(E.RootAddedEvent(doc, mdl, 1))
    truth = """{"kind":"RootAdded","model":{"id":"1"}}"""
    @test JSON.parse(val) == JSON.parse(truth)

    val   = json(E.RootRemovedEvent(doc, mdl, 1))
    truth = """{"kind":"RootRemoved","model":{"id":"1"}}"""
    @test JSON.parse(val) == JSON.parse(truth)

    E.eventlist!() do
        push!(doc, mdl)
        # next change should not be sent to the client as the model is brand new
        mdl.a = 100
        val   = JSON.json(BokehServer.Protocol.patchdoc(E.task_eventlist().events, doc, Set{Int64}()))
        truth = """{"events":[{"kind":"RootAdded","model":{"id":"1"}}],"""*
            """"references":[{"attributes":{"a":100},"id":"1","type":"$(nameof(ProtocolX))"}]}"""
        @test JSON.parse(val) == JSON.parse(truth)
    end

    E.eventlist!() do
        mdl.a = 10
        val   = JSON.json(BokehServer.Protocol.patchdoc(E.task_eventlist().events, doc, Set{Int64}([mdl.id])))
        truth = """{"events":[{"attr":"a","hint":null,"kind":"ModelChanged","model":{"id":"1"},"new":10}],"references":[]}"""
        @test JSON.parse(val) == JSON.parse(truth)
    end
end

X = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
    data :: BokehServer.Model.DataDict
end

@testset "receive" begin
    doc  = BokehServer.Document()
    mdl  = ProtocolX(; id = 100,a  = 10)
    E    = BokehServer.Events
    buf  = BokehServer.Protocol.Buffers()
    js(x)= JSON.parse(JSON.json(BokehServer.Protocol.serialize(x)))
    @testset "add first root" begin
        E.eventlist!() do
            cnt = Dict{String, Any}(
                "references" => Any[js(mdl)],
                "events" =>  Any[js(E.RootAddedEvent(doc, mdl, 1))],
            )

            @test isempty(doc)
            BokehServer.Protocol.patchdoc!(doc, cnt, buf)
            @test length(doc) == 1
            @test BokehServer.bokehid(doc[1]) == 100
            @test doc[1].a == 10
            @test doc[1] ≢ mdl
        end
    end

    @testset "add root again" begin
        E.eventlist!() do
            cnt = Dict{String, Any}(
                "references" => Any[],
                "events" =>  Any[js(E.RootAddedEvent(doc, mdl, 1))],
            )

            @test length(doc) == 1
            @test_throws ErrorException BokehServer.Protocol.patchdoc!(doc, cnt, buf)
            @test length(doc) == 1
        end
    end

    @testset "remove root" begin
        E.eventlist!() do
            cnt = Dict{String, Any}(
                "references" => Any[],
                "events" =>  Any[js(E.RootRemovedEvent(doc, mdl, 1))],
            )

            @test length(doc) == 1
            BokehServer.Protocol.patchdoc!(doc, cnt, buf)
            @test isempty(doc)
        end
    end

    @testset "change title" begin
        E.eventlist!() do
            cnt = Dict{String, Any}(
                "references" => Any[],
                "events" => Any[js(E.TitleChangedEvent(doc, "A"))],
            )

            setfield!(doc, :title, "----")
            BokehServer.Protocol.patchdoc!(doc, cnt, buf)
            @test doc.title == "A"
        end
    end

    ymdl  = ProtocolY()
    @testset "add y root" begin
        E.eventlist!() do
            cnt = Dict{String, Any}(
                "references" => Any[js(ymdl), js(ymdl.a), js(mdl)],
                "events" => Any[
                    js(E.RootAddedEvent(doc, mdl, 1)),
                    js(E.RootAddedEvent(doc, ymdl, 1))
                ],
            )

            @test isempty(doc)
            BokehServer.Protocol.patchdoc!(doc, cnt, buf)
            @test length(doc) == 2
            @test doc[1].id ≡ mdl.id
            @test doc[2].id ≡ ymdl.id
            @test doc[2].a.id ≡ ymdl.a.id
        end
    end

    @testset "change attribute" begin
        E.eventlist!() do
            other = ProtocolX()
            cnt = Dict{String, Any}(
                "references" => Any[js(other)],
                "events" => Any[js(E.ModelChangedEvent(ymdl, :a, nothing, other))],
            )

            @test length(doc) == 2
            @test last(doc).a.id ≢ other.id
            BokehServer.Protocol.patchdoc!(doc, cnt, buf)
            @test length(doc) == 2
            @test last(doc).a.id ≡ other.id
        end
    end

    @testset "action attribute" begin
        btn = BokehServer.Models.Button()
        E.eventlist!() do
            push!(getfield(doc, :roots), btn)

            called = Ref(false)
            BokehServer.onchange(btn) do x
                called[] = true
            end
                
            cnt = Dict{String, Any}(
                "references" => Any[],
                "events" => Any[js(BokehServer.ButtonClick(; model = btn))],
            )
            BokehServer.Protocol.patchdoc!(doc, cnt, buf)
            @test called[]
        end
    end

    @testset "complex obj attribute" begin
        E.eventlist!() do
            doc   = BokehServer.Document()
            a     = [ProtocolX(;a = 1), ProtocolX(;a = 2)]
            other = ProtocolZ(; a, b = (; value = 100, transform = a[1]))
            cnt = Dict{String, Any}(
                "references" => Any[js(other), js(other.a[1]), js(other.a[2])],
                "events" => Any[js(BokehServer.Events.RootAddedEvent(doc, other, 1))]
            )
            BokehServer.Protocol.patchdoc!(doc, cnt, buf)
            @test length(doc) ≡ 1
            @test [i.a for i ∈ first(doc).a] == [1, 2]
            @test first(doc).b.value ≡ 100
            @test first(doc).b.transform ≡ first(doc).a[1]
        end
    end
end

function _test_patch(𝐹::Function)
    E = BokehServer.Events
    E.eventlist!() do
        x, truth = 𝐹(:init, nothing)
        doc      = BokehServer.Document(; roots = BokehServer.iModel[x])
        𝐹(:mutate, x)
        val   = JSON.json(BokehServer.Protocol.patchdoc(E.task_eventlist().events, doc, Set{Int64}([x.id])))
        # the '2' has changed to a '1' !
        @test JSON.parse(val) == JSON.parse("""{"events":[$truth],"references":[]}""")

        x, truth = 𝐹(:init, nothing)
        doc      = BokehServer.Document(; roots = BokehServer.iModel[x])
        cnt      = Dict{String, Any}("references" => Any[], "events" => Any[JSON.parse(truth)])
        BokehServer.Protocol.patchdoc!(doc, cnt, BokehServer.Protocol.Buffers())
        @test 𝐹(:verify, x)
    end
end

@testset "patch!" begin
    _test_patch() do state, x
        return if state ≡ :init
            x = X(; data = Dict("a" => [1, 2]))
            x, """{"kind":"ColumnsPatched","column_source":{"id":"$(x.id)"},"patches":{"a":[[1,4]]}}"""
        elseif state ≡ :mutate
            merge!(x.data, "a" => 2 => 4)
        else
            x.data["a"][2] ≡ Int32(4)
        end
    end
end

@testset "selection.indices" begin
    _test_patch() do state, x
        return if state ≡ :init
            x =  BokehServer.Selection()
            x, """{"kind":"ModelChanged","attr":"indices","hint":null,"new":[0,1,2,3,4],"model":{"id":"$(x.id)"}}"""
        elseif state ≡ :mutate
            x.indices = collect(1:5)
        else
            x.indices.values == collect(1:5)
        end
    end
end
