module Tokens
using JSON
using Base64
using SHA
using CodecZlib
const _TOKEN_ZLIB_KEY = "__bk__zlib_"
const WEBSOCKET_PROTOCOL = "Sec-WebSocket-Protocol"

encode(vals::Union{String, Vector{UInt8}}) = rstrip(replace(base64encode(vals), '/' => '_'), '=')

function decode(vals::AbstractString) :: Vector{UInt8}
    vals  = replace(vals, '_' => '/')
    vals *= '='^((4 - (length(vals) % 4)) % 4) 
    return Base64.base64decode(vals)
end

function sessionid(token::AbstractString) :: String
    ind = findfirst('.', token)
    val = isnothing(ind) ? token : token[1:ind-1]
    return JSON.parse(String(decode(val)))["session_id"]
end

function sessionid(;
        len   :: Int    = 44,
        chars :: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
        secretkey :: Vector{UInt8} = UInt8[]
) :: String
    return signature(join(rand(chars, len), ""), secretkey)
end

function payload(token::AbstractString) :: Dict{String, Any}
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

function token(sessionid::String; expiration = 300, secretkey::Vector{UInt8} = UInt8[], extra...) :: String
    now     = time()
    payload = (; session_id = sessionid, session_expiry = now + expiration)
    if !isempty(extra)
        msg        = IOBuffer(collect(UInt8, JSON.json(extra)))
        compressed = read(CodecZlib.ZlibCompressorStream(msg; level = 9))
        payload    = merge(payload, (Symbol(_TOKEN_ZLIB_KEY) => encode(compressed),))
    end

    return signature(encode(JSON.json(payload)), secretkey)
end

function check(token::AbstractString, secretkey::Vector{UInt8}) :: Bool
    isempty(secretkey) && return true
    # make a sum so as to avoid timing attacks by have a constant-time comparison
    cmp(x) = let ind = findfirst('.', x)
        isnothing(ind) ? 0 : sum(signature(x[1:ind-1]) .== x) == length(x) ? 1 : 0
    end
    return cmp(sessionid(token)) + cmp(token) ==2
end

function token(hdrs::AbstractVector{<:Pair}, protocol::String) :: Union{String, Nothing}
    hdr = subprotocol(hdrs, protocol)
    if !isnothing(hdr)
        val = last(hdr) :: SubString
        ind = findfirst(',', val)
        isnothing(ind) || return string(strip(val[ind+1:end]))
    end
    return nothing
end

function subprotocol(hdrs::AbstractVector{<:Pair}, name::String) :: Union{Nothing, Pair}
    header = filter(startswith(name) ∘ last, filter(==(WEBSOCKET_PROTOCOL)∘first, hdrs))
    return (length(header) != 1) ? nothing : first(header)
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
