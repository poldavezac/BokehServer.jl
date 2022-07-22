ProtocolX = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
    a::Int = 1
    b::Int = 1
    c::Int = 1
end

ProtocolY = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
    a::ProtocolX = ProtocolX(; a = -1)
end

ProtocolZ = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
    a::Vector{ProtocolX}
    b::BokehServer.Model.IntSpec
    c::Int = 1
end
