#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct CumSum <: iCumSum

    field :: String = required

    include_zero :: Bool = false
end
export CumSum
