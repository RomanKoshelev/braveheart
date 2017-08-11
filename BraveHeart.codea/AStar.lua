-- astar.lua
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

AStar -- represents sky's stars at the game's stage
    = class(Actor)

--------------------
-- config
--------------------

AStar.Config                 = {}
AStar.Config.ActiveSprite    = "SpaceCute:Star"
AStar.Config.MinSize         = 7
AStar.Config.MaxSize         = 75
AStar.Config.MinAlpha        = 100

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function AStar:init
(               -- represents some scheme's person on stage
    person,     -- persont to show on stage
    stage,      -- place where to show 
    plotter     -- helper provides draw function and scaling/panning
)self:doInit(person,stage,plotter)end

function AStar:onDraw
(               -- called to draw all what needs
)self:doOnDraw()end

function AStar:update
(               -- called to update info from person
)self:doUpdate()end


------------------------------------------------------------------------------------------
-- implements
------------------------------------------------------------------------------------------

function AStar:doInit(person,stage,plotter)
    Actor.doInit(self,person,stage,plotter)
    self:initConfig ()
end

function AStar:doUpdate()
    self.x,self.y    = self.person:getPosition()
    self.active      = self.person:isActive()
    self.lightRate   = self.person:getLightRate()
end

function AStar:doOnDraw()
    if self.active then
        self:drawSpriteStar()
    end
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- init
--------------------

function AStar:initConfig()
    self.activeSprite = AStar.Config.ActiveSprite
    self.minSize      = AStar.Config.MinSize
    self.maxSize      = AStar.Config.MaxSize
    self.minAlpha     = AStar.Config.MinAlpha
end

--------------------
-- draw sprite
--------------------

function AStar:drawSpriteStar()
    local a=self:calcAlpha()
    local w=self:calcSize()
    pushStyle()
    spriteMode(CENTER)
    tint(255, 255, 255, a)
    sprite(self.activeSprite,self.x,self.y,w)
    popStyle()
end

function AStar:calcAlpha()
    Sys.assert(self.lightRate>=0,"Light rate <= 0")
    local s = math.sin(ElapsedTime*40)/2+0.5
    local q = 0.7
    local ma = self.minAlpha*q + self.minAlpha*(1-q)* s
    local lr = math.pow(self.lightRate,1/10)
    return ma+(255-ma)*lr
end

function AStar:calcSize()
    local lr = 
        8*math.pow(self.lightRate,  2)  +
        2*math.pow(self.lightRate,1/2)
    lr = lr/10
    return Calc.between(self.minSize,self.maxSize,lr)
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
