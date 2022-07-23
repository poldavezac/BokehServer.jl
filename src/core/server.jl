module Server
using HTTP
using HTTP.WebSockets: WebSocket
using ..AbstractTypes
using ..Tokens
using ..Events
using ..Documents

abstract type iRoute end
abstract type iStaticRoute <: iRoute end
abstract type iApplication <: iRoute end

"""
    precompilemethods(::iRoute)

Can be used to precompile methods specific to an application. With
`Application` structures, this allows checking the user code prior to launching
the server.
"""
precompilemethods(::iRoute) = nothing

include("server/config.jl")
include("server/util.jl")
include("server/templates.jl")
include("server/session.jl")
include("server/application.jl")
include("server/server.jl")
include("server/routes.jl")
end
using .Server
