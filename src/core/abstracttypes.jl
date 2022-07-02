module AbstractTypes
    abstract type iHasProps end
    abstract type iModel <: iHasProps end
    abstract type iDocument end
    abstract type iTheme end
    abstract type iProperty end

    """
    The Bokeh protocol only allows limited element types in a DataDict.
    Other types such as dates are automatically converted.
    """
    const NumberElTypeDataDict = (
        Int8, Int16, Int32, UInt8, UInt16, UInt32, Float32, Float64
    )
    const ElTypeDataDict = (NumberElTypeDataDict..., String)
    const DataDict = Dict{
        String, 
        Union{
            (AbstractVector{I} for I ∈ ElTypeDataDict)...,
            (AbstractVector{<:AbstractArray{I}} for I ∈ ElTypeDataDict)...,
            AbstractVector{<:iHasProps},
        }
    }

    bokehid(μ::Union{iModel, iDocument}) = getfield(μ, :id)

    struct BokehIdMaker
        ids :: Vector{Int}
        BokehIdMaker() = new(collect(1:Threads.nthreads()))
    end

    function (self::BokehIdMaker)() :: Int64
        return (self.ids[Threads.threadid()] += 1000)
    end

    struct BokehSymbolIdMaker
        ids :: BokehIdMaker
        BokehStringIdMaker() = new(BokehIdMaker())
    end

    function (self::BokehSymbolIdMaker)() :: Symbol
        return Symbol(string(self.ids()))
    end

    bokehidmaker(T::Type = Int64) = T ≡ Symbol ? BokehSymbolIdMaker() : BokehIdMaker()

    export iHasProps, iModel, iDocument, iTheme, iProperty, bokehid, bokehidmaker, DataDict
end
using .AbstractTypes
