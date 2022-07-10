using Dates

struct DataDictContainer <: iContainer{DataDict}
    parent :: WeakRef
    attr   :: Symbol
    values :: DataDict
end

Base.show(io::IO, ::Type{DataDict}) = print(io, "BokehJL.Model.DataDict")

Base.setindex!(γ::DataDictContainer, 𝑣, 𝑘) = (update!(γ, 𝑘 => 𝑣); 𝑣)
Base.size(γ::DataDictContainer) = isempty(γ.values) ? (0, 0) : (length(first(values(γ.values))), length(γ.values))
Base.size(γ::DataDictContainer, i :: Int) = isempty(γ.values) ? 0 : i ≡ 1 ? length(first(values(γ.values))) : length(γ.values)

bokehread(𝑇::Type{DataDict}, µ::iHasProps, α::Symbol, ν::DataDict) = DataDictContainer(WeakRef(µ), α, ν)

macro _𝑑𝑠_trigger(T, args...)
    esc(quote
        let parent = γ.parent.value
            if (dotrigger && !isnothing(parent) && (getfield(parent, γ.attr) ≡ γ.values))
                BokehJL.Events.trigger(BokehJL.Events.$T(parent, γ.attr, $(args...)))
            end
        end
    end)
end

macro _𝑑𝑠_merge_args(code)
    esc(quote
        isempty(𝑑s) && return γ

        𝑑tmp = if length(𝑑s) ≡ 1 && first(𝑑s) isa AbstractDict
            first(𝑑s)
        else
            out = Dict{String, Vector}()
            for 𝑑 ∈ 𝑑s, (i, j) ∈ (𝑑 isa Pair ? (𝑑,) : bokehunwrap(𝑑))
                out[i] = $code
            end
            out
        end
        isempty(𝑑tmp) && return γ

        𝑑 = DataDict(
            i => let arr = get(γ.values, i, nothing)
                isnothing(arr) ? datadictarray(j) : datadictarray(eltype(arr), j)
            end
            for (i,j) ∈ 𝑑tmp
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

"""
    datadictelement(::Type{T}, 𝑑) where {T}
    datadictelement(::Type{T}, 𝑑::AbstractArray) where {T}

Convert a `DataDict` array *element* to the correct type `T` or `<:AbstractArray{T}`
"""
@inline datadictelement(::Type{String},  𝑑::Color) = color(𝑑)
@inline datadictelement(::Type{Float64}, 𝑑::Union{Date, DateTime, Period, Time}) =  bokehconvert(Float64, 𝑑)
@inline datadictelement(::Type{T}, y::Union{T, AbstractArray{T}}) where {T} = y
@inline datadictelement(T::Type, y::Number) = convert(T, y)
@inline datadictelement(T::Type, y::AbstractArray) = datadictelement.(T, y)

"""
    datadictarray(::Type{T}, 𝑑) where {T}

Convert a `DataDict` *array*  to the correct type `Vector{T}`
"""
@inline datadictarray(T::Type, y::AbstractVector)                  = datadictelement.(T, y)
@inline datadictarray(T::Type, y::AbstractVector{<:AbstractArray}) = [datadictelement.(T, i) for i ∈ y]
@inline datadictarray(::Type{T}, y::Union{AbstractVector{T}, AbstractVector{<:AbstractArray{T}}}) where {T} = y

"""
    datadictarray(::Type{ColorSpec},   y::Union{AbstractRange, AbstractArray})
    datadictarray(::Type{NumberSpec},  y::Union{AbstractRange, AbstractArray})

Convert a `DataDict` *array*  to the correct type `Vector{T}`
"""
@inline datadictarray(::Type{ColorSpec},  y::AbstractVector)        = colorhex.(y)
@inline datadictarray(::Type{NumberSpec}, y::AbstractVector{Int64}) = Int32.(y)
@inline datadictarray(::Type{NumberSpec}, y::AbstractVector)        = y
@inline datadictarray(::Type{NumberSpec}, y::AbstractRange{Int64})  = Int32.(y)
@inline datadictarray(::Type{NumberSpec}, y::AbstractRange)         = collect(y)

for (𝑇1, 𝑇2) ∈ (Union{DateTime, Date, Period, Time} => Float64, Union{Int64} => Int32)
    @eval @inline datadictarray(y::AbstractVector{<:Union{$𝑇1, AbstractArray{<:$𝑇1}}}) = datadictarray($𝑇2, y)
end
@inline datadictarray(y::AbstractVector{<:Union{T, AbstractArray{<:T}}}) where {T <: Union{iHasProps, AbstractTypes.ElTypeDataDict...}} = y

bokehstoragetype(::Type{DataDict}) = DataDict
bokehconvert(::Type{DataDict}, x::DataDict) = copy(x)

for cls ∈ (
        AbstractDict{<:AbstractString},
        AbstractVector{<:Pair{<:AbstractString}},
        DataDictContainer
)
    @eval bokehconvert(::Type{DataDict}, x::$cls) = DataDict("$i" => datadictarray(j) for (i, j) ∈ x)
end

bokehchildren(x::DataDict) = Iterators.flatten(Iterators.filter(Base.Fix2(<:, iHasProps) ∘ eltype, values(x)))
