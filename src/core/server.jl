module Server
using HTTP
using HTTP.WebSockets: WebSocket
using ..AbstractTypes
using ..Tokens
using ..Events
using ..Documents
abstract type iRoute end
abstract type iApplication <: iRoute end

include("server/config.jl")
include("server/util.jl")
include("server/templates.jl")
include("server/session.jl")
include("server/application.jl")
include("server/server.jl")
include("server/routes.jl")
end
using .Server
