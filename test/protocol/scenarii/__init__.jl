@Bokeh.model mutable struct X <: Bokeh.iModel
    a::Int
    b::Float64
end

@Bokeh.model mutable struct Cnt <: Bokeh.iModel
    a::Vector{X}
    b::Dict{String, X}
end

@Bokeh.model mutable struct Cds <: Bokeh.iModel
    data::Bokeh.Model.DataSource
end

function _compare(x::T, y::T) where {T <: Union{String, Symbol, Number}}
    @test x == y
end

function _compare(x::T, y::T) where {T <: Bokeh.iModel}
    for k ∈ fieldnames(T)
        (k ≡ :callbacks) && continue
        attrx = getfield(x, k)
        attry = getfield(y, k)
        @test typeof(attrx) ≡ typeof(attry)
        @test applicable(cmp, attrx, attry)
        _compare(attrx, attry)
    end
end

function _compare(x::Array{T}, y::Array{T}) where {T <: Union{String, Symbol, Number}}
    @test x == y
end

function _compare(x::Array{T}, y::Array{T}) where {T <: Bokeh.iModel}
    @test size(x) == size(y)
    for (i, j) ∈ zip(x, y)
        _compare(i, j)
    end
end

function _compare(x::Dict{T, K}, y::Dict{T, K}) where {T, K}
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
        let srv    = Bokeh.Document()
            client = Bokeh.Document()
            Bokeh.Events.eventlist!(Bokeh.Events.NullEventList()) do
                ids = copy(Bokeh.Model.ID.ids)
                let doc = srv
                    $code
                end

                Bokeh.Model.ID.ids[:] .= ids
                let doc = client
                    $code
                end
            end
            (srv, client)
        end
    end
end

function runscenario(𝐹::Function, srv = Bokeh.Document(), client = Bokeh.Document())
    _compare(srv.roots, client.roots)

    evts = Bokeh.Protocol.patchdoc(𝐹, srv)

    JSON = Bokeh.Protocol.Messages.JSON
    cnv  = JSON.parse ∘ JSON.json
    Bokeh.Events.eventlist!(Bokeh.Events.NullEventList()) do
        Bokeh.Protocol.patchdoc!(client, cnv(evts), Bokeh.Protocol.Buffers())
    end

    _compare(srv.roots, client.roots)
    return (srv, client)
end

macro runscenario(codes...)
    quote
        let itms = @initscenario($(codes[1:end-1]...))
            runscenario(itms...) do doc::Bokeh.Document
                $(codes[end])
            end
            itms
        end
    end
end
