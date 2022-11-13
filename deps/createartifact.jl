#!/usr/bin/env -S julia --startup-file=no --history-file=no --project=./deps
using Pkg.Artifacts
using CodecBzip2
using SHA
using Tar

artifact_toml = joinpath(@__DIR__, "..", "Artifacts.toml")

for (name, url_base) ∈ (
    "javascript" => "https://anaconda.org/bokeh/bokeh/3.0.1/download/noarch/bokeh-3.0.1-py_0.tar.bz2",
    #"nodejs" => "https://nodejs.org/dist/v16.17.1/node-v16.17.1-linux-x64.tar.xz"
)
    js_hash       = artifact_hash(name, artifact_toml)
    if js_hash == nothing || !artifact_exists(js_hash)
        path    = download(url_base)
        js_hash = create_artifact() do artifact_dir
            Tar.extract(IOBuffer(transcode(Bzip2Decompressor, read(path))), artifact_dir)
        end
        bind_artifact!(artifact_toml, name, js_hash, download_info = [(url_base,  bytes2hex(open(sha256, path)))])
    end
end
