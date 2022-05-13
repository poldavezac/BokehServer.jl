using ..Events
using ..Protocol
using ..Protocol.Messages: @msg_str

function handle(msg::Protocol.Message, _...)
    @error "$msg should not be received by the server"
    return ()
end

handle(msg::msg"SERVER-INFO-REQ", _...)                = ((msg"SERVER-INFO-REPLY", msg.header["msgid"]),)
handle(msg::msg"PULL-DOC-REQ", doc::iDocument, _)      = ((msg"PULL-DOC-REPLY", msg.header["msgid"], pushdoc(doc)),)

for (tpe, func) ∈ (msg"PULL-DOC-REPLY" => :pushdoc!, msg"PATCH-DOC" => :patchdoc!)
    @eval function handle(msg::$tpe, doc::iDocument, events :: Events.iEventList)
        task = @async let oldids = allids(doc)
            Events.eventlist(events) do _
                Protocol.$func(session.doc, msg.contents)

                Events.flushevents!(events)
            end

            outp = Protocol.patchdoc(events, doc, oldids)
            return isempty(outp.events) ? ((msg"OK"),) : ((msg"PATCH-DOC", outp), (msg"OK",))
        end
    end
end
