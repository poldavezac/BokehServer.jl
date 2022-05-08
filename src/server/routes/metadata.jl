function metadataroute(::Val{:GET}, app::iApplication, session::SessionContext)
    HTTP.Response(
        200,
        ["Content-Type" => "application/json"];
        body    = JSON.json((; url = applicationurl(app), data = applicationmetadata(app))),
        request = session.request
    )
end
