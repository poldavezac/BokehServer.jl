using Dates

struct DataSource <: iContainer{DataDict}
    parent :: WeakRef
    attr   :: Symbol
    values :: DataDict
end

Base.setindex!(γ::DataSource, 𝑘, 𝑣) = (merge!(γ, 𝑘 => 𝑣); 𝑣)
Base.size(γ::DataSource) = isempty(γ.values) ? (0, 0) : (length(first(values(γ.values))), length(γ.values))
Base.size(γ::DataSource, i :: Int) = isempty(γ.values) ? 0 : i ≡ 1 ? length(first(values(γ.values))) : length(γ.values)

macro _𝑑𝑠_trigger(T, args...)
    esc(quote
        let parent = γ.parent.value
            if (dotrigger && !isnothing(parent) && (getfield(parent, γ.attr) ≡ γ.values))
                Bokeh.Events.trigger(Bokeh.Events.$T(parent, γ.attr, $(args...)))
            end
        end
    end)
end

macro _𝑑𝑠_merge_args(code)
    esc(quote
        isempty(𝑑s) && return γ

        𝑑 = if length(𝑑s) ≡ 1 && first(𝑑s) isa AbstractDict
            first(𝑑s)
        else
            out = Dict{String, Vector}()
            for 𝑑 ∈ 𝑑s, (i, j) ∈ (𝑑 isa Pair ? (𝑑,) : bokehrawtype(𝑑))
                out[i] = $code
            end
            out
        end
        isempty(𝑑) && return γ

        𝑑 = DataDict(i => datatypeconvert(get(γ.values, i, nothing), j))
    end)
end

function _𝑑𝑠_check(data::Dict{String, AbstractVector}, others::Vararg{<:AbstractVector})
    isempty(data) && isempty(others) && return
    sz = isempty(data) ? length(first(others)) : length(first(values(data)))
    if any(sz ≢ length(i) for i ∈ values(data)) || any(sz ≢ length(i) for i ∈ others)
        throw(ErrorException("The data source columns must have equal length"))
    end
end

datatypeconvert(::Nothing, y) = datatypeconvert(y)
datatypeconvert(x::AbstractVector, y::Any) = datatypeconvert(eltype(x), y)
datatypeconvert(::Type{T}, y::AbstractVector{T}) where {T} = y
datatypeconvert(x::Type{<:Number}, y::AbstractVector{<:Number}) = convert.(eltype(x), y)
function datatypeconvert(
    x::Type{<:AbstractArray{<:Number}},
    y::AbstractVector{<:AbstractArray{<:Number}}
) where {T<:Number}
    return eltype(x)[convert.(eltype(eltype(x)), i) for i ∈ y]
end

for (T, code) ∈ (
        TimePeriod => :𝑑,
        DateTime   => :(Second(Dates.datetime2unix(𝑑))),
        Date       => :(Day(Dates.date2epochdays(𝑑))),
)
    @eval datatypeconvert(𝑑::$T) = round(Dates.toms($code); digits = 3)
    @eval datatypeconvert(𝑑::Type{$T}) = datatypeconvert.(𝑑)
    @eval datatypeconvert(::Type{Float64}, 𝑑::AbstractArray{$T}) = datatypeconvert.(𝑑)
end

datatypeconvert(y::iHasProps) = y
datatypeconvert(y::AbstractVector{<:iHasProps}) = y
for T ∈ AbstractTypes.NumberElTypeDataDict
    @eval datatypeconvert(y::$T) = y
    @eval datatypeconvert(y::AbstractArray{$T}) = y
    @eval datatypeconvert(y::AbstractVector{<:AbstractArray{$T}}) = y
end

datatypeconvert(y::AbstractArray{Int64}) = Int32.(y)
datatypeconvert(y::AbstractVector{<:AbstractArray{Int64}}) = Array{Int32}[Int32.(i) for i ∈ y]
datatypeconvert(y::AbstractArray{Symbol}) = string.(y)

bokehwrite(::Type{DataSource}, x::DataDict) = copy(x)
function bokehwrite(::Type{DataSource}, x)
    DataDict("$i" => datatypeconvert(j) for (i, j) ∈ x)
end
