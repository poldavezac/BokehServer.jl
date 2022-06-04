E    = Bokeh.Events
ser  = Bokeh.Protocol.Serialize.serialize

CDS  = @Bokeh.model mutable struct gensym() <: Bokeh.iModel
    data :: Bokeh.Model.DataSource
end

@testset "basic events" begin
    doc  = Bokeh.Document()
    mdl  = ProtocolX(; id = 1)

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

@testset "ColumnDataChanged" begin
    mdl   = CDS(; id = 1)
    𝑅     = Bokeh.Protocol.Serialize.BufferedRules()
    val   = ser(E.ColumnDataChangedEvent(mdl, :data, Dict{String, Vector}("a" => Int32[1])), 𝑅)
    truth = (;
        cols = ["a"],
        column_source = (; id = "1"),
        kind = :ColumnDataChanged,
        new = Dict("a" => (;
            __buffer__ = "1",
            dtype      = "int32",
            order      = Base.ENDIAN_BOM ≡ 0x04030201 ? :little : :big,
            shape      = (1,),
        ))
    )
    @test propertynames(truth) ≡ propertynames(val)
    for i ∈ propertynames(truth)
        if i ≢ :new
            @test getfield(val, i) == getfield(truth, i)
        end
    end
    @test val.new isa Dict && collect(keys(val.new)) == ["a"]
    @test keys(truth.new["a"]) ≡ keys(val.new["a"])
    for i ∈ keys(truth.new["a"])
        if i ≢ :__buffer__
            @test val.new["a"][i] == truth.new["a"][i]
        end
    end
    @test Set([val.new["a"][:__buffer__]]) == Set([i for (i, _) ∈ 𝑅.buffers])
    @test reinterpret(Int32, last(𝑅.buffers[1])) == Int32[1]
end

@testset "ColumnsStreamed" begin
    mdl  = CDS(; id = 1, data = Dict("a" => Int32[1, 2, 3]))

    val   = ser(E.ColumnsStreamedEvent(mdl, :data, Dict{String, Vector}("a" => Int32[4]), nothing))
    truth = (;
        column_source = (; id = "1"),
        data = Dict("a" => Int32[4]),
        kind = :ColumnsStreamed,
        rollover = nothing,
    )
    @test propertynames(truth) ≡ propertynames(val)
    for i ∈ propertynames(truth)
        if i ≢ :data
            @test getfield(val, i) == getfield(truth, i)
        end
    end
    @test val.data isa Dict && collect(keys(val.data)) == ["a"]
    @test keys(truth.data["a"]) ≡ keys(val.data["a"])
    @test val.data["a"] == truth.data["a"]
end

@testset "ColumnsPatched" begin
    mdl  = CDS(; id = 1, data = Dict(
        "a" => Int32[1, 2, 3], "b" => [[1 2; 3 4] for _ ∈ 1:3]
    ))

    val   = ser(E.ColumnsPatchedEvent(
        mdl,
        :data,
        Dict{String, Vector{Pair}}(
            "a" => [1=>2, 2:2=>[4]],
            "b" => [(1, 1, 1:2) => [4, 4]]
        )
    ))

    truth = (;
        column_source = (; id = "1"),
        kind = :ColumnsPatched,
        patches = Dict{String, Vector}(
            "a" => [(0, 2), ((; start = 1, step = 1, stop = 2), [4])],
            "b" => [((0, 0, (; start = 0, step = 1, stop = 2)), [4, 4])]
        )
    )
    @test propertynames(truth) ≡ propertynames(val)
    for i ∈ propertynames(truth)
        if i ≢ :patches
            @test getfield(val, i) == getfield(truth, i)
        end
    end
    @test val.patches isa Dict
    @test sort(collect(keys(val.patches))) == ["a", "b"]
    @test val.patches["a"] == truth.patches["a"]
    @test val.patches["b"] == truth.patches["b"]
end
