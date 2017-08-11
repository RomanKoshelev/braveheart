-- dragon.lua 
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Dragon -- gamescheme's elemet responding for the dragon's logic and behaviour
    = class(DragonBase)

--------------------
-- mode
--------------------

Dragon.Mode      = {}
Dragon.Mode.Far  = "far"
Dragon.Mode.Near = "near"

--------------------
-- config
--------------------

Dragon.Config                     = {}
Dragon.Config.MaxScaleRate        = 1.00  -- 1.00
Dragon.Config.MinFarIniScaleRate  = 0.01  -- 0.01
Dragon.Config.MaxFarIniScaleRate  = 0.04  -- 0.04
Dragon.Config.MinNearIniScaleRate = 0.25   -- 0.35
Dragon.Config.MaxNearIniScaleRate = 0.45   -- 0.50
Dragon.Config.MinScaleRateSpeed   = 1.0017 -- 1.0017
Dragon.Config.MaxScaleRateSpeed   = 1.0030 -- 1.0030
Dragon.Config.MinLen              =  90    --  40
Dragon.Config.MaxLen              =  90    -- 100
Dragon.Config.MinFarRadius        =  65    --  75
Dragon.Config.MaxFarRadius        =  75    -- 100
Dragon.Config.MinNearRadius       = 100    -- 150
Dragon.Config.MaxNearRadius       = 150    -- 300
Dragon.Config.TimeAfterStrike     =   5
Dragon.Config.SegmentWorth        = Pack.Balance.DragonSegmentWorth
Dragon.Config.Mode                = Dragon.Mode.Far
Dragon.Config.Complexity          = 0.00111

--------------------
-- types
--------------------

Dragon.Type         = {}
Dragon.Type.Head    = {x,y,angle}
Dragon.Type.Segment =
    {x,y,z,image,angle,visible,birthTime,strikeTime,stricken,age,strikeAge}
Dragon.Type.Box     = {x,y,w,h}

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Dragon:init
(               -- called when created instance to initialise it
    mode,       -- mode as [Dragon.Mode]
    complexity  -- complexity [0..1]
)self:doInit(mode,complexity)end

function Dragon:update
(               -- called to make updates and calcs
)self:doUpdate()end

function Dragon:strike
(               -- called to signal that dragon is striken
)self:doStrike()end

function Dragon:setWorthLimitHint
(               -- recommends to limit dragon's worth
    limit       -- recommended maximum worth
)self:doSetWorthLimitHint(limit)end

function Dragon:setBestAgeWorth
(               -- recommends to use dragon's worth in best age
    worth       -- worth in best age
)self:doSetBestAgeWorth(worth)end

function Dragon:updateWorth
(               -- calculates dragon worh based upon stars, age and scale
    starlit     -- total star lights
)self:doUpdateWorth(starlit)end

function Dragon:setMode
(               -- determines dragon kind and behaviour
    mode        -- mode as [Dragon.Mode]
)self:doSetMode(mode)end

function Dragon:setComplexity
(               -- determines dragon kind and behaviour
    complexity  -- complexity as [0..1]
)self:doSetComplexity(complexity)end

--------------------
-- getters
--------------------

function Dragon:getHead       -- Dragon's head as [Dragon.Type.Head]
()return self.head end
function Dragon:getSegments   -- Dragon's body as array of [Dragon.Type.Segment]
()return self.segments end
function Dragon:getTwisting   -- Dragon's segments twisting rate
()return self.twisting end
function Dragon:getScaleRate  -- Dragon's scale rate, used as z-coords
()return self.scaleRate end
function Dragon:getRadius     -- Dragon's radius
()return self.radius end
function Dragon:getAge        -- Dragon's age in seconds
()return self.age end
function Dragon:getLen        -- Dragon's length in segments
()return self.len end
function Dragon:isStricken    -- Whether Dragon is striken
()return self.stricken end
function Dragon:getStrikeAge  -- How long Dragon is striken in seconds
()return self.strikeAge end
function Dragon:getWorth      -- value wich would be applyed to score when it is striked
()return self.worth end
function Dragon:getBox        -- motion bounds as rectangle [Dragon.Type.Box]
()return self:doGetBox()end
function Dragon:getMinRadius  -- minimal available radius
()return self.minRadius end
function Dragon:getMaxRadius  -- maximal available radius
()return self.maxRadius end
function Dragon:getMode       -- mode determines dragon's behaviour
()return self.mode end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Dragon:doInit(mode,complexity)
    self:initConfig     ()
    self:initAttributes (mode,complexity)
    local bestSprites = self.mode == Dragon.Mode.Near
    DragonBase.doInit   (self, bestSprites)
    Events.trigger      (self.initEvent)
end

function Dragon:doUpdate() 
    DragonBase.doUpdate  (self)
    self:updateScaleRate ()
    self:checkAlive      ()
end

function Dragon:doStrike ()
    self.stricken       = true
    self.strikeTime     = DragonBase.time(self)
    self.strikeAge      = 0
end

function Dragon:doGetBox ()
    local w=self.boxWidth*self.scaleRate
    local h=self.boxHeight*self.scaleRate
    local x=self.boxCenter.x-w/2
    local y=self.boxCenter.y-h/2
    return {x=x,y=y,w=w,h=h}
end

function Dragon:doSetWorthLimitHint(limit)
    if self.worthLimitHint==0 then
        self.worthLimitHint = limit
    end
end

function Dragon:doUpdateWorth(starlit)
    if self.stricken then return end
    self.worth = self:calcWorth(starlit)
    Events.trigger(self.rewardEvent, self.worth)
end

function Dragon:doSetMode(m)
    self.mode = m
end

function Dragon:doSetComplexity(c)
    self.complexity = c
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- init
--------------------

function Dragon:initConfig()
    self.minLen               = Dragon.Config.MinLen
    self.maxLen               = Dragon.Config.MaxLen
    self.minFarRadius         = Dragon.Config.MinFarRadius
    self.maxFarRadius         = Dragon.Config.MaxFarRadius
    self.minNearRadius        = Dragon.Config.MinNearRadius
    self.maxNearRadius        = Dragon.Config.MaxNearRadius
    self.minFarIniScaleRate   = Dragon.Config.MinFarIniScaleRate
    self.maxFarIniScaleRate   = Dragon.Config.MaxFarIniScaleRate
    self.minNearIniScaleRate  = Dragon.Config.MinNearIniScaleRate
    self.maxNearIniScaleRate  = Dragon.Config.MaxNearIniScaleRate
    self.maxScaleRate         = Dragon.Config.MaxScaleRate
    self.scaleRateSpeed       = Dragon.Config.ScaleRateSpeed
    self.minScaleRateSpeed    = Dragon.Config.MinScaleRateSpeed
    self.maxScaleRateSpeed    = Dragon.Config.MaxScaleRateSpeed
    self.segmentWorth         = Dragon.Config.SegmentWorth
    self.rewardEvent          = Game.Config.Events.Reward
    self.initEvent            = Game.Config.Events.DragonInit
    self.mode                 = self.mode or Dragon.Config.Mode
    self.complexity           = self.complexity or Dragon.Config.Complexity
end

function Dragon:initAttributes(mode,complexity)
    self.mode           = mode       or self.mode
    self.complexity     = complexity or self.complexity
    self.twisting       = self:calcInitTwisting()
    self.len            = self:calcInitLen()
    self.radius         = self:calcInitRadius()
    self.scaleRate      = self:calcInitScaleRate()
    self.scaleRateSpeed = self:calcInitScaleRateSpeed()
    self.complexy       = 0
    self.worth          = 0
    self.worthLimitHint = 0
    self.stricken       = false
end

--------------------
-- update
--------------------

function Dragon:updateScaleRate()
    if self.stricken then return end
    if self.scaleRate < self.maxScaleRate then
        self.scaleRate = self.scaleRate * self.scaleRateSpeed    
    end
end

--------------------
-- calcs
--------------------

function Dragon:calcInitTwisting()
    return Calc.randomPow(1.45,2.7,1.7)
end
    
function Dragon:calcInitLen()
    return math.random(self.minLen,self.maxLen)
end

function Dragon:calcInitRadius()
    local c = self.complexity
    if self.mode == Dragon.Mode.Far then
        return Calc.between(self.minFarRadius,self.maxFarRadius,1-c)
    elseif self.mode == Dragon.Mode.Near then
        return Calc.between(self.minNearRadius,self.maxNearRadius,c)
    end
end

function Dragon:calcInitScaleRate()
    local c = self.complexity
    local f1,f2,f,n,s,p
    if self.mode == Dragon.Mode.Far then
        p = math.random(10)<=6 and 10 or 1/100
        f1= self.minFarIniScaleRate
        f2= self.maxFarIniScaleRate
        n = self.minNearIniScaleRate
        f = Calc.between(f1,f2,1-c)
        n = Calc.between(f2,n ,0.9)
        s = Calc.randomPow(f,n,p)
        return s
    elseif self.mode == Dragon.Mode.Near then
        f  = self.minNearIniScaleRate
        n  = self.maxNearIniScaleRate
        s  = Calc.between(f,n,c)
        return s
    end
end

function Dragon:calcInitScaleRateSpeed()
    return Calc.randomPow(self.minScaleRateSpeed,self.maxScaleRateSpeed,1.5)
end

--------------------
-- worth
--------------------

function Dragon:calcWorth(starlit)
    local baseWorth    = self:calcBaseWorth()
    local ageWorth     = self:calcAgeWorth()
    local scaleWorth   = self:calcScaleWorth()
    local starlitWorth = self:calcStarlitWorth(starlit)
    worth = baseWorth*ageWorth*scaleWorth*starlitWorth
    worth = worth/10
    worth = math.max(worth,1)
    worth = math.min(worth,self.worthLimitHint)
    worth = math.floor(worth)
    return worth
end

function Dragon:calcBaseWorth()
    local r = self.worthLimitHint
    r = math.log10(r)
    r = math.pow(r,1)
    local worth = r
    return worth
end

function Dragon:calcAgeWorth()
    local r = self.age
    local A = 15
    r = math.max(0,r-0.5)
    r = math.min(1,r/A)
    r = 1-r
    r = math.pow(r,3)
    local worth = 10+300*r
    return worth
end

function Dragon:calcScaleWorth()
    local r = Calc.degree(self.minFarIniScaleRate,self.scaleRate,0.1)
    r = math.min(r,1)
    r = 1-r
    r = math.pow(r,1.5)
    local worth = 10+30*r
    return worth
end

function Dragon:calcStarlitWorth(starlit)
    local worth = 1+30*starlit
    return worth
end

--------------------
-- alive
--------------------

function Dragon:checkAlive ()
    if self.strikeAge > Dragon.Config.TimeAfterStrike then
        self:init ()
    end
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
