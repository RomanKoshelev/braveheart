-- shot.lua 
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Shot -- Controls gun's shots logicaly in the game's scheme
    = class(Person)

--------------------
-- mode
--------------------

Shot.Mode                  = {}
Shot.Mode.Straight         = "straight"
Shot.Mode.Ballistic        = "ballistic"

--------------------
-- config
--------------------

Shot.Config                = {}
Shot.Config.MinDuration    = 0.75
Shot.Config.MaxDuration    = 1.50
Shot.Config.MinRadius      = 50
Shot.Config.MaxRadius      = 75
Shot.Config.SoundEvent     = "Shot.Sound"
Shot.Config.Cost           = Pack.Balance.ShotCost
Shot.Config.Mode           = Shot.Mode.Straight

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Shot:init
(               -- called when created instance to initialise it
    mode        -- mode as [Shot.Mode]
)self:doInit(mode)end

function Shot:update
(               -- called to make updates and calcs
)self:doUpdate()end

function Shot:activateIfPossible
(               -- shot will be activated as just fired if not active yet
    x,y         -- shot coords
)               -- returns true if activated
return self:doActivateIfPossible(x,y)end

function Shot:deactivate
(               -- makes shot ignored and invisible
)self:doDeactivate()end

function Shot:setComplexity
(               -- take efffect on motion
    complexity  -- game complexity as [0..1]
)self:doSetComplexity(complexity)end

function Shot:setMode
(               -- determines shot's ballistic
    mode        -- mode as [Shot.Mode]
)self:doSetMode(mode)end

--------------------
-- getters
--------------------

function Shot:getProgress    -- Value between 0..1 indicates relative duration of shot
()return self.progress end
function Shot:getPosition    -- shot coords as [x,y]
()return self.x,self.y end
function Shot:isActive       -- is shot in progress
()return self.active end
function Shot:getSoundEvent  -- sound event (rised when need to play sound) as string
()return self.soundEvent end
function Shot:getRadius      -- radius in which goal objects must be destroyed
()return self.radius end
function Shot:getScaleRate   -- Shot's scale rate, used as z-coords
()return self.scaleRate end
function Shot:getMode        -- mode determines shot's ballistic
()return self.mode end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Shot:doInit(mode)
    self:initConfig    ()
    self:initAttributes(mode)
    self:initTimer     ()
end

function Shot:doActivateIfPossible(x,y)
    if not self.active then
        self:activate(x,y)
        return true
    end
    return false
end

function Shot:doUpdate()
    self:updateTimer    ()
    self:updateProgress ()
    self:updateDuration ()
    self:updateCoords   ()
    self:updateScaleRate()
    self:updateActivity ()
end

function Shot:doSetComplexity(c)
    self.complexity  = c
    self.duration    = self:calcDuration()
    self.radius      = self:calcRadius  ()
end

function Shot:doDeactivate()
    self.active = false
end

function Shot:doSetMode(m)
    self.mode = m
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- init
--------------------

function Shot:initConfig()
    self.minDuration        = Shot.Config.MinDuration
    self.maxDuration        = Shot.Config.MaxDuration
    self.soundEvent         = Shot.Config.SoundEvent
    self.minRadius          = Shot.Config.MinRadius
    self.maxRadius          = Shot.Config.MaxRadius
    self.cost               = Shot.Config.Cost
    self.costEvent          = Game.Config.Events.ShotCost
    self.deactivationEvent  = Game.Config.Events.ShotDeactivated
    self.mode               = self.mode or Shot.Config.Mode
end

function Shot:initAttributes(mode)
    self.mode          = mode or self.mode
    self.progress      = 0
    self.active        = false
    self.x0,self.y0    = nil,nil
    self.x,self.y      = nil,nil
    self.complexity    = 0
    self.duration      = self:calcDuration()
    self.radius        = self:calcRadius  ()
end

--------------------
-- updates
--------------------

function Shot:updateProgress ()
    self.progress  = self:calcProgress()
end

function Shot:updateDuration ()
    self.duration  = self:calcDuration()
end

function Shot:updateScaleRate()
    self.scaleRate = self:calcScaleRate()
end

function Shot:updateCoords()
    local dy = self:calcAscent()
    self.y = self.y0 + dy
end

function Shot:updateActivity()
    if self.progress>=1 then
        self.active = false
        if self.mode == Shot.Mode.Ballistic then
            if self.y > 300 then
                Events.trigger(self.deactivationEvent,self.x,self.y)
            end
        end
    end
end

--------------------
-- timer
--------------------

function Shot:initTimer()
    self.timer = Timer()
end

function Shot:updateTimer()
    self.timer:onTick()
end

function Shot:time()
    return ElapsedTime
end

--------------------
-- activation
--------------------

function Shot:activate(x,y)
    self.active     = true
    self.x0,self.y0 = x,y
    self.x,self.y   = x,y
    self.startTime  = self:time()
    self.progress   = 0
    self.scaleRate  = self:calcScaleRate()
    Events.trigger(self.soundEvent, self)
    Events.trigger(self.costEvent,  self.cost)
end

--------------------
-- calcs
--------------------

function Shot:calcDuration()
    local c = math.pow(self.complexity,0.9)
    local d = Calc.between(self.minDuration,self.maxDuration,c)
    return d
end

function Shot:calcRadius()
    local c = 1-self.complexity
    local r = Calc.between(self.minRadius,self.maxRadius,c)
    return r
end
    
function Shot:calcScaleRate()
    local p = self.progress
    sr = 1-math.pow(p,1/4)
    return sr
end

function Shot:calcProgress()
    if not self.active then return 0 end
    return (self:time() - self.startTime) / self.duration
end

--------------------
-- coords
--------------------

function Shot:calcAscent()
    local p = self.progress
    local t = self.duration
    local A = self.mode == Shot.Mode.Straight and 200 or 400 -- Calc.between(100, 700*k,c)
    local B = self.mode == Shot.Mode.Straight and 150 or 300 -- Calc.between( 50, 500*k,c)

    local v = A*math.pow(p,1) - B*math.pow(p,2)
    return 30+ v*t
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
