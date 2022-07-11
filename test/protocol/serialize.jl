E    = BokehJL.Events
ser  = BokehJL.Protocol.Serialize.serialize

CDS  = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
    data :: BokehJL.Model.DataDict
end

@testset "basic events" begin
    doc  = BokehJL.Document()
    mdl  = ProtocolX(; id = 1)

    val   = ser(E.ModelChangedEvent(mdl, :a, 10, 20))
    truth = Dict{Symbol, Any}(
        :attr => :a, :hint => nothing, :kind => :ModelChanged,
        :model => Dict{Symbol, Any}(:id => "1"), :new => 20
    )
    @test val == truth

    val   = ser(E.RootAddedEvent(doc, mdl, 1))
    truth = Dict{Symbol, Any}(:kind => :RootAdded, :model => Dict{Symbol, Any}(:id => "1"))
    @test val == truth


    val   = ser(E.RootRemovedEvent(doc, mdl, 1))
    truth = Dict{Symbol, Any}(:kind => :RootRemoved, :model => Dict{Symbol, Any}(:id => "1"))
    @test val == truth

    E.eventlist!() do
        push!(doc, mdl)
        mdl.a = 100
        val   = BokehJL.Protocol.patchdoc(E.task_eventlist().events, doc, Set{Int64}())
        truth = (;
            events = [Dict{Symbol, Any}(:kind => :RootAdded, :model => Dict{Symbol, Any}(:id => "1"))],
            references = [Dict{Symbol, Any}(:attributes => Dict{Symbol, Any}(:a => 100), :id => "1", :type => nameof(ProtocolX))]
        )
        @test val == truth
    end

    E.eventlist!() do
        mdl.a = 10
        val   = BokehJL.Protocol.patchdoc(E.task_eventlist().events, doc, Set{Int64}([mdl.id]))
        truth = (;
            events = [Dict{Symbol, Any}(
                :attr => :a, :hint => nothing, :kind => :ModelChanged,
                :model => Dict{Symbol, Any}(:id => "1"), :new => 10
            )],
            references = []
        )
        @test val == truth
    end
end

@testset "ColumnDataChanged" begin
    mdl   = CDS(; id = 1)
    𝑅     = BokehJL.Protocol.Serialize.BufferedRules()
    val   = ser(E.ColumnDataChangedEvent(mdl, :data, Dict{String, Vector}("a" => Int32[1])), 𝑅)
    truth = Dict{Symbol,Any}(
        :cols => ["a"],
        :column_source => Dict{Symbol, Any}(:id => "1"),
        :kind => :ColumnDataChanged,
        :new => Dict{String, Union{Dict{Symbol, Any}, Vector}}("a" => Dict{Symbol, Any}(
            :__ndarray__ => String(BokehJL.Protocol.Serialize.base64encode(Int32[1])),
            :dtype      => "int32",
            :order      => Base.ENDIAN_BOM ≡ 0x04030201 ? :little : :big,
            :shape      => (1,),
        ))
    )
    @test truth == val
    @test isempty(𝑅.buffers)
end

@testset "ColumnsStreamed" begin
    mdl  = CDS(; id = 1, data = Dict("a" => Int32[1, 2, 3]))

    val   = ser(E.ColumnsStreamedEvent(mdl, :data, Dict{String, Vector}("a" => Int32[4]), nothing))
    truth = Dict{Symbol, Any}(
        :column_source => Dict{Symbol, Any}(:id => "1"),
        :data => Dict{String, Union{Dict{Symbol, Any}, Vector}}("a" => Int32[4]),
        :kind => :ColumnsStreamed,
        :rollover => nothing,
    )
    @test truth == val
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

    truth = Dict{Symbol, Any}(
        :column_source => Dict{Symbol, Any}(:id => "1"),
        :kind => :ColumnsPatched,
        :patches => Dict{String, Union{Dict{Symbol, Any}, Vector}}(
            "a" => [(0, 2), (Dict{Symbol, Any}(:start => 1, :step => 1, :stop => 2), [4])],
            "b" => [((0, 0, Dict{Symbol, Any}(:start => 0, :step => 1, :stop => 2)), [4, 4])]
        )
    )
    @test truth == val
end
