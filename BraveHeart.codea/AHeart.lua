-- aheart.lua
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

AHeart -- represents silly heart at the game's stage
    = class(Actor)

--------------------
-- config
--------------------

AHeart.Config                = {}
AHeart.Config.SpriteSizeRate = 1.0
AHeart.Config.Sprite         = "Small World:Heart"
AHeart.Config.IncreaseSprite = "Small World:Mote Happy"

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function AHeart:init
(               -- represents some scheme's person on stage
    person,     -- persont to show on stage
    stage,      -- place where to show 
    plotter     -- helper provides draw function and scaling/panning
)self:doInit(person,stage,plotter)end

function AHeart:onDraw
(               -- called to draw all what needs
)self:doOnDraw()end

function AHeart:update
(               -- called to update info from person
)self:doUpdate()end

------------------------------------------------------------------------------------------
-- implements
------------------------------------------------------------------------------------------

function AHeart:doInit(person,stage,plotter)
    Actor.doInit(self,person,stage,plotter)
    self:initConfig ()
end

function AHeart:doUpdate()
    self.active       = self.person:isActive       ()
    if not self.active then return end
    self.x,self.y     = self.person:getPosition    ()
    self.scaleRate    = self.person:getScaleRate   ()
    self.size         = self.person:getSize        ()
    self.increaseRate = self.person:getIncreaseRate()
end

function AHeart:doOnDraw()
    if self.active then
        self:drawSprite  ()
        self:drawIncrease()
    end
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- init
--------------------

function AHeart:initConfig()
    self.sprite         = AHeart.Config.Sprite
    self.spriteSizeRate = AHeart.Config.SpriteSizeRate
    self.increaseSprite = AHeart.Config.IncreaseSprite
end

--------------------
-- draw
--------------------

function AHeart:drawSprite()
    local x,y = self.x,self.y
    local s   = self:calcSpriteSize()
    self.plotter:open()
        spriteMode(CENTER)
        sprite(self.sprite,x,y,s)
    self.plotter:close()
end

function AHeart:drawIncrease()
    if self.increaseRate == 0 then return end
    local ir = math.max(0.1,self.increaseRate)
    local A  = 1.7
    local dx = -2.5*A*ir*self.scaleRate
    local dy =  1.4*A*ir*self.scaleRate
    local x,y = self.x+dx,self.y+dy
    local k = self:calcBeatrateFactor()
    local s = A*self:calcBaseSize()*k*ir
    self.plotter:open()
        spriteMode(CENTER)
        sprite(self.increaseSprite,x,y,s)
    self.plotter:close()
end
--------------------
-- calc
--------------------

function AHeart:calcSpriteSize()
    local s = self:calcBaseSize()
    local k = self:calcBeatrateFactor()
    local m = 3
    local size = m+(s-m)*k
    return size
end

function AHeart:calcBaseSize()
    return self.size*self.spriteSizeRate*self.scaleRate*2
end

function AHeart:calcBeatrateFactor()
    local a = 0.1
    local b = 1-a
    local k = 0.5+math.sin(ElapsedTime*5)/2
    k = math.pow(k,10)
    local d = a*k
    local f = b+d
    return f
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
