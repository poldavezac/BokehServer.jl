module Server
using HTTP
using ..AbstractTypes

include("server/config.jl")
include("server/util.jl")
include("server/templates.jl")
include("server/token.jl")
include("server/session.jl")
include("server/application.jl")
include("server/handle.jl")
include("server/routes/autoload.jl")
include("server/routes/document.jl")
include("server/routes/metadata.jl")
include("server/routes/ws.jl")
end
using .Server
