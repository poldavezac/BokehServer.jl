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
datadictelement(::Type{Color},   @nospecialize(𝑑)) :: String = colorhex(𝑑)
datadictelement(::Type{String},  𝑑::Color) :: String = colorhex(𝑑)
datadictelement(::Type{Float64}, @nospecialize(𝑑::Dates.AbstractTime)) :: Float64 =  bokehconvert(Float64, 𝑑)
datadictelement(::Type{String},  ::Missing) :: String = ""
datadictelement(::Type{Float64}, ::Missing) :: Float64 =  NaN64
datadictelement(::Type{Float32}, ::Missing) :: Float32 =  NaN32
datadictelement(::Type{T}, 𝑑::Union{T, AbstractArray{T}}) where {T} = 𝑑
datadictelement(@nospecialize(T::Type), @nospecialize(𝑑::Number)) = convert(T, 𝑑)
datadictelement(@nospecialize(T::Type), @nospecialize(𝑑::AbstractArray)) = datadictelement.(T, 𝑑)

"""
    datadictarray(::Type{T}, 𝑑) where {T}

Convert a `DataDict` *array*  to the correct type `Vector{T}`
"""
datadictarray(@nospecialize(T::Type), @nospecialize(𝑑::AbstractVector)) = datadictelement.(T, 𝑑)
datadictarray(T::Type, 𝑑::AbstractVector{<:AbstractArray}) = [datadictelement.(T, i) for i ∈ 𝑑]
datadictarray(::Type{T}, 𝑑::Union{AbstractVector{T}, AbstractVector{<:AbstractArray{T}}}) where {T} = 𝑑

"""
    datadictarray(::Type{ColorSpec},  𝑑::AbstractVector)
    datadictarray(::Type{NumberSpec}, 𝑑::AbstractVector)
    datadictarray(::Type{IntSpec},    𝑑::AbstractVector)

Convert a `DataDict` *array*  to the correct type `Vector{T}`
"""
datadictarray(::Type{ColorSpec}, @nospecialize(𝑑::AbstractVector{<:AbstractString})) = 𝑑
datadictarray(::Type{ColorSpec}, @nospecialize(𝑑::AbstractVector)) = colorhex.(𝑑)
function datadictarray(𝑇::Type{<:iSpec}, 𝑑::AbstractVector)
    @nospecialize 𝑇 𝑑
    e𝑇 = bokehstoragetype(speceltype(𝑇))
    return e𝑇 ≡ eltype(𝑑) ? 𝑑 : datadictelement.(e𝑇, 𝑑)
end
datadictarray(𝑇::Type{NullDistanceSpec}, @nospecialize(𝑑::AbstractVector)) = Float64 ≡ eltype(𝑑) ? 𝑑 : Float64.(𝑑)
datadictarray(𝑇::Type{NullStringSpec}, @nospecialize(𝑑::AbstractVector))   = datadictarray(StringSpec, 𝑑)
datadictarray(𝑇::Type{StringSpec}, @nospecialize(𝑑::AbstractVector))       = eltype(𝑑) <: AbstractString ? 𝑑 : string.(𝑑)

for (𝑇1, 𝑇2) ∈ (Dates.AbstractTime => Float64, Int64 => Int32)
    @eval datadictarray(@nospecialize(𝑑::AbstractVector{<:$𝑇1}))                             = datadictarray($𝑇2, 𝑑)
    @eval datadictarray(@nospecialize(𝑑::AbstractVector{<:AbstractArray{<:$𝑇1}}))            = datadictarray($𝑇2, 𝑑)
    @eval datadictarray(@nospecialize(𝑑::AbstractVector{Union{Missing, T}} where {T <: $𝑇1}))= datadictarray(Float64, 𝑑)
end

for (𝑇, 𝐹) ∈ (:Missing => :ismissing, :Nothing => :isnothing)
    @eval function datadictarray(𝑑::AbstractVector{Union{$𝑇, T}}) where {T <: AbstractString}
        nan = T()
        return T[ifelse($𝐹(i), nan, i) for i ∈ 𝑑]
    end

    for (𝑃, 𝑁) ∈ (Float64 => NaN64, Float32 => NaN32)
        @eval function datadictarray(𝑑::AbstractVector{Union{$𝑇, $𝑃}}) :: Vector{$𝑃}
            return $𝑃[ifelse($𝐹(i), $𝑁, i) for i ∈ 𝑑]
        end
    end

    @eval function datadictarray(𝑑::AbstractVector{Union{$𝑇, Int64}}) :: Vector{Float64}
        return Float64[$𝐹(i) ? NaN64 : convert(Float64, i) for i ∈ 𝑑]
    end

    @eval function datadictarray(𝑑::AbstractVector{Union{$𝑇, T}} where {T <: Number}) :: Vector{Float32}
        return Float64[$𝐹(i) ? NaN32 : convert(Float32, i) for i ∈ 𝑑]
    end
end

datadictarray(@nospecialize(𝑑::AbstractVector{<:Union{iHasProps, AbstractTypes.ElTypeDataDict...}})) = 𝑑
datadictarray(@nospecialize(𝑑::AbstractVector{<:AbstractArray{<:Union{iHasProps, AbstractTypes.ElTypeDataDict...}}})) = 𝑑
datadictarray(@nospecialize(𝑑::AbstractRange)) = datadictarray(collect(𝑑))

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
