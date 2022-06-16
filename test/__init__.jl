macro nullevents(code)
    esc(quote
        Bokeh.Events.eventlist!(Bokeh.Events.EventList()) do
            $code
            @test !isempty(Bokeh.Events.getevents(Bokeh.Events.task_eventlist()))
        end
    end)
end
