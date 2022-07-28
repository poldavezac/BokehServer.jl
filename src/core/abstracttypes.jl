module AbstractTypes
abstract type iHasProps end
abstract type iModel <: iHasProps end
abstract type iDocument end
abstract type iTheme end
abstract type iProperty end
abstract type iBokehException <: Exception end
struct BokehException <: iBokehException
    msg::String
end

"""
The BokehServer protocol only allows limited element types in a DataDict.
Other types such as dates are automatically converted.
"""
const NumberElTypeDataDict = (
    Int8, Int16, Int32, UInt8, UInt16, UInt32, Float32, Float64
)
const ElTypeDataDict = (NumberElTypeDataDict..., AbstractString)
const DataDict = Dict{
    String, 
    Union{
        (AbstractVector{<:I} for I ∈ ElTypeDataDict)...,
        (AbstractVector{<:AbstractArray{I}} for I ∈ ElTypeDataDict)...,
        AbstractVector{<:iHasProps},
    }
}

bokehid(μ::Union{iModel, iDocument}) = getfield(μ, :id)

const _ID  = collect(1:Threads.nthreads())
const _INC = 10^Int(ceil(log10(Threads.nthreads()+1)))

"""
    newid() :: Int64

Provide a unique number in a thread-safe way
"""
newid() :: Int64 = _ID[Threads.threadid()] += _INC

export iHasProps, iModel, iDocument, iTheme, iProperty, bokehid, DataDict
export BokehException, iBokehException, newid
end
using .AbstractTypes
