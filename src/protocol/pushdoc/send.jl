function pushdoc(self::Events.Document)
    return (; doc = (;
        title   = self.title,
        version = Bokeh.PYTHON_VERSION,
        defs    = [],
        roots   = (;
            root_ids   = bokehid.(getroots(self)),
            references = [serialize(i) for i ∈ values(allmodels(self))],
        ),
    ))
end
