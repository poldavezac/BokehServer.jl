module AbstractTypes
    abstract type iHasProps end
    abstract type iModel        <: iHasProps end
    abstract type iDataSource   <: iModel end
    abstract type iSourcedModel <: iModel end
    abstract type iDocument end
    abstract type iTheme end

    bokehid(μ::Union{iModel, iDocument}) = getfield(μ, :id)

    export iHasProps, iModel, iDataSource, iSourcedModel, iDocument, iTheme, bokehid
end
using .AbstractTypes
