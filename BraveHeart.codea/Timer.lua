-- timer.lua
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Timer -- helper aimed for keep time synchronized between game objects
    = class()

--------------------
-- config
--------------------

Timer.Config             = {}
Timer.Config.DefaultRate = 1/60

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Timer:init(rate)
    self.startTime = ElapsedTime
    self.tickNum   = 0
    self.timeRate  = rate or Timer.Config.DefaultRate
end

function Timer:onTick()
    self.tickNum = self.tickNum + 1
end

function Timer:time()
    return self.startTime + self.tickNum * self.timeRate
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
