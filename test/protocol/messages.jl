@testset "send ACK" begin
    val   = collect(Bokeh.Protocol.Messages.message(Bokeh.Protocol.Messages.msg"ACK"; msgid = 1001))
    @test Bokeh.Protocol.JSON.parse(val[1]) == Dict{String, Any}("msgid"=>"1001", "msgtype" => "ACK")
    @test val[2:end] == ["{}", "{}"]
end

@testset "send OK" begin
    val   = collect(Bokeh.Protocol.Messages.message(Bokeh.Protocol.Messages.msg"OK", "AAA"; msgid = 1001))
    @test Bokeh.Protocol.JSON.parse(val[1]) == Dict{String, Any}(
        "msgid"=>"1001", "msgtype" => "OK", "reqid" => "AAA"
    )
    @test val[2:end] == ["{}", "{}"]
end

@testset "send ERROR" begin
    try
        throw(ErrorException("?"))
    catch exc
        val   = collect(Bokeh.Protocol.Messages.message(Bokeh.Protocol.Messages.msg"ERROR", "AAA", "BBB"; msgid = 1001))
        @test Bokeh.Protocol.JSON.parse(val[1]) == Dict{String, Any}(
            "msgid"=>"1001", "msgtype" => "ERROR", "reqid" => "AAA"
        )
        let dico = Bokeh.Protocol.JSON.parse(val[end])
            @test typeof(dico) == Dict{String, Any}
            @test Set(collect(keys(dico))) == Set(["text", "traceback"])
            @test dico["text"] == "BBB"
            @test startswith(dico["traceback"], "?\nStacktrace:\n")
        end
    end
end

@testset "send PATCHDOC" begin
    val   = collect(Bokeh.Protocol.Messages.message(
        Bokeh.Protocol.Messages.msg"PATCH-DOC", (; a = "AAA"), ["A"=>UInt8['B']])
    )
    @test Bokeh.Protocol.JSON.parse(val[1]) == Dict{String, Any}(
        "msgid"=>"1001", "msgtype" => "PATCH-DOC", "num_buffers" => 1
    )
    @test val[2:end] == ["{}", """{"a":"AAA"}""", "A", UInt8['B']]
end

