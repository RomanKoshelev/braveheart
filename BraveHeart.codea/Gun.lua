-- gun.lua 
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Gun -- Game-scheme's element that generates shots 
    = class(Person)

--------------------
-- mode
--------------------

Gun.Mode                   = {}
Gun.Mode.Hunting           = "hunting"
Gun.Mode.Defence           = "defence"

--------------------
-- config
--------------------

Gun.Config                 = {}
Gun.Config.MaxShotNum      = 200
Gun.Config.ChargeDuration  = 0.1
Gun.Config.Mode            = Gun.Mode.Defence

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Gun:init
(               -- called when created instance to initialise it
    mode        -- mode as [Gun.Mode]
)self:doInit(mode)end

function Gun:update
(               -- called to make updates and calcs
)self:doUpdate()end

function Gun:fire
(               -- called to make a shot if it is possible
    x,y         -- shot's coords
)self:doFire(x,y)end

function Gun:stopAll
(               -- deactivates all shots
)self:doStopAll()end

function Gun:setComplexity
(               -- take efffect on motion
    complexity  -- complexity as [0..1]
)self:doSetComplexity(complexity)end

function Gun:setMode
(               -- determines shots behaviour
    mode        -- mode as [Gun.Mode]
)self:doSetMode(mode)end

--------------------
-- getters
--------------------

function Gun:getShots  -- Gun's shots as array of [Shot]
()return self.shots end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Gun:doInit(mode)
    self:initConfig    ()
    self:initAttributes(mode)
    self:createElements()
end

function Gun:doUpdate()
    self:updateShots()
    self:updateTimer()
end

function Gun:doFire(x,y)
    if self:isCharged() then
        self:activateShotIfPossible(x,y) 
    end
end

function Gun:doSetComplexity(c)
    for _,shot in pairs(self.shots) do
        shot:setComplexity(c)
    end   
end

function Gun:doSetMode(m)
    self.mode = m
    local sMode = self:shotMode()
    for _,shot in pairs(self.shots) do
        shot:setMode(sMode)
    end   
end

function Gun:doStopAll()
    for _,shot in pairs(self.shots) do
        shot:deactivate()
    end   
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function Gun:createElements()
    self:createShots()
    self:initTimer  ()
end

function Gun:initConfig()
    self.maxShotNum     = Gun.Config.MaxShotNum
    self.chargeDuration = Gun.Config.ChargeDuration
    self.mode           = self.mode or Gun.Config.Mode
end

function Gun:initAttributes(mode)
    self.mode           = mode or self.mode
end

--------------------
-- timer
--------------------

function Gun:initTimer()
    self.timer = Timer()
end

function Gun:updateTimer()
    self.timer:onTick()
end

function Gun:time()
    return ElapsedTime
end

--------------------
-- shots
--------------------

function Gun:createShots()
    local sMode = self:shotMode()
    self.shots = {} 
    for i=1,self.maxShotNum do
        self.shots[i] = Shot(sMode)
    end
end

function Gun:updateShots()
    for _,shot in pairs(self.shots) do 
        if shot:isActive() then
            shot:update()
        end
    end   
end

function Gun:activateShotIfPossible(x,y)
    local n = self.maxShotNum
    for i=1,n do
        shot = self.shots[i]
        if shot:activateIfPossible(x,y) then
            for j=i,n-1,1 do
                self.shots[j]=self.shots[j+1]
            end
            self.shots[n]=shot
            return
        end
    end
end

function Gun:shotMode()
    -- return Shot.Mode.Ballistic
    return self.mode == Gun.Mode.Hunting and Shot.Mode.Ballistic or Shot.Mode.Straight
end 

--------------------
-- charge
--------------------

function Gun:isCharged()
    local duration = self:time() - (self.prevShotAttempt or 0)
    if  duration > self.chargeDuration then
        self.prevShotAttempt = self:time()
        return true
    end
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------  
