ProtocolX = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
    a::Int = 1
    b::Int = 1
    c::Int = 1
end

ProtocolY = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
    a::ProtocolX = ProtocolX(; a = -1)
end
