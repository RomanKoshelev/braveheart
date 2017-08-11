-- sys.lua
-- RKdev (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Sys -- static class for system and core operations
    = class()

--------------------
-- config
--------------------

Sys.Config               = {}
Sys.Config.ErrorPrefix   = "Error: "
Sys.Config.WarningPrefix = "Warning: "

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Sys.trace
(               -- print trace log excluding service calls such as Sys.error etc
)Sys.doTrace()end

function Sys.error
(               -- print error message and trace log, stops the application execution
    msg,        -- error message
    id          -- nil or ovject identifiers, for instance "widget.1"
)Sys.doError(msg, id)end

function Sys.warning
(               -- print warning message and trace log
    msg,        -- warning message
    id          -- nil or ovject identifiers, for instance "widget.1"
)Sys.doWarning(msg, id)end

function Sys.assert
(               -- check condition and print error, log and stop app if chek is failed
    cond,       -- expression returns true or false (nil)
    msg,        -- error message
    id          -- nil or ovject identifiers, for instance "widget.1"
)Sys.doAssert(cond, msg, id)end

function Sys.preventMemoryCrash
(               -- Codea specific preventive measure to avoid memory crash
)Sys.doPreventMemoryCrash()end

function Sys.timestamp
(               -- makes stamp of current local time
)               -- return something looks like "2014-07-04 19:51:28"
return Sys.doTimestamp()end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

--------------------
-- debug
--------------------

function Sys.doTrace()
    local trace = debug.traceback()
    trace=Sys.prepareTrace(trace)
    print(trace)
end

function Sys.doError(msg, id)
    local err = Sys.Config.ErrorPrefix..(msg or "")
    if id then err = id..": "..err end
    print(err)
    Sys.trace()
    error()
end

function Sys.doWarning(msg, id)
    local err = Sys.Config.WarningPrefix..(msg or "")
    if id then err = id..": "..err end
    print(err)
    Sys.trace()
    displayMode(OVERLAY)
end

function Sys.doAssert(cond, msg, id)
    if not cond then
        Sys.error(msg, id)
    end
end

--------------------
-- memory
--------------------

function Sys.doPreventMemoryCrash()
    collectgarbage()
end

--------------------
-- time
--------------------

function Sys.doTimestamp()
    local now    = os.date("*t") 
    return string.format("%d-%02d-%02d %02d:%02d:%02d", 
    now.year, now.month, now.day,
    now.hour, now.min, now.sec)
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- trace
--------------------

function Sys.prepareTrace(trace)
    trace = string.gsub(trace,"stack traceback:\n","")
    trace = string.gsub(trace,"string ","")
    trace = string.gsub(trace,"\t","")
    trace = string.gsub(trace," %-%-","")
    trace = string.gsub(trace,"%-%- ","")
    trace = string.gsub(trace,"%.%.%.","")
    trace = string.gsub(trace,'"',"")
    trace = string.gsub(trace,"%[","")
    trace = string.gsub(trace,"%]:"," (")
    trace = string.gsub(trace," in function ","")
    trace = string.gsub(trace,"%.lua","")
    trace = string.gsub(trace,"'"," ")
    trace = string.gsub(trace,":",")")
    trace = string.gsub(trace,".*warning \n","")
    trace = string.gsub(trace,".*error \n","")
    trace = string.gsub(trace,".*assert \n","")
    trace = string.gsub(trace,".*trace \n","")
    trace = string.gsub(trace,".*Warning \n","")
    trace = string.gsub(trace,".*Error \n","")
    trace = string.gsub(trace,".*Assert \n","")
    trace = string.gsub(trace,".*Trace \n","")
    return trace
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
