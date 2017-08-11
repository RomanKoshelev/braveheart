-- adragon.lua
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

ADragon -- actor for dragon 
    = class(Actor)

--------------------
-- config
--------------------

ADragon.Config = {}

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function ADragon:init
(               -- represents some scheme's person on stage
    person,     -- person to show on stage
    stage,      -- place where to show 
    plotter     -- helper provides draw function and scaling/panning
)self:doInit(person,stage,plotter)end

function ADragon:onDraw
(               -- called to draw all what needs
)self:doOnDraw()end

function ADragon:update
(               -- called to update info from person
)self:doUpdate()end

------------------------------------------------------------------------------------------
-- events
------------------------------------------------------------------------------------------

function ADragon:bindEvents()
    Events.bind(Game.Config.Events.DragonStrike,  self, ADragon.onStrikeEvent)
end

function ADragon:onStrikeEvent(...)
    return self:doOnStrikeEvent(unpack({...}))
end

------------------------------------------------------------------------------------------
-- implements
------------------------------------------------------------------------------------------

function ADragon:doInit(person,stage,plotter)
    Actor.doInit(self,person,stage,plotter)
    self:initConfig    ()
    self:initAttributes()
    self:update        ()
    self:bindEvents    ()
end

function ADragon:doUpdate()
    self.mode      = self.person:getMode      ()
    self.head      = self.person:getHead      ()
    self.twisting  = self.person:getTwisting  ()
    self.scaleRate = self.person:getScaleRate ()
    self.segments  = self.person:getSegments  ()
    self.radius    = self.person:getRadius    ()
    self.age       = self.person:getAge       ()
    self.len       = self.person:getLen       ()
    self.stricken  = self.person:isStricken   ()
    self.strikeAge = self.person:getStrikeAge ()
    self.box       = self.person:getBox       ()
    self.x,self.y  = self.head.x,self.head.y
    self.w,self.h  = self:getDragonSpriteSize(self.segments[1].image)
    if self.age==0 then self:onBirn() end
end

function ADragon:doOnDraw()
    self:drawDragonShadow  ()
    self:drawDragonSegments()
end

function ADragon:doOnStrikeEvent(person)
    if self.person == person then
        sound("Game Sounds One:Explode Big")
    end
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function ADragon:initConfig()    
    self.strikeSound = ADragon.Config.StrikeSound
end
    
function ADragon:initAttributes()    
    self.buffer = {}
end

function ADragon:onBirn()
    sound("Game Sounds One:Radar")
end    

--------------------
-- draw
--------------------

function ADragon:drawDragonShadow() 
    self:drawDragonHeadShadow()
end

function ADragon:drawDragonSegmentsShadows() 
    for i,seg in ipairs(self.segments) do
        self:drawDragonSegmentShadow(seg,self.len-i+1)
    end
end

function ADragon:drawDragonSegments() 
    for i,seg in ipairs(self.segments) do
        self:drawDragonSegment(seg,self.len-i+1)
    end
end

function ADragon:drawDragonSegment(seg,i)    
    if not seg.visible then return end
    local zScale = math.pow(seg.z,0.5)
    local gScale = math.pow(seg.z,1.5)
    local s      = zScale*self.scaleRate
    local x,y,z  = seg.x,seg.y,seg.z
    local a      = seg.angle
    local o      = math.min(1,math.pow(seg.age/5,2))
    local q      = 128
    local tc     = q+(255-q)*gScale
    local ta     = (q+(255-q)*gScale)*o
    local img    = seg.image
    local sa     = math.pow(self.strikeAge, 3)
    local ca     = math.pow((1.001+math.sin(self.strikeAge*5))/2, 1)
    local aa     = math.pow(self.strikeAge, 1.5)
    local tca    = Color.grey(tc,ta)
    local tcas   = Color.grey(tc+255*ca,ta/aa)
    local w,h    = self.w,self.h
    local sx,sy  = 0,0
    if self.stricken then
        s     = s/(1+sa)
        a     = a+self.strikeAge
        tc    = tcas
        sx,sy = x*sa,y*sa
    else
        tc    = tca
        sx,sy = 0,0
    end
    self.plotter:open()
    spriteMode(CENTER)
    translate (x,y)
    scale     (s)
    rotate    (a)
    tint      (tc)
    sprite    (img,sx,sy,w,h)
    self.plotter:close()
end

function ADragon:drawDragonHeadShadow()    
    local s   = self.scaleRate
    local k   = self.mode==Dragon.Mode.Near and 10 or 10
    local ss  = k*self.radius*s
    local aa  = Calc.degree(0,self.age,0.5)
    local saa = 1-Calc.degree(0,self.strikeAge,0.25)
    local a   = Calc.between(30,120,s)*aa*saa
    local tca = color(61, 61, 61, a)
    local x   = self.head.x
    local Y   = Stage.Config.HorizontY
    local y   = Y*(1-s)
    local sw  = ss
    local sh  = sw/10
    self.plotter:open()
        translate(x,y)
        tint(tca)
        spriteMode(CENTER)
        sprite("Small World:Grass Patch",0,0,sw,sh)
    self.plotter:close()
end

function ADragon:drawDragonRadius()
    local dr  = self.radius*self.scaleRate
    self.plotter:open()
        stroke(255, 229, 0, 255)
        strokeWidth(2)
        self.plotter:arc(self.x,self.y,dr)
    self.plotter:close()
end

--------------------
-- images
--------------------

function ADragon:getDragonSpriteSize(img)
    local w,h = self:spriteSize(img)
    local ms  = self.radius*2
    if w>h then w,h = ms,ms*h/w
    else        h,w = ms,ms*w/h end
    return w,h
end

function ADragon:spriteSize(img)
    if not self.spriteSizeCache then 
        self.spriteSizeCache= {}
    end
    local size = self.spriteSizeCache[i]
    if not size then
        local w,h = spriteSize(img)
        size = {w=w,h=h}
        self.spriteSizeCache[img] = size
    end
    return size.w,size.h
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
