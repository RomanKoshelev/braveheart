-- heart.lua 
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Heart -- Controls logic of silly heart in the game's scheme
    = class(Person)

--------------------
-- mode
--------------------

Heart.Mode                       = {}
Heart.Mode.Quiet                 = "quiet"
Heart.Mode.Warlike               = "warlike"

--------------------
-- config
--------------------

Heart.Config                     = {}
Heart.Config.MinIncreaseDistance =  2
Heart.Config.MaxIncreaseDistance = 400
Heart.Config.Size                =  50
Heart.Config.Mode                =  Heart.Mode.Quiet

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Heart:init
(               -- called when created instance to initialise it
    mode        -- mode as [Heart.Mode]
)self:doInit(mode)end

function Heart:update
(               -- called to make updates and calcs
    dx,dy,dr,   -- dragon's coords and radius
    ds          -- dragon's scale
)self:doUpdate(dx,dy,dr,ds)end

function Heart:canUpdateIncrease
(               -- enables or disables to update increase
    flag        -- flag shows updating possibility
)self:doCanUpdateIncrease(flag)end

function Heart:setComplexity
(               -- take efffect on increaseDistance
    complexity  -- game complexity as [0..1]
)self:doSetComplexity(complexity)end

function Heart:setMode
(               -- determines heart's behaviour
    mode        -- mode as [Heart.Mode]
)self:doSetMode(mode)end

--------------------
-- getters
--------------------

function Heart:getPosition     -- heart coords as [x,y]
()return self.x,self.y end
function Heart:getBeatrate     -- heart beat rate as [0..1]
()return self.lightRate end
function Heart:getScaleRate    -- heart's scale as [0..1]
()return self.scaleRate end
function Heart:getSize         -- heart's size
()return self.size end
function Heart:isActive        -- is heart in game
()return self.active end
function Heart:getIncreaseFlag -- whether heart will be burn if strike the dragon
()return self.increaseFlag end
function Heart:getIncreaseRate -- used for visualization of increase factor
()return self.increaseRate end

------------------------------------------------------------------------------------------
-- events
------------------------------------------------------------------------------------------

function Heart:bindEvents()
    Events.bind(Game.Config.Events.DragonStrike, self, Heart.onDragonStrikeEvent)
    Events.bind(Game.Config.Events.DragonInit,   self, Heart.onDragonInitEvent)
end

function Heart:onDragonStrikeEvent(...)
    return self:doOnDragonStrikeEvent(unpack({...}))
end

function Heart:onDragonInitEvent(...)
    return self:doOnDragonInitEvent(unpack({...}))
end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Heart:doInit(mode)
    self:initConfig     ()
    self:initAttributes (mode)
    self:bindEvents     ()
    self:activate       ()
end

function Heart:doUpdate(dx,dy,dr,ds)
    if not self.active then return end
    self.scaleRate = self:calcNewScaleRate(ds)
    self.x         = self:calcNewCoord    (self.x, dx,ds)
    self.y         = self:calcNewCoord    (self.y, dy,ds)
    self:updateIncreaseInfo(dx,dy,dr)
end

function Heart:doCanUpdateIncrease(flag)
    self.canUpdateIncreaseFlag = flag
end

function Heart:doOnDragonStrikeEvent()
    if self.active and self.increaseFlag then
        Events.trigger(self.increaseEvent, self.x, self.y)
        sound("A Hero's Quest:Level Up")
    end
end

function Heart:doOnDragonInitEvent()
    self:activate()
end

function Heart:doSetComplexity(c)
    self.complexity = c
end

function Heart:doSetMode(m)
    self.mode = m
    if self.mode==Heart.Mode.Quiet then
        self:deactivate()
    end
    if self.mode==Heart.Mode.Warlike then
        self:activate()
    end
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- init
--------------------

function Heart:initConfig()
    self.size              = Heart.Config.Size
    self.minIncreaseDist   = Heart.Config.MinIncreaseDistance
    self.maxIncreaseDist   = Heart.Config.MaxIncreaseDistance
    self.increaseEvent     = Game.Config.Events.HeartIncrease
    self.decreaseEvent     = Game.Config.Events.HeartDecrease
    self.mode              = self.mode or Heart.Config.Mode
end

function Heart:initAttributes(mode)
    self.mode         = mode or self.mode
    self.x            = 0
    self.y            = HEIGHT
    self.active       = self.mode==Heart.Mode.Warlike
    self.beatrate     = 0
    self.scaleRate    = 1
    self.increaseFlag = false
    self.increaseRate = 0.0
    self.complexity   = 0
end

--------------------
-- coords
--------------------

function Heart:calcNewCoord(hc,dc,ds)
    local s = 0.01
    local d = (dc-hc)+self.size/2
    ds = math.pow(ds, 1/7)
    hc = hc + d*s*ds
    return hc
end

function Heart:calcNewScaleRate(ds)
    ds = Calc.between(0.2,0.7,ds)
    local hs= self.scaleRate
    local s = 0.1
    local d = (ds-hs)
    hs = hs + d*s
    return hs
end

--------------------
-- increase
--------------------

function Heart:updateIncreaseInfo(dx,dy,dr)
    if not self.canUpdateIncreaseFlag then return end
    local sc  = self.scaleRate
    local D   = self:calcIncreaseDist()
    local x,y = self.x,self.y
    local cc  = vec2(x,y):dist(vec2(dx,dy))
    local hr  = self.size/2*sc
    local d   = cc-dr-hr
    local r   = 1-Calc.degree(0,d,D)
    if d<=0 then
        self:onDestroyed()
    elseif d > D then
        self.increaseFlag  = false
        self.increaseRate  = 0
    else
        if not self.increaseFlag then
            sound("A Hero's Quest:Sword Hit 2")
        end
        self.increaseFlag  = true
        self.increaseRate  = r
    end
end

function Heart:calcIncreaseDist()
    local r = self.complexity
    r = 1-r
    local d = Calc.between(self.minIncreaseDist,self.maxIncreaseDist,r)
    return d
end

--------------------
-- activity
--------------------

function Heart:onDestroyed()
    self:deactivate()
    sound("A Hero's Quest:Monster Noise 3")
    tween.delay(0.5,function() 
        sound("Game Sounds One:Crowd Sad 2") end)
end

function Heart:deactivate()
    self.increaseFlag  = false
    self.increaseRate  = 0
    self.active        = false
end

function Heart:activate()
    if self.active                   then return end
    if self.mode == Heart.Mode.Quiet then return end
    self.increaseFlag  = false
    self.increaseRate  = 0
    self.active        = true
    self.scaleRate     = 1
    self.x             = 0
    self.y             = HEIGHT
    tween.delay(0.5,function() 
        sound("Game Sounds One:Crowd Cheer 2") end)
    Events.trigger(self.decreaseEvent)
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
