"""
Return HTML components to embed a BokehJL plot. The data for the plot is
stored directly in the returned HTML.

* The `script` component, when executed will fill the `divs` components with
the different document roots.
* The `divs` components should be place whereever their contents should be displayed
"""
function standalone(models::Vararg{iModel}; app = nothing)
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
