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
@inline datadictelement(::Type{Color},   𝑑) :: String = ismissing(𝑑) || isnothing(𝑑) ? "#00000000" : colorhex(𝑑)
@inline datadictelement(::Type{String},  𝑑::Color) :: String = colorhex(𝑑)
@inline datadictelement(::Type{Float64}, 𝑑::Dates.AbstractTime) :: Float64 =  bokehconvert(Float64, 𝑑)
@inline datadictelement(::Type{String},  ::Missing) :: String = ""
@inline datadictelement(::Type{Float64}, ::Missing) :: Float64 =  NaN64
@inline datadictelement(::Type{Float32}, ::Missing) :: Float32 =  NaN32
@inline datadictelement(::Type{T}, 𝑑::Union{T, AbstractArray{T}}) where {T} = 𝑑
@inline datadictelement(T::Type, 𝑑::Number) = convert(T, 𝑑)
@inline datadictelement(T::Type, 𝑑::AbstractArray) = datadictelement.(T, 𝑑)

"""
    datadictarray(::Type{T}, 𝑑) where {T}

Convert a `DataDict` *array*  to the correct type `Vector{T}`
"""
@inline datadictarray(T::Type, 𝑑::AbstractVector)                  = datadictelement.(T, 𝑑)
@inline datadictarray(T::Type, 𝑑::AbstractVector{<:AbstractArray}) = [datadictelement.(T, i) for i ∈ 𝑑]
@inline datadictarray(::Type{T}, 𝑑::Union{AbstractVector{T}, AbstractVector{<:AbstractArray{T}}}) where {T} = 𝑑

"""
    datadictarray(::Type{ColorSpec},  𝑑::AbstractVector)
    datadictarray(::Type{NumberSpec}, 𝑑::AbstractVector)
    datadictarray(::Type{IntSpec},    𝑑::AbstractVector)

Convert a `DataDict` *array*  to the correct type `Vector{T}`
"""
@inline datadictarray(::Type{ColorSpec},  𝑑::AbstractVector{String})  = 𝑑
@inline datadictarray(::Type{ColorSpec},  𝑑::AbstractVector) = datadictelement.(Color, 𝑑)
@inline function datadictarray(𝑇::Type{<:iSpec},   𝑑::AbstractVector)
    return speceltype(𝑇) ≡ eltype(𝑑) ? 𝑑 : datadictelement.(speceltype(𝑇), 𝑑)
end

for (𝑇1, 𝑇2) ∈ (Dates.AbstractTime => Float64, Int64 => Int32)
    @eval @inline datadictarray(𝑑::AbstractVector{<:$𝑇1})                              = datadictarray($𝑇2, 𝑑)
    @eval @inline datadictarray(𝑑::AbstractVector{<:AbstractArray{<:$𝑇1}})             = datadictarray($𝑇2, 𝑑)
    @eval @inline datadictarray(𝑑::AbstractVector{Union{Missing, T}} where {T <: $𝑇1}) = datadictarray(Float64, 𝑑)
end

function datadictarray(𝑑::AbstractVector{Union{Missing, T}}) where {T <: AbstractString}
    nan = T()
    return T[ifelse(ismissing(i), nan, i) for i ∈ 𝑑]
end

@generated function datadictarray(𝑑::AbstractVector{Union{Missing, T}} where {T <: Real})
    return if eltype(𝑑) ≡ Union{Missing, Float32}
        :(Float32[ifelse(ismissing(i), NaN32, i) for i ∈ 𝑑])
    elseif eltype(𝑑) ≡ Union{Missing, Float64}
        :(Float64[ifelse(ismissing(i), NaN64, i) for i ∈ 𝑑])
    elseif sizeof(eltype(𝑑)) ≤ 4
        :(Float32[ismissing(i) ? NaN32 : convert(Float32, i) for i ∈ 𝑑])
    else
        :(Float64[ismissing(i) ? NaN64 : convert(Float64, i) for i ∈ 𝑑])
    end
end
@inline datadictarray(𝑑::AbstractVector{<:Union{iHasProps, AbstractTypes.ElTypeDataDict...}}) = 𝑑
@inline datadictarray(𝑑::AbstractVector{<:AbstractArray{<:Union{iHasProps, AbstractTypes.ElTypeDataDict...}}}) = 𝑑

bokehstoragetype(::Type{DataDict}) = DataDict
bokehconvert(::Type{DataDict}, x::DataDict) = copy(x)

for cls ∈ (
        AbstractDict{<:AbstractString},
        AbstractVector{<:Pair{<:AbstractString}},
        DataDictContainer
)
    @eval bokehconvert(::Type{DataDict}, x::$cls) = DataDict(("$i" => datadictarray(j) for (i, j) ∈ x)...)
end

bokehchildren(x::DataDict) = Iterators.flatten(Iterators.filter(Base.Fix2(<:, iHasProps) ∘ eltype, values(x)))
