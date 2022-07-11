#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
using BokehJL
using CodecZlib
using Dates
using Pkg.Artifacts

const DAYS = ["Sun", "Sat", "Fri", "Thu", "Wed", "Tue", "Mon"]
const DATA = let data = Dict("time" => Dates.Time[], "day" => String[]) 
    path = joinpath(artifact"javascript", "site-packages", "bokeh", "sampledata", "_data", "commits.txt.gz")
    fmt  = Dates.DateFormat("e, m u y H:M:S")
    ord  = collect(DAYS[end:-1:1])
    reg  = r" [+-]"
    for line ∈ eachline(IOBuffer(transcode(GzipDecompressor, read(path, String))))
        date = split(line, reg)[1]
        out  = try
            parse(Dates.DateTime, date, fmt)
        catch exc
            rethrow()
        end
            
        push!(data["time"], Dates.Time(out))
        push!(data["day"], ord[Dates.dayofweek(out)])
    end
    data
end

BokehJL.Plotting.serve() do
    p = BokehJL.figure(width=800, height=300, y_range=DAYS, x_axis_type="datetime",
               title="Commits by Time of Day (US/Central) 2012-2016")

    BokehJL.scatter!(p; x="time", y=BokehJL.Transforms.jitter("day", 0.6; range=p.y_range),  source=DATA, alpha=0.3)

    p.xaxis.formatter.days = ["%Hh"]
    p.x_range.range_padding = 0
    p.ygrid.grid_line_color = "#00000000"
    p
end
