module ExceptionRoute
using HTTP
using ..Server
const _AT = r"\s*@"

function body(excs::Base.ExceptionStack)
    """
        <!DOCTYPE html>
        <html lang="$(Server.CONFIG.language)">
        <head>
            <meta charset="utf-8">
            <title>Error</title>
        </head>
        <body>
            <H1 style="color:crimson">An error occured</H1>
            <dl>
            $((let io = IOBuffer()
                for (i, (exc, bt)) in enumerate(excs)
                    print(io, "    <dt style=\"color:slateblue\">")
                    (i > 1) && print(io, "<em style=\"color:red\">Caused by&nbsp;</em>")
                    showerror(io, exc)
                    println(io, "</dt>")

                    iotmp = IOBuffer()
                    Base.show_backtrace(iotmp, bt)
                    println(io, "        <dd>")
                    for line ∈ eachline(seekstart(iotmp))
                        isempty(strip(line)) || println(
                            io,
                            if isnothing(match(_AT, line))
                                "            <p>$line</p>"
                            else
                                "            <p style=\"text-indent:60px;color:gray\">$line</p>"
                            end
                        )
                    end
                    println(io, "        </dd>")
                end
                String(take!(io))
            end))
            </dl>
        </body>
        </html>"""
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
