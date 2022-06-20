ProtocolX = @Bokeh.wrap mutable struct gensym() <: Bokeh.iModel
    a::Int = 1
    b::Int = 1
    c::Int = 1
end

ProtocolY = @Bokeh.wrap mutable struct gensym() <: Bokeh.iModel
    a::ProtocolX = ProtocolX(; a = -1)
end
