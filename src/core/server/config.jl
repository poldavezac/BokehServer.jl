using Pkg.Artifacts

@Base.kwdef struct Configuration
    host           :: String         = "127.0.0.1"
    port           :: Int            = 5006
    clientloglevel :: Symbol         = :info
    language       :: Symbol         = :en
    staticroute    :: Symbol         = :static
    staticpaths    :: Vector{String} = [
        joinpath(pwd(), "static"),
        joinpath(artifact"javascript", "site-packages", "bokeh", "server", "static"),
        artifact"javascript"
    ]
    throwonerror   :: Bool           = false
    secretkey      :: Vector{UInt8}  = collect(UInt8, get(ENV, "BOKEH_SECRETKEY", ""))
    wstimeout      :: Float64        = 0.1
    wssleepperiod  :: Float64        = 0.01
    minified       :: Bool           = true
end

const CONFIG = Configuration(; eval(Meta.parse(get(ENV, "BOKEH_CONFIG", "()")))...)
