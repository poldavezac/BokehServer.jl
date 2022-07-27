using ..Protocol

struct HTTPError <: Exception
    status :: Int
    reason :: String
end

httperror(reason :: String, status ::Int = 403) = throw(HTTPError(status, reason))

getparams(http::HTTP.Stream) = getparams(http.message)
function getparams(req::HTTP.Request)
    merge(HTTP.queryparams(HTTP.URI(req.target)), bodyparams(req))
end

function getparam(req::HTTP.Request, key::String, default::Any = nothing)
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

function staticbundle(
        address    :: String = "http://$(CONFIG.host):$(CONFIG.port)";
        addversion :: Bool   = false,
        root       :: String = "static/js",
        clientlog  :: Symbol = CONFIG.clientloglevel
)
    version = addversion ? "-$(Protocol.PROTOCOL_VERSION)" : ""  # TODO: extract the hex from the files and add a `?v=...`
    minv    = CONFIG.minified ? ".min" : ""
    prefix  = isempty(root ) ? "$address/bokeh" : "$address/$root/bokeh"
    suffix  = "$version$minv.js"
    return (;
        js_files  = String[string(prefix, i, suffix) for i ∈ ("", "-gl", "-widgets", "-tables", "-mathjax")],
        js_raw    = String["""Bokeh.set_log_level("$clientlog");"""],
        css_files = String[],
        css_raw   = String[],
        hashes    = Dict{String, String}()
    )
end
