-- scheme.lua
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Scheme -- contains game objects and responds for game logics without presentation aspects
    = class()

--------------------
-- mode
--------------------

Scheme.Mode                                = {}
Scheme.Mode.Hunting                        = "hunting"
Scheme.Mode.Defence                        = "defence"

--------------------
-- config
--------------------

Scheme.Config                              = {}
Scheme.Config.Storagekeys                  = {}
Scheme.Config.Storagekeys.TotalScore       = "Scheme.TotalScore"
Scheme.Config.Storagekeys.BestShot         = "Scheme.BestShot"
Scheme.Config.Storagekeys.ShotNum          = "Scheme.ShotNum"
Scheme.Config.Storagekeys.DragonNum        = "Scheme.DragonNum"
Scheme.Config.Storagekeys.HeartNum         = "Scheme.HeartNum"
Scheme.Config.MinDragonLimitHint           = 1*1000
Scheme.Config.MinDecreasedScore            = 10*1000
Scheme.Config.MaxStrikePrecisionTolerance  = 1.2
Scheme.Config.MaxHuntingPrecisionScale     = 0.15
Scheme.Config.IniHeartNum                  = 3
Scheme.Config.MaxHeartNum                  = 25 --25
Scheme.Config.Mode                         = Scheme.Mode.Hunting
Scheme.Config.DefenceModeProbability       = 0.5
Scheme.Config.Complexity                   = 0.0
Scheme.Config.MaxFreeShotNum               = 5000 --3000
Scheme.Config.MaxFreeHeartNum              = 12 --12


------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Scheme:init
(               -- called when created instance to initialise it
)self:doInit()end

function Scheme:onTick
(               -- called to make updates and calcs
)self:doOnTick()end

--------------------
-- getters
--------------------

function Scheme:getDragon       -- Scheme's dragon person
()return self.dragon end 
function Scheme:getGun          -- Scheme's gun person
()return self.gun end
function Scheme:getSky          -- Scheme's sky person
()return self.sky end
function Scheme:getHeart        -- Scheme's silly heart person
()return self.heart end
function Scheme:getScore        -- Total players's score including current reward
()return self:doGetScore() end
function Scheme:getLastReward   -- Last reward
()return self.lastReward end
function Scheme:getBestShot     -- Best shot
()return self.bestShot end

------------------------------------------------------------------------------------------
-- events
------------------------------------------------------------------------------------------

function Scheme:bindEvents()
    Events.bind(Game.Config.Events.Shot,          self, Scheme.onShot)
    Events.bind(Game.Config.Events.Reset,         self, Scheme.onResetGame)
    Events.bind(Game.Config.Events.HeartIncrease, self, Scheme.onHeartIncrease)
    Events.bind(Game.Config.Events.HeartDecrease, self, Scheme.onHeartDecrease)
    Events.bind(Game.Config.Events.HeartStolen,   self, Scheme.onHeartStolen)
end

function Scheme:onShot(...)
    return self:doOnShot(unpack({...}))
end

function Scheme:onShotCost(...)
    return self:doOnShotCost(unpack({...}))
end

function Scheme:onHeartIncrease(...)
    return self:doOnHeartIncrease(unpack({...}))
end

function Scheme:onHeartDecrease(...)
    return self:doOnHeartDecrease(unpack({...}))
end

function Scheme:onHeartStolen(...)
    return self:doOnHeartStolen(unpack({...}))
end

function Scheme:onResetGame(...)
    return self:doOnResetGame(unpack({...}))
end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Scheme:doInit()
    self:initConfig      ()
    self:initAttributes  ()
    self:updateComplexity()
    self:createElements  ()
    self:bindEvents      ()
    self:setInitialMode  ()
    self:balanceGame     ()
end

function Scheme:doOnTick()
    self.dragon:update          ()
    local dx    = self.dragon:getHead().x
    local dy    = self.dragon:getHead().y
    local dr    = self.dragon:getRadius()*self.dragon:getScaleRate()
    local ds    = self.dragon:getScaleRate()
    self.sky:update             (dx,dy,dr)
    self.heart:update           (dx,dy,dr,ds)
    local sl = self.sky:getStarlit()
    self:updateGun              ()
    self:checkDragonShotStrike  ()
    self.sky:canUpdateStars     (not self.dragon:isStricken())
    self.heart:canUpdateIncrease(not self.dragon:isStricken())
    self:calcCanFire()
    Events.trigger(self.shotNumEvent, self.shotNum)
    Events.trigger(Game.Config.Events.CanFire, self.canFire)
    if (self.needUpdateHeatNum or true) then
        Events.trigger(self.heartNumEvent, self.heartNum)
        self.needUpdateHeatNum = false
    end
end

function Scheme:calcCanFire()
    if Main.Config.FullVersion then
        self.canFire = true
    else
        self.canFire = self.shotNum < Scheme.Config.MaxFreeShotNum
    end
end

function Scheme:doOnShot()
    self.shotNum = self.shotNum + 1
    if not Main.Config.FullVersion then
        self.shotNum = math.min(self.shotNum, Scheme.Config.MaxFreeShotNum)
    end
    Events.trigger(self.shotNumEvent, self.shotNum)
    Events.trigger(Game.Config.Events.CanFire, self.canFire)
    self:saveShotNum ()
end

function Scheme:doOnHeartIncrease(x,y)
    self.heartNum = math.min(self.maxHeartNum, self.heartNum + 1)
    Events.trigger(self.heartNumEvent, self.heartNum, x,y)
    self:saveHeartNum ()
end

function Scheme:doOnHeartDecrease()
    self.heartNum = math.max(0,self.heartNum - 1)
    Events.trigger(self.heartNumEvent, self.heartNum, 0,0)
    self:saveHeartNum ()
end

function Scheme:doOnHeartStolen()
    if not Main.Config.FullVersion then
        self.heartNum = math.min(self.heartNum, Scheme.Config.MaxFreeHeartNum)
        self:saveHeartNum ()
    end
end

function Scheme:doOnResetGame()
    self.bestShot   = 0
    self.totalScore = 0
    self.shotNum    = 0
    self.dragonNum  = 0
    self.heartNum   = self.iniHeartNum
    Events.trigger(self.bestShotEvent,   self.bestShot)
    Events.trigger(self.totalScoreEvent, self.totalScore)
    Events.trigger(self.shotNumEvent,    self.shotNum)
    Events.trigger(self.dragonNumEvent,  self.dragonNum)
    Events.trigger(self.heartNumEvent,   self.heartNum)
    self:saveBestShot  ()
    self:saveTotalScore()
    self:saveShotNum   ()
    self:saveDragonNum ()
    self:saveHeartNum  ()
end

function Scheme:doGetScore()
    return self.totalScore+self.curReward
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function Scheme:initConfig()
    self.lastShotEvent            = Game.Config.Events.LastShot
    self.bestShotEvent            = Game.Config.Events.BestShot
    self.bestShotSoundEvent       = Game.Config.Events.BestShotSound
    self.totalScoreEvent          = Game.Config.Events.TotalScore
    self.shotEvent                = Game.Config.Events.Shot
    self.shotNumEvent             = Game.Config.Events.ShotNum
    self.dragonNumEvent           = Game.Config.Events.DragonNum
    self.heartNumEvent            = Game.Config.Events.HeartNum
    self.dragonStrikeEvent        = Game.Config.Events.DragonStrike
    self.showRadarEvent           = Game.Config.Events.ShowRadar
    self.totalScoreStorageKey     = Scheme.Config.Storagekeys.TotalScore
    self.shotNumStorageKey        = Scheme.Config.Storagekeys.ShotNum    
    self.dragonNumStorageKey      = Scheme.Config.Storagekeys.DragonNum    
    self.heartNumStorageKey       = Scheme.Config.Storagekeys.HeartNum    
    self.bestShotStorageKey       = Scheme.Config.Storagekeys.BestShot
    self.minDragonLimitHint       = Scheme.Config.MinDragonLimitHint
    self.minDecreasedScore        = Scheme.Config.MinDecreasedScore
    self.strikePrecisionTolerance = Scheme.Config.MaxStrikePrecisionTolerance
    self.iniHeartNum              = Scheme.Config.IniHeartNum
    self.maxHeartNum              = Scheme.Config.MaxHeartNum
    self.maxEasyShotNum           = Scheme.Config.MaxEasyShotNum
    self.freeShotNum              = Scheme.Config.MaxFreeShotNum
    self.mode                     = Scheme.Config.Mode
    self.complexity               = Scheme.Config.Complexity
    self.defenceModeProbability   = Scheme.Config.DefenceModeProbability
    self.maxHuntingPrecisionScale = Scheme.Config.MaxHuntingPrecisionScale
end

function Scheme:initAttributes()
    self.totalScore = self:readTotalScore()
    self.bestShot   = self:readBestShot()
    self.shotNum    = self:readShotNum()
    self.dragonNum  = self:readDragonNum()
    self.heartNum   = self:readHeartNum()
    self.complexity = self:calcComplexity()
    self.curReward  = 0
    self.lastReward = 0
    self.canFire    = true
end

function Scheme:createElements()
    local hunting = self.mode==Scheme.Mode.Hunting
    local c       = self.complexity
    local dMode   = hunting and Dragon.Mode.Far   or Dragon.Mode.Near
    local hMode   = hunting and Heart.Mode.Quiet  or Heart.Mode.Warlike
    local gMode   = hunting and Gun.Mode.Hunting  or Gun.Mode.Defence
    self.dragon   = Dragon(dMode,c)
    self.gun      = Gun   (gMode)
    self.sky      = Sky   ()
    self.heart    = Heart (hMode)
end

--------------------
-- update
--------------------

function Scheme:updateGun()
    self.gun:update ()
end

--------------------
-- round
--------------------

function Scheme:initNewRound()
    if self.mode == Scheme.Mode.Defence then
        if not self.heart:isActive() then
            self:setHuntingMode()
        end
    elseif self.mode == Scheme.Mode.Hunting then
        if self:needDefenceMode() then
            self:setDefenceMode()
        end
    end
    self:balanceGame ()
end

--------------------
-- mode
--------------------

function Scheme:needDefenceMode()
    return math.random(100)/100 <= self.defenceModeProbability
end

function Scheme:setInitialMode()
    if self.mode == Scheme.Mode.Defence then
        self:setDefenceMode()
    elseif self.mode == Scheme.Mode.Hunting then
        self:setHuntingMode()
    end
end

function Scheme:setHuntingMode()
    self.mode = Scheme.Mode.Hunting
    self.dragon:setMode(Dragon.Mode.Far)
    self.heart:setMode (Heart.Mode.Quiet)
    self.gun:stopAll   ()
    self.gun:setMode   (Gun.Mode.Hunting)
end

function Scheme:setDefenceMode()
    self.mode = Scheme.Mode.Defence
    self.dragon:setMode(Dragon.Mode.Near)
    self.heart:setMode (Heart.Mode.Warlike)
    self.gun:stopAll   ()
    self.gun:setMode   (Gun.Mode.Defence)
end

--------------------
-- balance
--------------------

function Scheme:balanceGame()
    self:updateComplexity   ()
    self:setDragonWorthLimit()
    self:setHeartComplexity ()
    self:setGunComplexity   ()
    self:setDragonComplexity()
end

function Scheme:setHeartComplexity()
    local c = self.complexity
    c = math.pow(c, .2)
    self.heart:setComplexity(c)
end

function Scheme:setGunComplexity()
    local c = self.complexity
    self.gun:setComplexity(c)
end

function Scheme:setDragonComplexity()
    local c = self.complexity
    c = math.pow(c, 4.)
    self.dragon:setComplexity(c)
end

function Scheme:setDragonWorthLimit()
    -- todo base on complexity, not on score
    local d = self.minDragonLimitHint
    local k = Calc.randomPow(0.10,0.25,1)
    local limit = k*(math.max(d,self.totalScore))
    self.dragon:setWorthLimitHint(limit)
end

--------------------
-- complexity
--------------------

function Scheme:updateComplexity()
    self.complexity = self:calcComplexity()
end

function Scheme:calcComplexity()
    local k = self.heartNum
    k = Calc.degree(0,k,self.maxHeartNum)
    k = math.max(k,0)
    k = math.min(k,1)
    k = math.pow(k,.9)
    return k
end

--------------------
-- strike
--------------------

function Scheme:checkDragonShotStrike()
    local dhead  = self.dragon:getHead()
    local dscale = self.dragon:getScaleRate()
    local dpos,dr=vec2(dhead.x,dhead.y),self.dragon:getRadius()*self.dragon:getScaleRate()
    for _,shot in pairs(self.gun:getShots()) do
        if shot:isActive() then
            local sscale  = shot:getScaleRate()
            local spos    = vec2(shot:getPosition())
            local sr      = shot:getRadius()*sscale
            local sprogr  = shot:getProgress()
            local dist    = spos:dist(dpos)
            if dist <= dr+sr then
                if self:scaleRatesDragonStarAreClose(dscale,sscale,sprogr) then
                    self:dragonStrike(shot)
                end
            end
        end
    end
end

function Scheme:scaleRatesDragonStarAreClose(sd,ss,sp)
    local k  = math.max(sd,ss)/math.min(sd,ss)
    local t  = self.strikePrecisionTolerance
    local s  = self.maxHuntingPrecisionScale
    local d  = math.pow(Calc.degree(s,sd,0.5),1)
    local kt = Calc.between(1,2,d)
    if self.mode==Scheme.Mode.Hunting then
        t = t*kt
    end
    if k<t then
        return true
    elseif sd>0.80 and sp<0.3 then
        return true
    elseif sd>0.90 and sp<0.5 then
        return true
    end
    return false
end

function Scheme:dragonStrike(shot)
    if self.dragon:isStricken() then return end
    local reward = self.dragon:getWorth()
    self:initNewRound         ()
    self:storeRewardOnStrike  (reward)
    self:storeBestShot        (reward)
    self.dragon:strike        ()
    self:synchronizeTotalScore()
    shot:deactivate()
    self.dragonNum = self.dragonNum + 1
    self:saveDragonNum()
    Events.trigger(self.lastShotEvent,     self.curReward)
    Events.trigger(self.dragonStrikeEvent, self.dragon)
    Events.trigger(self.shotNumEvent,      self.shotNum)
end

--------------------
-- scores
--------------------

function Scheme:updateScoresByReward()
    if self.curReward and not self.dragon:isStricken() and self.curReward>0 then
        self.totalScore = math.floor(self.totalScore + self.curReward)
        self.bestShot   = math.max(self.bestShot,self.curReward)
        self.curReward  = 0
    end
end

function Scheme:storeRewardOnStrike(reward)
    self.curReward  = reward
    self.lastReward = reward
end

function Scheme:decreaseTotalScoreOnShot(cost)
    if self.totalScore > self.minDecreasedScore then
        self.totalScore = math.max(0, self.totalScore - cost)
    end
end

function Scheme:storeBestShot(reward)
    if reward > self.bestShot then
        self:saveBestShot(reward)
        Events.trigger(self.bestShotSoundEvent)
    end
end

function Scheme:synchronizeTotalScore()
    Events.trigger(self.totalScoreEvent, self.totalScore)
    Events.trigger(self.bestShotEvent,   self.bestShot)
    Events.trigger(self.shotNumEvent,    self.shotNum)
    Events.trigger(self.dragonNumEvent,  self.dragonNum)
    Events.trigger(self.heartNumEvent,   self.heartNum)
    self:saveTotalScore ()
end

--------------------
-- storage
--------------------

function Scheme:readTotalScore()
    return readLocalData(self.totalScoreStorageKey,0)
end
function Scheme:saveTotalScore()
    saveLocalData(self.totalScoreStorageKey,self.totalScore)
end

function Scheme:readBestShot()
    return readLocalData(self.bestShotStorageKey,0)
end
function Scheme:saveBestShot(bs)
    bs = bs or self.bestShot
    saveLocalData(self.bestShotStorageKey,bs)
end

function Scheme:readShotNum()
    return readLocalData(self.shotNumStorageKey,0)
end
function Scheme:saveShotNum()
    saveLocalData(self.shotNumStorageKey,self.shotNum)
end

function Scheme:saveDragonNum()
    saveLocalData(self.dragonNumStorageKey,self.dragonNum)
end
function Scheme:readDragonNum()
    return readLocalData(self.dragonNumStorageKey,0)
end

function Scheme:readHeartNum()
    return readLocalData(self.heartNumStorageKey,self.iniHeartNum)
end
function Scheme:saveHeartNum()
    saveLocalData(self.heartNumStorageKey,self.heartNum)
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
