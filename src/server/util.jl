using HTTP
using UUIDs

struct HTTPError <: Exception
    status :: Int
    reason :: String
end

httperror(reason, status = 403) = throw(HTTPError(status, reason))

getparams(http::HTTP.Stream) = getparams(http.message)
getparams(req::HTTP.Request) = merge(HTTP.queryparams(HTTP.uri(req)), bodyparams(req))

function getparam(req::HTTP.Request, key::String, default::Any = nothing)
    opt = get(HTTP.queryparams(HTTP.uri(req)), key, nothing)
    return isnothing(opt) ? get(bodyparams(req), key, default) : default
end

const _TEXT_HEAD = r"Content-Disposition: form-data; name=\"(.*)\""

function bodyparams(req::HTTP.Request)
    headers = filter(x->x[1] == "Content-Type", req.headers)
    if isempty(headers)
        return Dict{String, String}()
    elseif last(only(headers)) == "application/x-www-form-urlencoded"
        return Dict{String, String}((
            let (name, value) = split(pair, "=")
                name => HTTP.URIs.unescapeuri(value)
            end
            for pair ∈ split(String(HTTP.body(req)), "&")
        )...)
    elseif startswith(last(only(headers)), "multipart/form-data")
        body = IOBuffer(data)

        # First line is the stopping line
        stopping_line = replace(readline(body), '-' => "")

        params = Dict{String, String}()
        while !eof(body)
            line = readline(body)
            m    = match(_TEXT_HEAD, line)
            if !isnothing(m)
                readline(body)

                line  = readline(body)
                value = occursin(stopping_line, line) ? "" : line
                while (!eof(body) && !occursin(stopping_line, line))
                    line = readline(body)

                    if (!occursin(stopping_line, line))
                        value *= "\n$(line)"
                    end
                end

                params[m.captures[1]] = value
            end
        end
        params
    else
        Dict{String, String}()
    end
end

staticbundle(type::Symbol) = staticbundle(Val(type))

function staticbundle(
        ::Val{:server};
        address    :: String = "http://$(CONFIG.host):$(CONFIG.port)",
        addversion :: Bool   = false,
        clientlog  :: Symbol = CONFIG.clientloglevel
)
    version = addversion ? "" : ""  # TODO: extract the hex from the files and add a `?v=...`
    root    = "$address/static/js/bokeh"
    return (;
        js_files  = String[
            "$root$suffix.min.js$version"
            for suffix ∈ ("", "-gl", "-widgets", "-tables", "-mathjax")
        ],
        js_raw    = String["""Bokeh.set_log_level("$clientlog");"""],
        css_files = String[],
        css_raw   = String[],
        hashes    = Dict{String, String}()
    )
end
