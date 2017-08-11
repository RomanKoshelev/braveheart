-- apbase.lua 
-- RKdev (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Appbase -- base class for App class with routine functionality
    = class()

--------------------
-- config
--------------------

Appbase.Config                   = {}
Appbase.Config.Font              = "AmericanTypewriter"

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Appbase:doInit(name,domain,descr)
    Appbase.setMetadata(self,name,domain,descr)
end

function Appbase:doOnTick() 
end

function Appbase:doOnDraw()
end

function Appbase:doOnTouch(t) 
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- display
--------------------

function Appbase:initDisplay()
    -- displayMode          (FULLSCREEN_NO_BUTTONS)
    backingMode          (RETAINED)
    supportedOrientations(PORTRAIT_ANY)
end

--------------------
-- metadata
--------------------

function Appbase:setMetadata(name,domain,descr)
    Sys.assert(name,"App must have a name")
    Sys.assert(domain,"App must have a domain")
    self.name        = name
    self.domain      = domain
    self.description = descr   or "no description"
    saveProjectInfo("Description", self.description)
end

--------------------
-- elements
--------------------

function Appbase:createElements()
    -- self.codekeeper = Codekeeper(self.domain)
end

--------------------
-- sys menu
--------------------

function Appbase:createParameters()
    -- parameter.action("Send "..self.name, function()Appbase.sendProject(self)end)
    -- parameter.action("Update "..self.name, function()Appbase.updateProject(self)end)
end

--------------------
-- source control
--------------------

function Appbase:sendProject()
    -- self.codekeeper:sendCurrentProjectIfNeed(self.name)
end

function Appbase:updateProject()
    -- self.codekeeper:updateCurrentProjectIfNeed(self.name)
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
