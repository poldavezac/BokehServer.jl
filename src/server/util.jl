using HTTP
using UUIDs

struct HTTPError <: Exception
    status :: Int
    reason :: String
end

httperror(reason, status = 403) = throw(HTTPError(status, reason))

function getparams(req::HTTP.Request)
    merge(HTTP.queryparams(req), bodyparams(req))
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
        address    :: String = "http://$(Config.HOST):$(Config.PORT)",
        addversion :: Bool   = false
)
    version = addversion ? "" : ""  # TODO: extract the hex from the files and add a `?v=...`
    root    = "$address/static/js/bokeh"
    return (;
        js_files  = [
            "$root-$suffix.min.js$version"
            for suffix ∈ (Symbol(""), :gl, :widgets, :tables, :mathjax)
        ],
        js_raw    =  ["Bokeh.set_log_level("$(Config.LOG)");"],
        css_files = [],
        css_raw   = [],
        hashes    = Dict{String, String}()
    )
end

function renderdict(roots::Vararg{iModel})
    return Dict{String, String}(
        bokehid(r) => string(UUIDs.uuid4())
        for r ∈ iterroots(session.document)
    )
end
