module Embedding
using ..AbstractTypes
using ..Server

"""
Return HTML components to embed a Bokeh plot. The data for the plot is
stored directly in the returned HTML.
"""
function component(models::Vararg{iModel}; app = nothing)
    roots  = Server.makerootids(app, models...)
    script = let doc = pushdoc(Server.CONFIG.title, models)
        docid = Server.makeid(app)
        Server.Templates.scripttag(Server.Templates.onload(Templates.safely(Templates.docjs(
            string("'{\"", docid, "\":", JSON.json(doc), "}'"),
            (; docid, roots, root_ids = collect(keys(roots)))
        ))))
    end

    return (; script, divs = Templates.embed.(roots))
end
end
using .Embedding
