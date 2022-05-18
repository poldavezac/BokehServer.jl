@Base.kwdef struct Configuration
    host           :: String = "localhost"
    port           :: Int    = 5006
    clientloglevel :: Symbol = :info
    staticpath     :: String = joinpath(pwd(), "static")
end

CONFIG = Configuration()
