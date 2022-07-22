macro nullevents(code)
    esc(quote
        BokehServer.Events.eventlist!(BokehServer.Events.EventList()) do
            $code
            @test !isempty(BokehServer.Events.getevents(BokehServer.Events.task_eventlist()))
        end
    end)
end
