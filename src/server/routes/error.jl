function route(http, exc::Exception)
    @error(
        "Error occured",
        target = http.message.target,
        exception = (exc, Base.catch_backtrace())
    )
    HTTP.set_status(exc isa HTTPError ? exc.status : 403)
    HTTP.set_header("Content-Type" => "text/html")
    HTTP.startwrite(http)
    HTTP.write(http, """
        <!DOCTYPE html>
        <html lang="$(CONFIG.language)">
        <head>
            <meta charset="utf-8">
            <title>Error</title>
        </head>
        <body>
            <H1 style="color:#FF0000">$(sprint(showerror, exc)) </H1>
            <H2>Stacktrace</H2>
            $((let io = IOBuffer()
                   Base.show_backtrace(io, Base.catch_backtrace())
                   ("<p>$(String(i))</p>" for i ∈ eachline(io))
            end)...)
        </body>
        </html>
    """)
end
