@BokehJL.wrap mutable struct X <: BokehJL.iModel
    a::Int
    b::Float64
end

@BokehJL.wrap mutable struct Cnt <: BokehJL.iModel
    a::Vector{X}
    b::Dict{String, X}
end

@BokehJL.wrap mutable struct Cds <: BokehJL.iModel
    data::BokehJL.Model.DataDict
end

function _compare(x::T, y::T) where {T <: Union{String, Symbol, Number}}
    @test x == y
end

function _compare(x::T, y::T) where {T <: BokehJL.iModel}
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

function _compare(x::AbstractArray{T}, y::AbstractArray{T}) where {T <: BokehJL.iModel}
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
        let srv    = BokehJL.Document()
            client = BokehJL.Document()
            BokehJL.Events.eventlist!(BokehJL.Events.NullEventList()) do
                ids = copy(BokehJL.Model.ID.ids)
                let doc = srv
                    $code
                end

                BokehJL.Model.ID.ids[:] .= ids
                let doc = client
                    $code
                end
            end
            (srv, client)
        end
    end
end

function runscenario(𝐹::Function, srv = BokehJL.Document(), client = BokehJL.Document())
    _compare(getfield(srv, :roots), getfield(client, :roots))

    evts = BokehJL.Protocol.patchdoc(𝐹, srv)
    @test !isnothing(evts)
    if !isnothing(evts)
        JSON = BokehJL.Protocol.Messages.JSON
        cnv  = JSON.parse ∘ JSON.json
        BokehJL.Events.eventlist!(BokehJL.Events.NullEventList()) do
            BokehJL.Protocol.patchdoc!(client, cnv(evts), BokehJL.Protocol.Buffers())
        end

        _compare(getfield(srv, :roots), getfield(client, :roots))
    end
    return (srv, client)
end

macro runscenario(codes...)
    quote
        let itms = @initscenario($(codes[1:end-1]...))
            runscenario(itms...) do doc::BokehJL.Document
                $(codes[end])
            end
            itms
        end
    end
end
