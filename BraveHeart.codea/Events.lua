-- events.lua
-- RKDev (c) 2014 (based on Twolivesleft code)

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Events -- Static class supports message passing between objects
    = class()

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Events.bind
(               -- call this method to listen events
    event,      -- listen event as string
    obj,        -- usually it is the event's listener
    func        -- will be called with obj as first parameter when event is rised
)Events.doBind(event,obj,func)end
    
function Events.trigger
(               -- call this method to rise event with optional arguments
    event,      -- rised event as string
    ...         -- optional arguments
)Events.doTrigger(event,unpack({...}))end

function Events.unbind
(               -- stop listen events by specified object
    obj,        -- listener
    optEvent    -- specified event to stop listen or nil for all event with obj
)Events.doUnbind(obj,optEvent)end

function Events.unbindEvent
(               -- stop listen specified event by all objects
    event       -- abandoned event
)Events.doUnbindEvent(event)end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

--------------------
-- data
--------------------

Events.__callbacks = {}

--------------------
-- methods
--------------------

function Events.doBind(event,obj,func)
    Sys.assert(event,"nil event")
    Sys.assert(obj,  "nil obj", event)
    Sys.assert(func, "nil func",event)
    if not Events.__callbacks[event] then
        Events.__callbacks[event] = {}
    end
    if not Events.__callbacks[event][obj] then
        Events.__callbacks[event][obj] = {}
    end
    Events.__callbacks[event][obj][func] = 1
end

function Events.doTrigger(event,...)
    Sys.assert(event,"nil event")
    if Events.__callbacks[event] then
        local clone = {}
        for obj,funcs in pairs(Events.__callbacks[event]) do
            clone[obj] = {}
            for func,dummy in pairs(funcs) do
                clone[obj][func] = 1
            end
        end
        for obj,funcs in pairs(clone) do
            for func,dummy in pairs(funcs) do
                local argCopy = Events.flatcopy({...})
                table.insert(argCopy,1,obj)
                func(unpack(argCopy))
            end
        end
    end
end

function Events.doUnbind(obj,event)
    Sys.assert(obj,"nil obj")
    for evt,cbs in pairs(Events.__callbacks) do
        if event == nil or event == evt then
            cbs[obj]=nil
        end
    end
end

function Events.doUnbindEvent(event)
    Sys.assert(event,"nil event")
    Events.__callbacks[event] = nil
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function Events.flatcopy(t)
    local new_t = {}           
    local i, v = next(t, nil)
    while i do
        new_t[i] = v
        i, v = next(t, i)
    end
    return new_t
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
