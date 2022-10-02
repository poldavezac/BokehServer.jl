using ..Protocol
using ..Model
using .JSCompiler: bundle_models

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

@inline function _👻web_isfile(val::AbstractString)
    return any(endswith(val, i) for i ∈ (".css", ".js")) || isfile(val)
end

function _👻web_files(fcn::Function, out = String[], mdls = Model.MODEL_TYPES)
    for mdl ∈ mdls
        val = fcn(mdl)
        if val isa AbstractString
            _👻web_isfile(val) && push!(out, val)
        elseif !isnothing(val)
            append!(out, val)
        end
    end
    return out
end

function _👻web_raw(fcn::Function, out = String[], mdls = Model.MODEL_TYPES)
    for mdl ∈ mdls
        val = fcn(mdl)
        (val isa AbstractString && !_👻web_isfile(val)) && push!(out, val)
    end
    return out
end

function staticbundle(
        address    :: String = "http://$(bokehconfig(:host)):$(bokehconfig(:port))";
        addversion :: Bool   = false,
        root       :: String = "static/js",
        clientlog  :: Symbol = bokehconfig(:clientloglevel)
)
    version = addversion ? "-$(Protocol.PROTOCOL_VERSION)" : ""  # TODO: extract the hex from the files and add a `?v=...`
    minv    = bokehconfig(:minified) ? ".min" : ""
    prefix  = isempty(root ) ? "$address/bokeh" : "$address/$root/bokeh"
    suffix  = "$version$minv.js"
    raw     = String["""Bokeh.set_log_level("$clientlog");"""]
    mdls    = bundle_models()
    isnothing(mdls) || push!(raw, mdls)
    return (;
        js_files  = _👻web_files(
            Model.javascript,
            String[string(prefix, i, suffix) for i ∈ ("", "-gl", "-widgets", "-tables", "-mathjax")],
        ),
        js_raw  = _👻web_raw(Model.javascript, raw),
        css_files = _👻web_files(Model.css),
        css_raw   = _👻web_raw(Model.css),
        hashes    = Dict{String, String}()
    )
end
