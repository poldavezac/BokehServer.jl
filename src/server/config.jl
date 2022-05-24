@Base.kwdef struct Configuration
    host           :: String        = "127.0.0.1"
    port           :: Int           = 5006
    clientloglevel :: Symbol        = :info
    language       :: Symbol        = :en
    staticpath     :: String        = joinpath(pwd(), "static")
    throwonerror   :: Bool          = false
    secretkey      :: Vector{UInt8} = collect(UInt8, get(ENV, "BOKEH_SECRETKEY", ""))
    wstimeout      :: Float64       = 0.1
    wssleepperiod  :: Float64       = 0.01
end

const CONFIG = Configuration(; eval(Meta.parse(get(ENV, "BOKEH_CONFIG", "()")))...)
