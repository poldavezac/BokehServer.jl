macro nullevents(code)
    esc(quote
        BokehJL.Events.eventlist!(BokehJL.Events.EventList()) do
            $code
            @test !isempty(BokehJL.Events.getevents(BokehJL.Events.task_eventlist()))
        end
    end)
end
