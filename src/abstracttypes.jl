module AbstractTypes
    abstract type iHasProps end
    abstract type iModel        <: iHasProps end
    abstract type iDataSource   <: iModel end
    abstract type iSourcedModel <: iModel end
    abstract type iDocument end
    abstract type iTheme end

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

    export iHasProps, iModel, iDataSource, iSourcedModel, iDocument, iTheme, bokehid, bokehidmaker
end
using .AbstractTypes
