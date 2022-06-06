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

        𝑑 = DataDict(
            i => let arr = get(γ.values, i, nothing)
                isnothing(arr) ? datatypearray(j) : datatypearray(eltype(arr), j)
            end
            for (i,j) ∈ 𝑑
        )
    end)
end

function _𝑑𝑠_check(data::DataDict, others::Vararg{<:AbstractVector})
    isempty(data) && isempty(others) && return
    sz = isempty(data) ? length(first(others)) : length(first(values(data)))
    if any(sz ≢ length(i) for i ∈ values(data)) || any(sz ≢ length(i) for i ∈ others)
        throw(ErrorException("The data source columns must have equal length"))
    end
end

for (T, code) ∈ (
        TimePeriod => :𝑑,
        DateTime   => :(Second(Dates.datetime2unix(𝑑))),
        Date       => :(Day(Dates.date2epochdays(𝑑))),
)
    @eval @inline datatypeconvert(::Type{Float64}, 𝑑::$T) = datatypeconvert(𝑑)
end
@inline datatypeconvert(::Type{T}, y::Union{T, AbstractArray{T}}) where {T} = y
@inline datatypeconvert(::Type{T}, y::Number) where {T} = convert(T, y)
@inline datatypeconvert(::Type{T}, y::AbstractArray) where {T} = datatypeconvert.(T, y)

@inline datatypearray(::Type{T}, y::AbstractVector) where {T} = datatypeconvert.(T, y)
@inline datatypearray(::Type{T}, y::AbstractVector{<:AbstractArray}) where {T} = [datatypeconvert.(T, i) for i ∈ y]
@inline datatypearray(::Type{T}, y::Union{AbstractVector{T}, AbstractVector{<:AbstractArray{T}}}) where {T} = y

for (𝑇1, 𝑇2) ∈ (Union{DateTime, Date, TimePeriod} => Float64, Union{Int64} => Int32)
    @eval @inline datatypearray(y::AbstractVector{<:Union{$𝑇1, AbstractArray{<:$𝑇1}}}) = datatypearray($𝑇2, y)
end
@inline datatypearray(y::AbstractVector{<:Union{T, AbstractArray{<:T}}}) where {T <: Union{iHasProps, AbstractTypes.ElTypeDataDict...}} = y

bokehwrite(::Type{DataSource}, x::DataDict) = copy(x)
function bokehwrite(::Type{DataSource}, x)
    DataDict("$i" => datatypearray(j) for (i, j) ∈ x)
end
