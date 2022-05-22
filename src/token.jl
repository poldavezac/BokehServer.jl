module Tokens
    using JSON
    using Base64
    using CodecZlib
    const _TOKEN_ZLIB_KEY = "__bk__zlib_"

    function encode(vals::Union{String, Vector{UInt8}})
        return rstrip(replace(replace(Base64.base64encode(vals), '-' => '+'), '/' => '_'), '=')
    end

    function decode(vals::String)
        vals *= 'b'^(4 - (length(vals) % 4))
        return Base64.base64decode(replace(replace(vals, '+' => '-'), '_' => '/'))
    end

    function sessionid(token::String)
        return JSON.parse(decode(split(token, '.')[begin]))["session_id"]
    end

    function sessionid(;
            len   :: Int    = 44,
            chars :: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    )
        return join(rand(chars, len), "")
    end

    function payload(token::String)
        decoded = JSON.parse(decode(split(token, '.')[begin]))
        if _TOKEN_ZLIB_KEY ∈ decoded
            decompressed = Zlib.inflate(decode(decoded[_TOKEN_ZLIB_KEY]))
            pop!(decoded, _TOKEN_ZLIB_KEY)

            merge!(decoded, JSON.parse(decompressed))
        end
        pop!(decoded, "session_id")
        return decoded
    end

    function token(sessionid; expiration = 300, extra...)
        now     = time()
        payload = (; session_id = sessionid, session_expiry= now + expiration)
        if !isempty(extra)
            msg        = IOBuffer(collect(UInt8, JSON.json(extra)))
            compressed = read(CodecZlib.ZlibCompressorStream(msg; level = 9))
            payload    = merge(payload, (; _TOKEN_ZLIB_KEY = encode(compressed)))
        end
        return encode(JSON.json(payload))
    end

    function check(::String)
        return true  # secrets not implemented yet
    end

    function subprotocol(params::Dict{String})
        header = get(params, Tokens.WEBSOCKET_PROTOCOL)
        outp   = (; subprotocol = nothing, token = nothing)
        if !isnothing(header)
            opts = split(header, ',')
            if length(opts) ≡ 2
                outp = (; subprotocol = strip(opts[1]), token = strip(opts[2]))
            end
        end
        outp
    end
end
using .Tokens
