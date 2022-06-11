macro nullevents(code)
    esc(quote
        Bokeh.Events.eventlist!(Bokeh.Events.NullEventList()) do
            $code
        end
    end)
end
