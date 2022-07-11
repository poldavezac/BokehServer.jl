X = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
    source :: BokehJL.Model.DataDict = zero
end

Y = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
    a:: Int
end

@testset "children" begin
    x = X(; source = Dict("a" => [Y(; a = 1), Y(; a = 2)]))
    @test x.source isa BokehJL.Model.DataDictContainer
    y = [i.a for i ∈ BokehJL.Model.bokehchildren(x)]
    @test y == [1, 2]
end

@testset "merge!" begin
    x = X(; source = Dict("a" => [1, 2]))
    BokehJL.Events.eventlist!() do
        merge!(x.source, Dict("a" => [1, 2, 3], "b" => ["1", "2", "3"]))
        evt = BokehJL.Events.task_eventlist().events[1]
        @test evt isa BokehJL.Events.ColumnDataChangedEvent
        @test Set(keys(x.source)) == Set(["a", "b"]) 
        @test x.source["a"] == [1, 2, 3]
        @test x.source["b"] == ["1", "2", "3"]
    end
end

@testset "push!" begin
    for arr ∈ ([1, 2], [1., 2.])
        x = X(; source = Dict("a" => arr))
        BokehJL.Events.eventlist!() do
            push!(x.source, Dict("a" => [3, 4, 5], "b" => ["1", "2", "3", "4", "5"]))
            evt = BokehJL.Events.task_eventlist().events[1]
            @test evt isa BokehJL.Events.ColumnsStreamedEvent
            @test Set(keys(x.source)) == Set(["a", "b"]) 
            @test x.source["a"] == eltype(arr)[1, 2, 3, 4, 5]
            @test x.source["b"] == ["1", "2", "3", "4", "5"]
        end
    end
end

@testset "merge with patch!" for i ∈ ("a" => 2 => 4, "a" => 2:2 => [4])
    x = X(; source = Dict("a" => [1, 2]))
    BokehJL.Events.eventlist!() do
        merge!(x.source, i)
        evt = BokehJL.Events.task_eventlist().events[1]
        @test evt isa BokehJL.Events.ColumnsPatchedEvent
        @test Set(keys(x.source)) == Set(["a"]) 
        @test x.source["a"] == [1, 4]
    end
end

@testset "patch! image" for i ∈ ("a" => (1, 2, 1) => 10,  "a" => (1, 2:2, 1:1) => [10])
    x = X(; source = Dict("a" => [reshape(collect(1:4), (2, 2)) for _ ∈ 1:2]))
    truth = [reshape(collect(1:4), (2, 2)) for _ ∈ 1:2]
    truth[1][2, 1] = 10
    BokehJL.Events.eventlist!() do
        merge!(x.source, i)
        evt = BokehJL.Events.task_eventlist().events[1]
        @test evt isa BokehJL.Events.ColumnsPatchedEvent
        @test Set(keys(x.source)) == Set(["a"]) 

        @test x.source["a"] == truth
    end
end
