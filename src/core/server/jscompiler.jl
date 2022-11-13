module JSCompiler
using JSON
using SHA
using ...BokehServer: CONFIG
using ...AbstractTypes
using ...Model

const AttrDict = Dict{String, Any}

@Base.kwdef struct CompilationError <: iBokehException
    line :: Int
    column :: Int
    message :: String
    text :: String = ""
    annotated :: String = ""
end
CompilationError(text::AbstractString) = 
    CompilationError(; line = -1,  column = -1, message = "", text)

const bokehjs_dir = CONFIG.bokehjsdir
const compilejs_script = joinpath(bokehjs_dir, "js", "compiler.js")
const nodejs_min_version = v"14.0.0"

function _version(run_app:: Function) :: Union{String, Missing}
    try
        version = run_app("--version")
    catch
        return missing
    end
    return strip(version)
end


nodejs_version() = _version(_run_nodejs)
npmjs_version() = _version(_run_npmjs)

nodejs_compile(impl) = nodejs_compile(impl.code, _lang(impl), impl.file)

const _CTRL = r"\\u00[1-9]b\[[()#;?]*(?:[0-9]{1,4}(?:;[0-9]{0,4})*)?[0-9A-ORZcf-nqry=><]" => ""
const _SEP  = string('\\', '"') => '"'

function nodejs_compile(code:: String, lang:: Symbol, file:: Union{Nothing, String}) :: AttrDict
    output = split(
        _run_nodejs(compilejs_script; code, lang, file, bokehjs_dir),
        '\n'
    )
    if !isempty(output) && startswith("LOG", output[1]) 
        ind = first(i for (i, j) ∈ enumerate(output) if !startswith("LOG", j))
        output = @view output[ind:end]
    end
    isempty(output) && throw(CompilationError("No output"))

    info = let buf = IOBuffer()
        for line ∈ output
            line = replace(replace(line, _CTRL), _SEP)
            iszero(buf.size) || write(buf, '\n')
            write(buf, line)
        end
        String(take!(buf))
    end

    if startswith(info, """{"error":""")
        return AttrDict("error" => strip(split(info, """{"error":"""; limit = 2)[end], '}'))
    elseif startswith(info, """{"code":""")
        code, deps = split(info[10:end], ""","deps":"""; limit = 2)
        return AttrDict("code" => code, "deps" => JSON.parse(strip(strip(deps), '}')))
    else
        obj = JSON.parse(info)
        (obj isa Dict) && return obj
        throw(CompilationError(obj))
    end
end

abstract type Implementation end
abstract type Inline <: Implementation end

for cls ∈ (:JavaScript, :TypeScript, :Less)
    @eval struct $cls <: Inline
        "The source code for the implementation"
        code:: String

        "A file path to a file containing the source text (default: None)"
        file:: Union{String, Nothing} = nothing

        $cls(code::String, file::Union{String, Nothing} = nothing) = new(code, file)
    end

    @eval _lang(::$cls) = $(Meta.quot(Symbol(lowercase("$cls"))))
end

struct FromFile <: Implementation
    "The source code for the implementation"
    code:: String

    "A file path to a file containing the source text (default: None)"
    file:: Union{String, Nothing}

    FromFile(path::String) = new(read(path, String), path)
end

function _lang(self::FromFile)
    if !isnothing(self.file)
        endswith(self.file, ".ts") && return :typescript
        endswith(self.file, ".js") && return :javascript
        if any(endswith(self.file, i) for i in (".css", ".less"))
            return :less
        end
    end
    throw(BokehException("unknown file type $(self.file)"))
end

#: recognized extensions that can be compiled
const EXTS = (".ts", ".js", ".css", ".less")

struct CustomModel
    cls::Type{<:Model.iHasProps}
end

_classname(self::CustomModel) = "$(nameof(self.cls))"

function _qualifiedname(self::CustomModel)
    mdl = string(parentmodule(self.cls))
    if startswith(mdl, "Main.")
        mdl = mdl[6:end]
    end
    return "$mdl.$(_classname(self))"
end

function Implementation(self::CustomModel)
    impl = Model.implementation(self.cls)
    if impl isa String
        if !occursin("\n", impl) && any(endswith(impl, i) for i ∈ EXTS)
           return FromFile(impl)
        end

        impl = TypeScript(impl)
    end

    if impl isa Inline && isnothing(impl.file)
        file = "$(Model.structpath(self.cls)):$(_classname(self)).ts"
        return typeof(impl)(impl.code, file)
    end
    return impl
end


_jsmodule(self::CustomModel) = "custom/$(replace(_qualifiedname(self), '.' => '_'))"

const _bundle_cache = Dict{String, String}()

"""Create a bundle of selected `models`. """
function bundle_models(models = Model.MODEL_TYPES)
    custom_models = let vals = Dict{String, CustomModel}()
        for cls ∈ models
            impl = Model.implementation(cls)
            model = CustomModel(cls)
            isnothing(impl) || push!(vals, _qualifiedname(model) => model)
        end
        vals
    end
    isempty(custom_models) && return nothing

    key = let model_names = sort(collect(Set([
            _qualifiedname(model) for model ∈ values(custom_models)
        ])))
        encoded_names = join(sort!(model_names), ',')
        bytes2hex(sha256(encoded_names))
    end
    return get!(_bundle_cache, key) do
        _bundle_models(custom_models)
    end
end

module Templates
    const _CRLF_CR_2_LF = r"\\r\\n|\\r|\\n" => '\n'

    render_eol(txt::String) = replace(txt, _CRLF_CR_2_LF)

    function render_style(css)
        return """(function() {
          const head = document.getElementsByTagName('head')[0];
          const style = document.createElement('style');
          style.type = 'text/css';
          const css = $(JSON.json(css));
          if (style.styleSheet) {
            style.styleSheet.cssText = css;
          } else {
            style.appendChild(document.createTextNode(css));
          }
          head.appendChild(style);
        }());"""
    end

    _exports(vals) = join((""""$name": require("$mdl").$name""" for (name, mdl) in vals), ",\n")
    _modules(vals) = join(
        (
            let source = code
                for (name, ref) in pairs(deps), j ∈ ('"', '\'')
                    source = replace(source, "require($j$name$j)" => "require($j$ref$j)")
                end
                """"$mdl": function(require, module, exports) {\n$source\n}"""
            end
            for (mdl, code, deps) in vals
        ),
        ",\n"
    )

    function _plugins(exports, modules)
        return """(function outer(modules, entry) {
              if (Bokeh != null) {
                return Bokeh.register_plugin(modules, entry);
              } else {
                throw new Error("Cannot find Bokeh. You have to load it prior to loading plugins.");
              }
            })({
              "custom/main": function(require, module, exports) {
                const models = {
                  $exports
                };
                require("base").register_models(models);
                module.exports = models;
              },
              $modules
            }, "custom/main");"""
    end

    function render(exportlist, modulelist)
        contents = _plugins(
            _exports(exportlist),
            _modules(modulelist)
        )
        return """(function(root, factory) {
            factory(root["Bokeh"]);
        })(this, function(Bokeh) {
          let define;
          return $contents;
        });"""
    end
end
using .Templates

function _detect_nodejs() :: String
    for nodejs_path ∈ (isempty(CONFIG.nodejs) ? ("nodejs", "node") : (CONFIG.nodejs,))
        version = try
            read(open(`$nodejs_path --version`), String)
        catch exc
            if exc isa Base.IOError
                continue
            else
                rethrow()
            end
        end

        vals = match(r"^.*[ v](\d+\.\d+\.\d+).*$", version)
        isnothing(vals) && continue
        if VersionNumber(vals.captures[begin]) >= nodejs_min_version
            return nodejs_path
        end
    end

    # if we've reached here, no valid version was found
    throw(ErrorException(
        "node.js $nodejs_min_version or higher is needed to allow compilation of custom models "
        + "('conda install nodejs' or follow https://nodejs.org/en/download/)"
    ))
end

const _nodejs = Ref("")
const _npmjs = Ref("")

function _nodejs_path() :: String
    isempty(_nodejs[]) && (_nodejs[] = _detect_nodejs())
    return _nodejs[]
end

function _npmjs_path() :: String
    if isempty(_npmjs[])
        _npmjs[] = joinpath(dirname(_nodejs_path()), "npm")
        (Base.Sys.iswindows()) && (_npmjs[] += ".cmd")
    end
    return _npmjs[]
end

for tpe ∈ (:nodejs, :npm)
    @eval function $(Symbol("_run_$tpe"))(argv...; input...) :: AbstractString
        app = $(Symbol("_$(tpe)_path"))()
        cmd = `$app $argv`
        proc = open(cmd, "w+")
        if !isempty(input)
            process_running(proc) || throw(BokehException("Could not run $cmd"))
            write(proc, JSON.json(input))
        end
        close(proc.in)
        wait(proc)

        (proc.exitcode != 0) && throw(BokehException("Failed `$cmd` with $(proc.exitcode)"))
        return Templates.render_eol(read(proc, String))
    end
end

function _compile_model(model::CustomModel) :: Pair{CustomModel, AttrDict}
    compiled = nodejs_compile(Implementation(model))
    "error" ∈ keys(compiled) && throw(BokehException(compiled["error"]))
    return model => compiled
end

"""
    _compile_models(custom_models::Dict{String, CustomModel}) :: Dict{String, AttrDict}

Returns the compiled implementation of supplied `models`.
"""
function _compile_models(custom_models::Dict{String, CustomModel}) :: Vector{Pair{CustomModel, AttrDict}}
    ordered_models = sort!(collect(values(custom_models)), by = _qualifiedname)

    deps = let arr = String[]
        for mdl in ordered_models
            cur = Model.dependencies(mdl.cls)
            isnothing(cur) || isempty(cur) || append!(arr, cur)
        end
        arr
    end

    if !isempty(deps)
        deps = sort!(deps, by=first)
        _run_npmjs("install", "--no-progress", (name + "@" + version for (name, version) in deps)...)
    end
    return _compile_model.(ordered_models)
end

"""
    _bundle_models(custom_models:: Dict{String, CustomModel}) :: String

Create a JavaScript bundle with selected `models`.
"""
function _bundle_models(custom_models:: Dict{String, CustomModel}) :: String
    exports = Any[]
    modules = Any[]

    known_modules = let set = Set{String}()
        bokeh = JSON.parse(read(joinpath(CONFIG.bokehjsdir, "js", "bokeh.json"), String))
        for artifact ∈ bokeh["artifacts"]
            canonical = get(artifact["module"], "canonical", nothing)
            isnothing(canonical) || push!(set, canonical)
        end
        for model ∈ values(custom_models)
            push!(set, _jsmodule(model))
        end
        set
    end

    extra_modules = Dict{String, Any}()

    function resolve_modules(to_resolve, root:: String) :: Dict{String, String}
        resolved = Dict{String, String}()
        for mdl ∈ to_resolve
            (mdl ∈ known_modules) && continue

            if any(startswith(mdl, i) for i ∈ ("./", "../"))

                path :: String = let mkpath(mdl, ext) = abspath(joinpath(root, mdl) * ext)
                    path = ""
                    if any(endswith(mdl, i) for i ∈ EXTS)
                        tmp = mkpath(mdl, "")
                        isfile(tmp) && (path = tmp)
                    else
                        for ext in EXTS
                            tmp = mkpath(mdl, ext)
                            if isfile(tmp)
                                path = tmp
                                break
                            end
                        end
                    end
                    path
                end
                isempty(path) && throw(CompilerException("no such mdl: {mdl}"))

                impl = FromFile(path)
                compiled = nodejs_compile(impl)

                if _lang(impl) == :less
                    code = Templates.render_style(compiled.code)
                    deps = String[]
                else
                    code = compiled["code"]
                    deps = compiled["deps"]
                end

                resolved[mdl] = sig = bytes2hex(sha256(code))
                if sig ∉ keys(extra_modules)
                    extra_modules[sig] = true
                    push!(modules, (sig, code, resolve_modules(deps, dirname(path))))
                end
            else
                index = joinpath(mdl, "index")
                (index ∉ keys(known_modules)) && throw(BokehException("no such mdl: $mdl"))
            end
        end
        return resolved
    end

    for (model, compiled) ∈ _compile_models(custom_models)
        deps_map = resolve_modules(compiled["deps"], Model.structpath(model.cls))

        push!(exports, (_classname(model), _jsmodule(model)))
        push!(modules, (_jsmodule(model), compiled["code"], deps_map))
    end

    # sort everything by module name
    sort!(exports, by = (x)-> x[2])
    sort!(modules, by = first)

    return Templates.render(exports, modules)
end
end
