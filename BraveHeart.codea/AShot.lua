-- ashot.lua
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

AShot -- represents gun's shots at the game's stage
    = class(Actor)

--------------------
-- config
--------------------

AShot.Config                      = {}
AShot.Config.Sound                = "A Hero's Quest:Hit 1"
AShot.Config.CircleExplosionColor = color(255, 255, 0, 255)
AShot.Config.CircleExplosionAlpha = 150
AShot.Config.CircleSightAlpha     = 250
AShot.Config.RotateRate           = 100
AShot.Config.SizeFactor           = 2
AShot.Config.ExplosionSprite      = nil
AShot.Config.SightSprite          = "Tyrian Remastered:Firestroid"

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function AShot:init
(               -- represents some scheme's person on stage
    person,     -- persont to show on stage
    stage,      -- place where to show 
    plotter     -- helper provides draw function and scaling/panning
)self:doInit(person,stage,plotter)end

function AShot:onDraw
(               -- called to draw all what needs
)self:doOnDraw()end

function AShot:update
(               -- called to update info from person
)self:doUpdate()end

function AShot:setPerson
(               -- called to change playing person
    person      -- persont to show on stage
)self:doSetPerson(person)end

--------------------
-- getters
--------------------

function AShot:getScaleRate   -- Shot's scale rate, used as z-coords
()return self.scaleRate or 0 end

------------------------------------------------------------------------------------------
-- events
------------------------------------------------------------------------------------------

function AShot:bindEvents()
    Events.bind(self.person:getSoundEvent(), self, AShot.onSoundEvent)
end

function AShot:onSoundEvent(...)
    local eventPerson = unpack({...})
    if eventPerson==self.person then
        sound(self.sound)
    end
end

------------------------------------------------------------------------------------------
-- implements
------------------------------------------------------------------------------------------

function AShot:doInit(person,stage,plotter)
    Actor.doInit(self,person,stage,plotter)
    self:initConfig ()
    self:bindEvents ()
end

function AShot:doSetPerson(person)
    self.person = person
end

function AShot:doUpdate()
    self.x,self.y    = self.person:getPosition()
    self.progress    = self.person:getProgress()
    self.active      = self.person:isActive()
    self.scaleRate   = self.person:getScaleRate()
    self.radius      = self.person:getRadius()
    self.mode        = self.person:getMode()
end

function AShot:doOnDraw()
    if self.active then
        self:drawSpriteShot()
    end
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- init
--------------------

function AShot:initConfig()
    self.explosionRadiusRate  = AShot.Config.ExplosionRadiusRate
    self.sound                = AShot.Config.Sound
    self.circleExplosionColor = AShot.Config.CircleExplosionColor
    self.circleExplosionAlpha = AShot.Config.CircleExplosionAlpha
    self.circleSightAlpha     = AShot.Config.CircleSightAlpha
    self.rotateRate           = AShot.Config.RotateRate
    self.explosionSprite      = AShot.Config.ExplosionSprite
    self.sightSprite          = AShot.Config.SightSprite
    self.sizeFactor           = AShot.Config.SizeFactor
end

--------------------
-- draw sprite
--------------------

function AShot:drawSpriteShot()
    self:drawSpriteShotBall  ()
    self:drawSpriteShotShadow()
end

function AShot:drawSpriteShotBall()
    local op  = self:calcFadingOpacity()
    local ss  = self:calcFadingRadius()*2*self.sizeFactor
    local tc  = self:calcTintColor()
    local a   = self.circleSightAlpha*(1-op)
    local tca = color(tc.r,tc.g,tc.b,a)
    self.plotter:open()
        translate(self.x, self.y)
        tint(tca)
        spriteMode(CENTER)
        rotate(-ElapsedTime*self.rotateRate)
        sprite(self.sightSprite,0,0,ss)
    self.plotter:close()
end

function AShot:drawSpriteShotShadow()
    local ss  = 5*self:calcFadingRadius()*self.sizeFactor
    local p   = math.pow(self.progress,0.75)
    local a   = Calc.between(20,60,p)
    local tca = color(44, 64, 44, a)
    local x   = self.x
    local Y   = Stage.Config.HorizontY
    local y   = Y*p
    local sw  = ss*(1-p)
    local sh  = sw/3
    if y+ss >= self.y then return end
    self.plotter:open()
        translate(x,y)
        tint(tca)
        spriteMode(CENTER)
        sprite("Small World:Grass Patch",0,0,sw,sh)
    self.plotter:close()
end

function AShot:drawShotRadius()
    local sr  = self:calcFadingRadius()
    self.plotter:open()
        stroke(255, 229, 0, 255)
        strokeWidth(2)
        self.plotter:arc(self.x,self.y,sr)
    self.plotter:close()
end

--------------------
-- calc
--------------------

function AShot:calcTintColor()
    local p = self.progress
    local r,g,b
    if self.mode == Shot.Mode.Ballistic then
        p = math.pow(p,1.5)
        r = Calc.between(300,120,p)
        g = Calc.between(300,120,p)
        b = Calc.between(100,600,p)
    elseif self.mode == Shot.Mode.Straight then
        p = math.pow(p,2)
        r = Calc.between(100,100,p)
        g = Calc.between(300,100,p)
        b = Calc.between(200,500,p)
    end
    return color(r,g,b)
end

function AShot:calcFadingRadius()
    return self.scaleRate*self.radius
end

function AShot:calcFadingOpacity()
    local p = self.progress
    if self.mode == Shot.Mode.Ballistic then
        return math.pow(1-p,4)
    elseif self.mode == Shot.Mode.Straight then
        p = math.min(1,0.5*p)
        return math.pow(p,1/3)
    end
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
