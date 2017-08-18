-- stage.lua
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Stage -- used for representation of game's proceses
    = class()

--------------------
-- config
--------------------

Stage.Config                  = {}
Stage.Config.Landscape        = "Documents:sky2"
Stage.Config.BestShotSound    = "Game Sounds One:Crowd Cheer"
Stage.Config.HorizontY        = math.max(WIDTH,HEIGHT) / 1024 * 180

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Stage:init
(               -- called when created instance to initialise it
    scheme      -- object that responds for game persons, their logic and rules
)self:doInit(scheme)end

function Stage:onTick
(               -- called to make updates and calcs
)self:doOnTick()end

function Stage:onDraw
(               -- called to draw all what needs
)self:doOnDraw()end

function Stage:onTouch
(               -- called to proc touching
    touch       -- Codea Touch structure, contains info about touching
)self:doOnTouch(touch)end


------------------------------------------------------------------------------------------
-- events
------------------------------------------------------------------------------------------

function Stage:bindEvents()
    Events.bind(Game.Config.Events.BestShotSound, self, Stage.onBestShotSound)
end

function Stage:onBestShotSound(...)
    self:doOnBestShotSound(unpack({...}))
end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Stage:doInit(scheme)
    self:initConfig    ()
    self:initAttributes(scheme)
    self:createElements()
    self:bindEvents    ()
end

function Stage:doOnTouch(t)
    self:touchActors(t)
end

function Stage:doOnTick()
    self.canvas:onTick()
    self:updateActors()
end

function Stage:doOnDraw()
    self:drawBackground()
    self:drawActors()
end

function Stage:doOnBestShotSound()
    tween.delay(0.1,function() 
        sound(self.bestShotSound) end)
    tween.delay(7,function() 
        sound("A Hero's Quest:Level Up") end)
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function Stage:initConfig()
    self.landscape     = Stage.Config.Landscape
    self.bestShotSound = Stage.Config.BestShotSound
end

function Stage:initAttributes(scheme)
    self.scheme = scheme
end

function Stage:createElements()
   self:createCanvas()
   self:createActors()
end

function Stage:createCanvas()
    self.canvas    = Canvas(self,0,0,WIDTH,HEIGHT)
    self.canvas:setScale(1)
    self.canvas:setBasisMode(Canvas.Mode.Basis.Corner)
    self.plotter   = self.canvas:getPlotter()
end

--------------------
-- landscape
--------------------

function Stage:drawBackground()
    local lw,lh = spriteSize(self.landscape)
    local sw,sh = WIDTH, HEIGHT
    local kw,kh = lw/sw,lh/sh
    local k = math.min(kw,kh)
    local w,h = lw/k,lh/k
    local x,y = (sw-w)/2,0
    spriteMode(CORNER)
    sprite(self.landscape,x, y, w, h)
end

--------------------
-- actors
--------------------

function Stage:createActors()
    self.dragon = ADragon(self.scheme:getDragon(),self,self.plotter)
    self.gun    = AGun   (self.scheme:getGun(),   self,self.plotter)
    self.sky    = ASky   (self.scheme:getSky(),   self,self.plotter)
    self.heart  = AHeart (self.scheme:getHeart(), self,self.plotter)
end

function Stage:drawActors()
    local ds = self.dragon.scaleRate
    self.sky:onDraw        ()
    self.gun:drawFarShots  (ds)
    self.dragon:onDraw     ()
    self.heart:onDraw      ()
    self.gun:drawNearShots (ds)
end

function Stage:updateActors()
    self.dragon:update()
    self.gun:update   ()
    self.sky:update   ()
    self.heart:update ()
end

function Stage:touchActors(t)
    self.gun:onTouch(t)
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
