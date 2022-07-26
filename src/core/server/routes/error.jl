module ExceptionRoute
using HTTP
using ..Server
const _AT   = r"\s*@"
const _OPTS = let bkpath = abspath(joinpath(@__DIR__, "..", "..", "..", ".."))
    (
        bkpath => "BOKEHJL_DIR",
        replace(bkpath, ENV["HOME"] => "~") => "BOKEHJL_DIR",
        abspath(Base.Sys.STDLIB) => "STDLIB_DIR",
        replace(abspath(Base.Sys.STDLIB), ENV["HOME"] => "~") => "STDLIB_DIR",
        (abspath(i) => "DEPOT_DIR" for i ∈ DEPOT_PATH)...
    )
end

function replacepath(line) :: Tuple{Vararg{AbstractString}}
    m = match(_AT, line)
    isnothing(m) && return ("<p>", line, "</p>")

    for i ∈ _OPTS
        line = replace(line, i)
    end
    return "<p style=\"text-indent:60px;color:gray\">", line, "</p>"
end

function body(excs::Base.ExceptionStack)
    io = IOBuffer()
    println(io, """<!DOCTYPE html>
        <html lang=\"""", Server.CONFIG.language, """\">
        <head>
            <meta charset="utf-8">
            <title>Error</title>
        </head>
        <body>
            <H1 style="color:crimson">An error occured</H1>
            <dl>""")

    for (i, (exc, bt)) in enumerate(excs)
        print(io, "    <dt style=\"color:slateblue\">")
        (i > 1) && print(io, "<em style=\"color:red\">Caused by&nbsp;</em>")
        showerror(io, exc)
        println(io, "</dt>")

        iotmp = IOBuffer()
        Base.show_backtrace(iotmp, bt)
        println(io, "        <dd>")
        for line ∈ eachline(seekstart(iotmp))
            isempty(strip(line)) || println(io, "            ", replacepath(line)...)
        end
        println(io, "        </dd>")
    end

    println(io, """    </dl>
        </body>
        </html>""")
    return String(take!(io))
end
end
using .ExceptionRoute

function route(http, exc::Base.ExceptionStack)
    isempty(exc) || @error(
        "Error occured",
        target = http.message.target,
        exception = (exc[1].exception, exc[1].backtrace)
    )
    HTTP.setstatus(http, exc isa HTTPError ? exc.status : 403)
    HTTP.setheader(http, "Content-Type" => "text/html")
    HTTP.startwrite(http)
    HTTP.write(http, ExceptionRoute.body(exc))
end
