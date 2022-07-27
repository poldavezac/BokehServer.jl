module AutoloadRoute
using HTTP
using JSON
using ...AbstractTypes
using ..Server
using ..Templates

function options(http::HTTP.Stream)
    HTTP.setstatus(http, 200)
    HTTP.setheader(http, "Content-Type"                  => "text/html")
    HTTP.setheader(http, "Access-Control-Allow-Headers"  => "*")
    HTTP.setheader(http, "Access-Control-Allow-Methods"  => "PUT, GET, OPTIONS")
    HTTP.setheader(http, "Access-Control-Allow-Origin"   => "*")
    HTTP.startwrite(http)
end

function route(http::HTTP.Stream, app::Server.iApplication)
    params = Server.getparams(http)
    token  = (get!(app, http) :: Server.SessionContext).token
    bdy    = body(app, token, params)

    HTTP.setstatus(http, 200)
    HTTP.setheader(http, "Content-Type"                  => "application/javascript")
    HTTP.setheader(http, "Access-Control-Allow-Headers"  => "*")
    HTTP.setheader(http, "Access-Control-Allow-Methods"  => "PUT, GET, OPTIONS")
    HTTP.setheader(http, "Access-Control-Allow-Origin"   => "*")
    HTTP.startwrite(http)
    write(http, bdy)
end

urlprefix(::Server.iApplication) = ""

function body(app::Server.iApplication, token::String, params::Dict{String, String})
    elementid = get(params, "bokeh-autoload-element", nothing)
    if isnothing(elementid)
        Server.httperror("No bokeh-autoload-element query parameter", 400)
    end

    app_path     = get(params, "bokeh-app-path", "/")
    absolute_url = get(params, "bokeh-absolute-url", nothing)
    bundle       = if get(params, "resources", "default") == "none"
        Server.staticbundle()
    elseif isnothing(absolute_url)
        Server.staticbundle()
    else
        uri = HTTP.URIs.URI(absolute_url)
        Server.staticbundle(joinpath("$(uri.scheme)://$(uri.host)", urlprefix(app)))
    end

    script = Templates.onload(Templates.safely(Templates.docjs(
           "{}", (; token, elementid, use_for_title = false);
            app_path, absolute_url
    )))
    return template(elementid, bundle.js_files, bundle.css_files, [script])
end

"""
Renders JavaScript code for "autoloading".

The code automatically and asynchronously loads BokehJS (if necessary) and
then replaces the AUTOLOAD_TAG ``<script>`` tag that
calls it with the rendered model.
"""
function template(
        elementid :: String,
        js_files  :: AbstractVector{<:AbstractString},
        css_files :: AbstractVector{<:AbstractString},
        js_raw    :: AbstractVector{<:AbstractString} = String[],
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

        const js_urls   = $(JSON.json(js_files));
        const css_urls  = $(JSON.json(css_files));
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
precompile(route, (HTTP.Stream{HTTP.Request}, Server.Application))
end
using .AutoloadRoute

route(http::HTTP.Stream, ::Val{:OPTIONS}, ::iApplication, ::Val{Symbol("autoload.js")}) = AutoloadRoute.options(http)
route(http::HTTP.Stream, ::Val{:GET},    𝐴::iApplication, ::Val{Symbol("autoload.js")}) = AutoloadRoute.route(http, 𝐴)
