module Templates
using JSON
using ...AbstractTypes
using ..Server

function scripttag(
        code :: String;
        type :: String = "text/javascript",
        id   :: Union{String, Nothing} = nothing,
)
    if isnothing(id)
        """<script type="$type">$code</script>"""
    else
        """<script type="$type" id="$id">$code</script>"""
    end
end

function tryrun(codetorun)
    return """(function(root) {
        function embed_document(root) { $codetorun; }
        if (root.Bokeh !== undefined) {
            embed_document(root);
        } else {
            let attempts = 0;
            const timer = setInterval(function(root) {
                    if (root.Bokeh !== undefined) {
                        clearInterval(timer);
                        embed_document(root);
                    } else {
                        attempts++;
                        if (attempts > 100) {
                            clearInterval(timer);
                            console.log("Bokeh: ERROR: Unable to run BokehJS code because BokehJS library is missing");
                        }
                    }
                }, 10, root)
        }
    })(window);"""
end

function docjs(
        doc_json,
        render_items::Vararg{NamedTuple}; 
        app_path     = "",
        absolute_url = "",
        _...
)
    args = join(", \"$i\"" for i ∈ (app_path, absolute_url) if !(isnothing(i) || isempty(i)))
    tryrun("""
        const docs_json = $doc_json;
        const render_items = $(JSON.json(render_items));
        root.Bokeh.embed.embed_items(docs_json, render_items$args);"""
    )
end

safely(code::String) = """Bokeh.safely(function() { $code; });"""

function onload(code::String)
    return """(function() {
        const fn = function() { $code; };
        if (document.readyState != "loading") fn();
        else document.addEventListener("DOMContentLoaded", fn);
    })();"""
end

function doconload(
        app           :: Server.iRoute,
        roots         :: Dict{String, String},
        id            :: AbstractString;
        use_for_title :: Bool   = true,
        kwa...
)
    return scripttag(
        onload(safely(docjs(
            "document.getElementById('$id').textContent",
            (; roots, root_ids = collect(keys(roots)), use_for_title, kwa...);
            kwa...
        )));
        id = Server.makeid(app)
    )
end

function docjsscripts(
        app           :: Server.iRoute,
        rootids       :: Dict{String, String};
        id            :: String = Server.makeid(app),
        use_for_title :: Bool   = true,
        data          :: Any    = [],
        kwa...
)
    json = scripttag(JSON.json(data); type = "application/json", id)
    return json * doconload(app, rootids, id; use_for_title, kwa...)
end

embed(rs::AbstractDict{<:AbstractString, <:AbstractString}) = join((embed(r) for r ∈ rs), "\n    ")
embed(pair::Pair{<:AbstractString, <:AbstractString}) = embed(pair...)
function embed(rootid::String, elementid::String)
    if isempty(rootid)
        return """<div class="bk-root" id="$elementid"></div>"""
    end
    return """<div class="bk-root" id="$elementid" data-root-id="$rootid"></div>"""
end

function headers(; kwa...)
    vals = Server.staticbundle(; kwa...).js_files
    return join(("<script type=\"text/javascript\" src=\"$i\"></script>" for i ∈ vals), "\n")
end
end
