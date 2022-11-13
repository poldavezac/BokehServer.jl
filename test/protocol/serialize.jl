E    = BokehServer.Events
ser  = BokehServer.Protocol.serialize
JSD  = BokehServer.Protocol.Encoding.JSDict

CDS  = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
    data :: BokehServer.Model.DataDict
end

@testset "basic events" begin
    doc  = BokehServer.Document()
    mdl  = ProtocolX(; id = 1)

    val   = ser(E.ModelChangedEvent(mdl, :a, 10, 20))
    truth = JSD(
        "attr" => "a", "kind" => "ModelChanged",
        "model" => JSD("id" => "1"), "new" => 20
    )
    @test val == truth

    val   = ser(E.RootAddedEvent(doc, mdl, 1))
    truth = JSD(
        "kind" => "RootAdded", "model" => JSD("name" => "$(nameof(ProtocolX))", "id" => "1", "type" => "object")
    )
    @test val == truth


    val   = ser(E.RootRemovedEvent(doc, mdl, 1))
    truth = JSD("kind" => "RootRemoved", "model" => JSD("id" => "1"))
    @test val == truth

    E.eventlist!() do
        push!(doc, mdl)
        mdl.a = 100
        val   = BokehServer.Protocol.patchdoc(E.task_eventlist().events, doc, Set{Int64}())
        truth = (;
            events = Any[JSD(
                "kind"  => "RootAdded",
                "model" => JSD(
                    "attributes" => JSD("a" => 100), "id" => "1",
                    "name" => "$(nameof(ProtocolX))", "type" => "object"
                )
            )],
        )
        @test (; val.events) == truth
    end

    E.eventlist!() do
        mdl.a = 10
        val   = BokehServer.Protocol.patchdoc(E.task_eventlist().events, doc, Set{Int64}([mdl.id]))
        truth = (;
            events = [JSD(
                "kind" => "ModelChanged",
                "model" => JSD("id" => "1"),
                "attr" => "a",
                "new" => 10
            )],
            buffers = Pair{String, Vector{UInt8}}[],
        )
        @test val == truth
    end
end

@testset "tuples" begin
    @test BokehServer.Protocol.serialize((;a = [1])) == JSD("type" => "map", "entries" => Any[("a", Any[1.0])])
    @test BokehServer.Protocol.serialize(([1],)) == Any[Any[1.0]]
end

@testset "numbers" begin
    @test BokehServer.Protocol.serialize(1) ≡ 1
    @test BokehServer.Protocol.serialize(one(UInt8)) ≡ one(UInt8)
end

@testset "ColumnDataChanged" begin
    mdl   = CDS(; id = 1)
    𝑅     = BokehServer.Protocol.Encoder(; deferred = false)
    val   = ser(E.ColumnDataChangedEvent(mdl, :data, Dict{String, Vector}("a" => Int32[1])), 𝑅)
    truth = JSD(
        "kind" => "ColumnDataChanged",
        "model" => JSD("id" => "1"),
        "data" => JSD(
            "type" => "map",
            "entries" => Any[
                ("a", JSD(
                    "dtype" => "int32",
                    "shape" => (1,),
                    "array" => JSD("data" => "AQAAAA==", "type" => "bytes"),
                    "order" => Base.ENDIAN_BOM ≡ 0x04030201 ? "little" : "big",
                    "type" => "ndarray"
                ))
            ]
        ),
        "attr" => "data",
        "cols" => Any["a"]
    )

    @test truth == val
    @test isempty(𝑅.buffers)
end

@testset "ColumnsStreamed" begin
    mdl   = CDS(; id = 1, data = Dict("a" => Int32[1, 2, 3]))
    𝑅     = BokehServer.Protocol.Encoder(; deferred = false)
    val   = ser(E.ColumnsStreamedEvent(mdl, :data, Dict{String, Vector}("a" => Int32[4]), nothing), 𝑅)
    truth = JSD(
        "model" => JSD("id" => "1"),
        "data" => JSD(
            "type" => "map",
            "entries" => Any[
                ("a", JSD(
                    "dtype" => "int32",
                    "shape" => (1,),
                    "array" => JSD("data" => "BAAAAA==", "type" => "bytes"),
                    "order" => Base.ENDIAN_BOM ≡ 0x04030201 ? "little" : "big",
                    "type" => "ndarray"
                ))
            ]
        ),
        "attr" => "data",
        "kind" => "ColumnsStreamed",
        "rollover" => nothing,
    )
    @test truth == val
end

@testset "ColumnsPatched" begin
    mdl  = CDS(; id = 1, data = Dict(
        "a" => Int32[1, 2, 3], "b" => [Int32[1 2; 3 4] for _ ∈ 1:3]
    ))

    val   = ser(
        E.ColumnsPatchedEvent(
            mdl,
            :data,
            Dict{String, Vector{Pair}}(
                "a" => [1=>2, 2:2 => Int32[4]],
                "b" => [(1, 1, 1:2) => Int32[4, 4]]
            )
        ),
        BokehServer.Protocol.Encoder(; deferred = false)
    )

    truth = JSD(
        "kind" => "ColumnsPatched",
        "model" => JSD("id" => "1"),
        "attr" => "data",
        "patches" => JSD(
            "type" => "map",
            "entries" => Any[
                ("b", Any[(
                    (0, 0, JSD("type" => "slice", "start" => 0, "step" => 1, "stop" => 2)),
                    Any[4, 4]
                )]),
                ("a", Any[
                    (0, 2),
                    (
                        JSD("type" => "slice", "start" => 1, "step" => 1, "stop" => 2),
                        Int32[4]
                    )
                ]),
            ]
        ),
    )
    @test truth == val
end

@testset "dataspec" begin
    mdl   = CDS(; id = 1)
    𝑅     = BokehServer.Protocol.Encoder()
    ser   = BokehServer.Protocol.serialize
    Model = BokehServer.Model
    @test ser(Model.IntSpec(1), 𝑅)  == JSD("type" => "value", "value" => 1)
    @test ser(Model.IntSpec(1, mdl), 𝑅)  == JSD(
        "type" => "value",
        "value" => 1,
        "transform" => JSD("name" => "$(nameof(CDS))", "id" => "1", "type" => "object")
    )
    @test ser(Model.IntSpec(Model.Column("a")), 𝑅)  == JSD("type" => "field", "field" => "a")
    @test ser(Model.bokehconvert(Model.DistanceSpec, (; value = 1., units = :screen)), 𝑅)  == JSD("type" => "value", "value" => 1., "units" => "screen")
end
