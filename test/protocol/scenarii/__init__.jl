@BokehServer.wrap mutable struct X <: BokehServer.iModel
    a::Int
    b::Float64
end

@BokehServer.wrap mutable struct Cnt <: BokehServer.iModel
    a::Vector{X}
    b::Dict{String, X}
end

@BokehServer.wrap mutable struct Cds <: BokehServer.iModel
    data::BokehServer.Model.DataDict
end

function _compare(x::T, y::T) where {T <: Union{String, Symbol, Number}}
    @test x == y
end

function _compare(x::T, y::T) where {T <: BokehServer.iModel}
    for k ∈ fieldnames(T)
        (k ≡ :callbacks) && continue
        attrx = getfield(x, k)
        attry = getfield(y, k)
        @test typeof(attrx) ≡ typeof(attry)
        @test applicable(cmp, attrx, attry)
        _compare(attrx, attry)
    end
end

function _compare(x::AbstractArray{T}, y::AbstractArray{T}) where {T <: Union{String, Symbol, Number}}
    @test x == y
end

function _compare(x::AbstractArray{T}, y::AbstractArray{T}) where {T <: BokehServer.iModel}
    @test size(x) == size(y)
    for (i, j) ∈ zip(x, y)
        _compare(i, j)
    end
end

function _compare(x::AbstractDict{T, K}, y::AbstractDict{T, K}) where {T, K}
    @test length(x) == length(y)
    @test all(i ∈ keys(y) for i ∈ keys(x))
    @test all(i ∈ keys(x) for i ∈ keys(y))
    for (i, j) ∈ x
        _compare(j, y[i])
    end
end

function checkscenario(srv, client)
end

macro initscenario(codes...)
    code = :(push!(doc, $(codes...)))
    quote
        let srv    = BokehServer.Document()
            client = BokehServer.Document()
            BokehServer.Events.eventlist!(BokehServer.Events.NullEventList()) do
                ids = copy(BokehServer.AbstractTypes._ID)
                let doc = srv
                    $code
                end

                BokehServer.AbstractTypes._ID[:] .= ids
                let doc = client
                    $code
                end
            end
            (srv, client)
        end
    end
end

function runscenario(𝐹::Function, srv = BokehServer.Document(), client = BokehServer.Document())
    _compare(getfield(srv, :roots), getfield(client, :roots))

    outp = BokehServer.Protocol.patchdoc(𝐹, srv)
    @test !isnothing(outp)
    if !isnothing(outp)
        JSON   = BokehServer.Protocol.Messages.JSON
        cnv(x) = JSON.parse(JSON.json(x); dicttype = BokehServer.Protocol.Decoding.DataStructures.OrderedDict)

        BokehServer.Events.eventlist!(BokehServer.Events.NullEventList()) do
            BokehServer.Protocol.patchdoc!(client, cnv((; outp.events)), outp.buffers)
        end

        _compare(getfield(srv, :roots), getfield(client, :roots))
    end
    return (srv, client)
end

macro runscenario(codes...)
    quote
        let itms = @initscenario($(codes[1:end-1]...))
            runscenario(itms...) do doc::BokehServer.Document
                $(codes[end])
            end
            itms
        end
    end
end
