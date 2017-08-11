-- actor.lua
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Actor -- abstract class belongs to stage and aimed for drawing and iteractiving
    = class()

--------------------
-- config
--------------------

Actor.Config = {}

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Actor:init
(               -- represents some scheme's person on stage
    person,     -- persont to show on stage
    stage,      -- place where to show 
    plotter     -- helper provides draw function and scaling/panning
)self:doInit(person,stage,plotter)end

function Actor:onTouch
(               -- called to proc touching
    touch       -- Codea Touch structure, contains info about touching
)self:doOnTouch(touch)end

function Actor:onDraw
(               -- called to draw all what needs
)self:doOnDraw()end

function Actor:update
(               -- called to update info from person
)self:doUpdate()end

------------------------------------------------------------------------------------------
-- implements
------------------------------------------------------------------------------------------

function Actor:doInit(person,stage,plotter)
    self.person      = person
    self.stage       = stage
    self.plotter     = plotter
end

function Actor:doUpdate()
end

function Actor:doOnTouch(t)
end

function Actor:doOnDraw()
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function Actor:initConfig()
end

function Actor:initAttributes()
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
