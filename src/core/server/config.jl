using Pkg.Artifacts

@Base.kwdef mutable struct Configuration
    html_path      :: String         = "bokeh_plot.html"
    cdn            :: String         = "https://cdn.bokeh.org/bokeh/release"
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
    catchsigint    :: Bool           = true
    throwonerror   :: Bool           = false
    secretkey      :: Vector{UInt8}  = collect(UInt8, get(ENV, "BOKEH_SECRETKEY", ""))
    wstimeout      :: Float64        = 0.1
    wssleepperiod  :: Float64        = 0.01
    minified       :: Bool           = true
    favicon        :: String         = joinpath(@__DIR__, "..", "..", "..", "deps", "favicon.ico")
end

const CONFIG = Configuration(; eval(Meta.parse(get(ENV, "BOKEH_CONFIG", "()")))...)
