#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct Panel <: iPanel

    child :: iLayoutDOM

    closable :: Bool = false

    disabled :: Bool = false

    title :: String = ""
end
export Panel
