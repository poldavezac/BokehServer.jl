module CodeCreator
module BokehServer
# a very simplified BokehServer for parsing bokeh
include(joinpath((@__DIR__), "..", "..", "src", "core.jl"))
end

using .BokehServer
using PythonCall

modelsmap()  = pyimport("bokeh.models" => "Model").model_class_reverse_map
model(name)  = name == "FigureOptions" ? pyimport("bokeh.plotting._figure" => name) : modelsmap()["$name"]
modelnames() = (
    pyconvert(String, i)
    for (i, j) ∈ modelsmap().items()
    if (
        occursin(".models.", pyconvert(String, j.__module__))
        && (
            PythonCall.pyisnone(j.__doc__)
            || !occursin("This is an abstract base class", pyconvert(String, j.__doc__))
        )
    )
)

include("defaults.jl")
include("properties.jl")
include("hierarchy.jl")
include("dependencies.jl")

filename(name::String) = lowercase(String(structname(name)))

function __init__()
    if haskey(ENV, "BOKEHSERVER_PYTHONPATH")
        insert!(pyconvert(PyList{String}, pyimport("sys").path), 1, ENV["BOKEHSERVER_PYTHONPATH"])
    end
    pyimport("bokeh").__path__
    pyimport("bokeh.models").__path__
end

const _ABSTRACT = pyconvert(String, pyimport("bokeh.core.has_props")._ABSTRACT_ADMONITION)

function isvirtual(name::String)
    occursin("Abstract", name) && return true
    doc = model(name).__doc__
    pyisinstance(doc, Py(nothing).__class__) && return false
    return occursin(_ABSTRACT, pyconvert(String, doc))
end

function parentclasses()
    virtuals = Pair{Symbol, Symbol}[]
    direct = Dict{String, Symbol}()
    done   = Set{Symbol}()
    for (name, opts) ∈ sort!(collect(hierarchy()); by = string∘first)
        @assert length(opts) > 1
        for i ∈ (length(opts)-1):-1:1
            if opts[i] ∉ done
                push!(virtuals, opts[i] => opts[i+1])
                push!(done, opts[i])
            end
        end
        isvirtual(name) || (direct[name] = opts[1])
    end

    return (; virtuals, direct)
end

function abstracttypescode(io::IO; knownvirtuals = (), knownunions = ())
    virtuals, direct = parentclasses()
    for (left, right) ∈ virtuals
        if (left => right) ∉ knownvirtuals
            println(io, "abstract type $left <: $right end")
        end
    end

    for (name, opts) ∈ sort!(collect(unions()); by = string∘first)
        if name ∉ knownunions
            print(io, "const ", name, " = Union{")
            vals = sort!(collect(opts))
            for i ∈ 1:length(vals)-1
                print(io, 'i', vals[i], ", ")
            end
            println(io, 'i', vals[end], '}')
        end
    end
    return direct
end

doccode(::IO, ::Nothing, ::Int) = nothing
function doccode(io::IO, doc::String, indent::Int)
    println(io, " "^indent, "\"\"\"")
    for line ∈ split(strip(props[:__doc__]), '\n')
        println(io, " "^indent, strip(line))
    end
    println(io, " "^indent, "\"\"\"")
    nothing
end

const _EXT_PATT = (
    r"BokehServer\.Models\." => "BokehServer.Models.i",
    r"CodeCreator\." => "",
)
const _BM_PATT  = (
    r"BokehServer\.Models\." => "i",
    r"(CodeCreator\.)*?BokehServer\." => "",
    r"CodeCreator\." => ""
)

function structcode_field(io::IO, name, info, adddoc; iscustom :: Bool = true)
    (name ≡ :__doc__) && return

    field = "    $name :: $(info.type)"
    if !isnothing(info.default)
        dflt   = something(info.default)
        field *= " = $(dflt isa Expr ? dflt : dflt ≡ :__required__ ? "required" : repr(dflt))"
    end

    for patt ∈ (iscustom ? _EXT_PATT : _BM_PATT)
        field = replace(field, patt)
    end

    println(io)
    (adddoc ∈ (:all,)) && doccode(io, info.doc, 4)
    println(io, field)
end

function structcode_glyphargs(io::IO, name::String)
    obj = model(name)
    if pyhasattr(obj, "_args") && length(obj._args) > 0
        println(io, "glyphargs(::Type{$(structname(name))}) = $(tuple(_fieldname.(obj._args)...))")
    end
end

function structcode(
        io::IO,
        name::String,
        parent;
        realname = structname(name),
        adddoc :: Symbol = :none,
        iscustom :: Bool = false
)
    props = parseproperties(name)

    println(io)
    (adddoc ∈ (:all, :struct)) && doccode(io, props[:__doc__], 0)

    mac = parent ≡ :iHasProps ? :wrap : :model
    if iscustom
        println(io, "@BokehServer.$mac mutable struct $realname <: BokehServer.Models.$parent")
    else
        println(io, "@$mac mutable struct $realname <: $parent")
    end
    for (i, j) ∈ sort!(collect(props); by = string∘first)
        structcode_field(io, i, j, adddoc; iscustom)
    end
        
    println(io, "end")
    iscustom || println(io, "export $realname")
    structcode_glyphargs(io, name)
end

function createmainfile(io::IO, deplist)
    println(io, "module Models")
    println(io, "using Dates")
    println(io, "using ..AbstractTypes")
    println(io, "using ..BokehServer")
    println(io, "using ..Model")
    println(io, "include(\"models/modeltypes.jl\")")
    println(io, "include(\"models/uievents.jl\")")
    for name ∈ sort!(collect(keys(deplist)))
        println(io, "include(\"models/$(filename(name)).jl\")")
    end
    println(io, "include(\"models/figureoptions.jl\")")
    println(io, "include(\"models/specifics.jl\")")
    println(io, "end")
    println(io, "using .Models")
end

function createcode(; adddoc ::Symbol = :none)
    deplist = Dict(
        i => dependencies(model(i))
        for i ∈ modelnames()
        if !isvirtual(i)
    )
    file(f, x...) = open(joinpath((@__DIR__), "..", "..", "src", x...), "w") do io
        println(io, "#- file generated by BokehServer's '$(@__MODULE__)': edit at your own risk! -#")
        f(io)
    end

    foreach(
        Base.Filesystem.rm,
        filter!(
            !endswith(Regex(joinpath("models", "(uievents|specifics)\\.jl"))),
            readdir(joinpath((@__DIR__), "..", "..", "src", "models"); join = true)
        )
    )

    cls = file(abstracttypescode, "models/modeltypes.jl")
    file(Base.Fix2(createmainfile, deplist), "models.jl")
    for name ∈ sort!(collect(keys(deplist)))
        @info "writing $(filename(name)).jl"
        file("models", "$(filename(name)).jl") do io
            structcode(io, name, cls[name]; adddoc)
        end
    end
    file("models", "figureoptions.jl") do io
        structcode(io, "FigureOptions", :iHasProps; adddoc)
    end
end

function customcode(io::IO, customs::Vararg{String}; adddoc::Symbol = :none)
    # find known models
    known = Set(modelnames())
    knownvirtuals = Set(parentclasses()[1])
    knownunions = Set(collect(keys(unions())))

    # now import new files
    foreach(pyimport, customs)

    deplist = Dict(
        i => dependencies(model(i))
        for i ∈ modelnames()
        if i ∉ known && !isvirtual(i)
    )
    cls = abstracttypescode(io; knownvirtuals, knownunions)
    for name ∈ sort!(collect(keys(deplist)))
        structcode(io, name, cls[name]; adddoc)
    end
end

function template(io::IO, customs::Vararg{String}; adddoc::Symbol = :none)
    # find known models
    deplist = Dict(
        i => dependencies(model(i))
        for i ∈ customs
    )
    cls = parentclasses()[end]
    for name ∈ sort!(collect(keys(deplist)))
        structcode(
            io, name, get(cls, name, Symbol('i', name));
            realname = "Custom$(structname(name))",
            adddoc,
            iscustom = true
        )
    end
end
end
