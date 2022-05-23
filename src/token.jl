module Tokens
    using JSON
    using Base64
    using SHA
    using CodecZlib
    const _TOKEN_ZLIB_KEY = "__bk__zlib_"
    const WEBSOCKET_PROTOCOL = "Sec-WebSocket-Protocol"

    function encode(vals::Union{String, Vector{UInt8}})
        return rstrip(replace(replace(Base64.base64encode(vals), '-' => '+'), '/' => '_'), '=')
    end

    function decode(vals::AbstractString)
        vals *= '='^((4 - (length(vals) % 4)) % 4) 
        return Base64.base64decode(replace(replace(vals, '+' => '-'), '_' => '/'))
    end

    function sessionid(token::AbstractString)
        ind = findfirst('.', token)
        val = isnothing(ind) ? token : token[1:ind-1]
        return JSON.parse(String(decode(val)))["session_id"]
    end

    function sessionid(;
            len   :: Int    = 44,
            chars :: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
            secretkey :: Vector{UInt8} = UInt8[]
    )
        return signature(join(rand(chars, len), ""), secretkey)
    end

    function payload(token::AbstractString)
        decoded = let ind = findfirst('.', token)
            val = isnothing(ind) ? token : token[1:ind-1]
            JSON.parse(String(decode(val)))
        end

        if haskey(decoded, _TOKEN_ZLIB_KEY)
            decompressed = read(CodecZlib.ZlibDecompressorStream(IOBuffer(decode(decoded[_TOKEN_ZLIB_KEY]))))
            pop!(decoded, _TOKEN_ZLIB_KEY)

            merge!(decoded, JSON.parse(String(decompressed)))
        end
        pop!(decoded, "session_id")
        return decoded
    end

    function token(sessionid; expiration = 300, secretkey::Vector{UInt8} = UInt8[], extra...)
        now     = time()
        payload = (; session_id = sessionid, session_expiry= now + expiration)
        if !isempty(extra)
            msg        = IOBuffer(collect(UInt8, JSON.json(extra)))
            compressed = read(CodecZlib.ZlibCompressorStream(msg; level = 9))
            payload    = merge(payload, (Symbol(_TOKEN_ZLIB_KEY) => encode(compressed),))
        end

        return signature(encode(JSON.json(payload)), secretkey)
    end

    function check(token::AbstractString, secretkey::Vector{UInt8})
        isempty(secretkey) && return true
        # make a sum so as to avoid timing attacks by have a constant-time comparison
        cmp(x) = let ind = findfirst('.', x)
            isnothing(ind) ? 0 : sum(signature(x[1:ind-1]) .== x) == length(x) ? 1 : 0
        end
        return cmp(sessionid(token)) + cmp(token) ==2
    end

    function subprotocol(hdrs::AbstractVector{<:Pair})
        header = filter(==(WEBSOCKET_PROTOCOL)∘first, hdrs)
        outp   = (; subprotocol = nothing, token = nothing)
        if length(header) == 1
            val = last(first(header))
            ind = findfirst(',', val)
            isnothing(ind) || (outp = (; subprotocol = strip(val[1:ind-1]), token = strip(val[ind+1:end])))
        end
        outp
    end

    function signature(msg:: AbstractString, secretkey:: Vector{UInt8}) :: String
        return if isempty(secretkey)
            msg
        else
            "$msg.$(String(encode(hmac_sha256(secretkey, msg))))"
        end
    end
end
using .Tokens
