-- dragonbase.lua 
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

DragonBase -- used to hide horrible implementations
    = class(Person)

--------------------
-- config 
--------------------

DragonBase.Config               = {}
DragonBase.Config.MaxSpriteSize = 50

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function DragonBase:doInit(bestSprites)
    DragonBase.initConfig     (self)
    DragonBase.initImage      (self,bestSprites)
    DragonBase.initTimer      (self)
    DragonBase.initAges       (self)
    DragonBase.initBox        (self)
    DragonBase.initHead       (self)
    DragonBase.initSegments   (self)
end

function DragonBase:doUpdate()
    DragonBase.updateTimer    (self)
    DragonBase.updateTwisting (self)
    DragonBase.updateAges     (self)
    DragonBase.updateHead     (self)
    DragonBase.updateBox      (self)
    DragonBase.updateSegments (self)
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function DragonBase:initConfig()
    self.timeRate      = Game.Config.TimeRate
    self.maxSpriteSize = DragonBase.Config.MaxSpriteSize
end

--------------------
-- timer
--------------------

function DragonBase:initTimer()
    self.timer = Timer()
end

function DragonBase:updateTimer()
    self.timer:onTick()
end

function DragonBase:time()
    return self.timer:time()
end

--------------------
-- head 
--------------------

function DragonBase:initHead()
    self.head = {x=0,y=0,r=0,angle=0}
end

function DragonBase:updateHead()
    if self.stricken then return end
    local et = DragonBase.time(self)
    self.head.x = 
        DragonBase.harmonyCoord(self, et,self.dx,self.kx,self.boxCenter.x,self.boxWidth)
    self.head.y = 
        DragonBase.harmonyCoord(self, et,self.dy,self.ky,self.boxCenter.y,self.boxHeight)
    local t0=math.pow(self.len,self.twisting)
    local tt=math.sin(et)*15
    self.head.angle  = tt-t0
end

--------------------
-- image 
--------------------

function DragonBase:initImage(bestSprites)
    self.image = Pack.getRandomDragonSprite(bestSprites)
    self.image = DragonBase.bufferImage(self,self.image)
end

function DragonBase:bufferImage(img)
    local w,h = spriteSize(img)
    local N   = self.maxSpriteSize
    local k   = math.min(1, N/math.max(w,h))
    local buf = image(w*k,h*k)
    pushMatrix()
    pushStyle()
    setContext(buf)
    spriteMode(CORNER)
    sprite(img,0,0,w*k,h*k)
    setContext()
    popStyle()
    popMatrix()
    return buf
end

--------------------
-- ages 
--------------------

function DragonBase:initAges()
    self.age        = 0
    self.strikeAge  = 0
    self.strikeTime = nil
    self.birthTime  = DragonBase.time(self)
end

function DragonBase:updateAges()
    local et        = DragonBase.time(self)
    self.age        = et - self.birthTime
    self.strikeAge  = self.strikeTime and et - self.strikeTime or 0
end

--------------------
-- motion 
--------------------

function DragonBase:initBox()
    local rand = math.random
    local c    = self.complexy
    local h    = Calc.between(0.3,0.7,c)
    self.bottom       = 200
    self.motionWidth  = WIDTH
    self.motionHeight = HEIGHT-self.bottom
    self.dx=rand()
    self.dy=rand()
    self.kx=rand()*3+1
    self.ky=math.random()*3+1
    self.boxCenter0   = vec2()
    self.boxCenter0.x = rand()*self.motionWidth
    self.boxCenter0.y = (h+(1-h)*rand())*self.motionHeight
    self.boxWidth0    = Calc.randomPow(0.5, 3, 1/2)*self.motionWidth 
    self.boxHeight0   = Calc.randomPow(0.5, 3, 1/2)*self.motionHeight
    self.boxWidth1    = self.motionWidth
    self.boxHeight1   = self.motionHeight    
    self.boxCenter    = self.boxCenter0
    self.boxWidth     = self.boxWidth0
    self.boxHeight    = self.boxHeight0
end

function DragonBase:updateBox()
    if self.stricken then return end
    local k = math.min(1, self.scaleRate)
    local x = self.motionWidth/2*k  + self.boxCenter0.x*(1-k)
    local y = self.motionHeight/2*k + self.boxCenter0.y*(1-k) + self.bottom
    self.boxCenter = vec2(x,y)
    if k==1 then 
        self.mbc = 1-0.5*math.sin(self.mbt/self.mbd)
        self.mbt = self.mbt + 1/60
    else
        self.mbc = 1
        self.mbt = 0
        self.mbd = 2+4*math.random()
    end
    self.boxWidth  = self.boxWidth1 *k*self.mbc + self.boxWidth0 *(1-k)
    self.boxHeight = self.boxHeight1*k*self.mbc + self.boxHeight0*(1-k)
end

--------------------
-- segments 
--------------------

function DragonBase:initSegments()
    self.segments = {}
    for i = 1,self.len do
        self.segments[i] = {
            x          = self.head.x, 
            y          = self.head.y,
            z          = i/self.len,
            image      = self.image,
            angle      = 0,
            visible    = false,
            birthTime  = nil,
            strikeTime = nil,
            stricken   = false,
            age        = 0,
            strikeAge  = 0,
        }
    end
end

function DragonBase:updateSegments()
    local et = DragonBase.time(self)
    for i,seg in ipairs(self.segments) do
        if i<self.len then 
            local visible   = seg.visible
            local stricken  = seg.stricken
            local next      = self.segments[i+1]
            seg.x           = next.x
            seg.y           = next.y
            seg.visible     = next.visible
            seg.strikeTime  = next.strikeTime
            seg.stricken    = next.stricken
            if not visible and seg.visible then 
                seg.birthTime = et 
            end
            if not stricken and seg.stricken then
                seg.strikeTime = et 
            end
        else
            seg.x          = self.head.x
            seg.y          = self.head.y
            seg.visible    = true
            seg.birthTime  = self.birthTime
            seg.strikeTime = self.strikeTime
            seg.stricken   = self.stricken
        end
        seg.angle     = self.head.angle+math.pow(i,self.twisting)
        seg.age       = seg.birthTime  and (et - seg.birthTime)  or 0
        seg.strikeAge = seg.strikeTime and (et - seg.strikeTime) or 0
    end
end

--------------------
-- harmony
--------------------

function DragonBase:harmonyCoord(et, d, k, center, size)
    local c = math.sin(math.pi*(et+d)/k) + 1
    c = c*size/2
    c = c*self.scaleRate
    c = c + center - size/2*self.scaleRate
    return c
end

--------------------
-- twisting
--------------------

function DragonBase:updateTwisting()
    local d = 0 --0.000001
    self.twisting = self.twisting + d
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
