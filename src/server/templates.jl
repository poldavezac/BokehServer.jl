module Templates
using JSON

function scripttag(
        code :: String;
        type :: String = "text/javascript",
        id   :: Union{String, Nothing} = "$(UUIDs.uuid4())"
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
        absolute_url = ""
)
    tryrun("""
        const docs_json = $docs_json;
        const render_items = $(JSON.json(render_items));
        root.Bokeh.embed.embed_items(docs_json, render_items
            $(join(", $i" for i ∈ (app_path, absolute_url) if !isempty(i))));""")
end

safely(code::String) = """Bokeh.safely(function() { $code; });"""

function onload(code::String)
    return """(function() {
        const fn = function() { $code; };
        if (document.readyState != "loading") fn();
        else document.addEventListener("DOMContentLoaded", fn);
    })();"""
end

embed(roots::AbstractDict{<:AbstractString, <:AbstractString}) = join(embed.(roots), "\n    ")
embed(pair::Pair{<:AbstractString, <:AbstractString}) = embed(pair...)
function embed(rootid::String, elementid::String)
    if isempty(rootid)
        return """<div class="bk-root" id="$elementid"></div>"""
    end
    return """<div class="bk-root" id="$elementid" data-root-id="$rootid"></div>"""
end

end
