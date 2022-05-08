module AutoloadRouter
using HTTP
using ...AbstractTypes
using ..Server
using ..Server.Templates

autoloadroute(::Val{:OPTIONS}, ::iApplication, ::SessionContext) = HTTP.Response(200, [])

function autoloadroute(::Val{:GET}, app::iApplication, session::SessionContext)
    HTTP.Response(
        200,
        [
            "Content-Type"                  => "text/html",
            "Access-Control-Allow-Headers"  => "*",
            "Access-Control-Allow-Methods"  => "PUT, GET, OPTIONS",
            "Access-Control-Allow-Origin"   => "*",
        ];
        body    = autoloadbody(app, session)
        request = session.request
    )
end

function autoloadbody(app::iApplication, session::SessionContext)
    params    = getparams(request)
    elementid = get(params, "bokeh-autoload-element", nothing)
    if isnothing(elementid)
        httperror(400, "No bokeh-autoload-element query parameter")
    end

    app_path     = get(params, "bokeh-app-path", "/")
    absolute_url = get(params, "bokeh-absolute-url", nothing)
    bundle       = if get(params, "resources", "default") == "none"
        staticbundle(Val(:server))
    elseif isnothing(absolute_url)
        staticbundle(Val(:server))
    else
        uri = HTTP.URIs.URI(absolute_url)
        staticbundle(
            Val(:server);
            host = joinpath("$(uri.scheme)://$(uri.host)", urlprefix(app))
        )
    end

    script = Templates.onload(Templates.safely(Templates.docjs(
           "{}", (; session.token, elementid, use_for_title = false);
            app_path, absolute_url
    )))
    return autoloadtemplate(elementid, bundle.bokeh_js, bundle.bokeh_css, [script])
end

"""
Renders JavaScript code for "autoloading".

The code automatically and asynchronously loads BokehJS (if necessary) and
then replaces the AUTOLOAD_TAG ``<script>`` tag that
calls it with the rendered model.
"""
function autoloadtemplate(
        elementid :: String,
        bokeh_js  :: AbstractVector{<:AbstractString},
        bokeh_css :: AbstractVector{<:AbstractString},
        js_raw    :: AbstractVector{<:AbstractString} = String[]
        force     :: Bool = false
)
    return """(function(root) {
        function now() { return new Date(); }
        const force = $force;

        if (typeof root._bokeh_onload_callbacks === "undefined" || force === true) {
            root._bokeh_onload_callbacks = [];
            root._bokeh_is_loading = undefined;
        }

        const element = document.getElementById($elementid);
        if (element == null) {
            console.warn("Bokeh: autoload.js configured with elementid '$elementid' but no matching script tag was found.")
        }

        function run_callbacks() {
            try {
                root._bokeh_onload_callbacks.forEach(function(callback) {
                    if (callback != null) callback();
                });
            } finally {
                delete root._bokeh_onload_callbacks
            }
            console.debug("Bokeh: all callbacks have finished");
        }

        function load_libs(css_urls, js_urls, callback) {
            if (css_urls == null) css_urls = [];
            if (js_urls == null) js_urls = [];

            root._bokeh_onload_callbacks.push(callback);
            if (root._bokeh_is_loading > 0) {
                console.debug("Bokeh: BokehJS is being loaded, scheduling callback at", now());
                return null;
            }
            if (js_urls == null || js_urls.length === 0) {
                run_callbacks();
                return null;
            }
            console.debug("Bokeh: BokehJS not loaded, scheduling load and callback at", now());
            root._bokeh_is_loading = css_urls.length + js_urls.length;

            function on_load() {
                root._bokeh_is_loading--;
                if (root._bokeh_is_loading === 0) {
                    console.debug("Bokeh: all BokehJS libraries/stylesheets loaded");
                    run_callbacks()
                }
            }

            function on_error(url) { console.error("failed to load " + url); }

            for (let i = 0; i < css_urls.length; i++) {
                const url = css_urls[i];
                const element = document.createElement("link");
                element.onload = on_load;
                element.onerror = on_error.bind(null, url);
                element.rel = "stylesheet";
                element.type = "text/css";
                element.href = url;
                console.debug("Bokeh: injecting link tag for BokehJS stylesheet: ", url);
                document.body.appendChild(element);
            }

            for (let i = 0; i < js_urls.length; i++) {
                const url = js_urls[i];
                const element = document.createElement('script');
                element.onload = on_load;
                element.onerror = on_error.bind(null, url);
                element.async = false;
                element.src = url;
                console.debug("Bokeh: injecting script tag for BokehJS library: ", url);
                document.head.appendChild(element);
            }
        };

        function inject_raw_css(css) {
            const element = document.createElement("style");
            element.appendChild(document.createTextNode(css));
            document.body.appendChild(element);
        }

        const js_urls   = $bokeh_js;
        const css_urls  = $bokeh_css;
        const inline_js = [
            $(("function(Bokeh){ $r }," for r ∈ js_raw)...)
            function(Bokeh) {}
        ];

        function run_inline_js() {
            for (let i = 0; i < inline_js.length; i++) {
              inline_js[i].call(root, root.Bokeh);
            }
        }

        if (root._bokeh_is_loading === 0) {
            console.debug("Bokeh: BokehJS loaded, going straight to plotting");
            run_inline_js();
        } else {
            load_libs(css_urls, js_urls, function() {
                console.debug("Bokeh: BokehJS plotting callback run at", now());
                run_inline_js();
            });
        }
    }(window));"""
end
end
using .AutoloadRouter
