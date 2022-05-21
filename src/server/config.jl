@Base.kwdef struct Configuration
    host           :: String = "127.0.0.1"
    port           :: Int    = 5006
    clientloglevel :: Symbol = :info
    language       :: Symbol = :en
    staticpath     :: String = joinpath(pwd(), "static")
end

CONFIG = Configuration()
