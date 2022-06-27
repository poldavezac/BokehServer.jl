#!/usr/bin/env -S julia --startup-file=no --history-file=no --project=./deps
using Pkg.Artifacts
using CodecBzip2
using SHA
using Tar

name          = "javascript"
url_base      = "https://anaconda.org/bokeh/bokeh/2.4.2/download/noarch/bokeh-2.4.2-py_0.tar.bz2"

artifact_toml = joinpath(@__DIR__, "..", "Artifacts.toml")
js_hash       = artifact_hash(name, artifact_toml)

if js_hash == nothing || !artifact_exists(js_hash)
    path    = download(url_base)
    js_hash = create_artifact() do artifact_dir
        Tar.extract(IOBuffer(transcode(Bzip2Decompressor, read(path))), artifact_dir)
        cp(joinpath(@__DIR__, "favicon.ico"), joinpath(artifact_dir, "favicon.ico"))
    end
    bind_artifact!(artifact_toml, name, js_hash, download_info = [(url_base,  bytes2hex(open(sha256, path)))])
end
