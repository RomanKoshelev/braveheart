-- agun.lua
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

AGun -- Gun's actor aimed to interacive with player
    = class(Actor)

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function AGun:init
(               -- represents some scheme's person on stage
    person,     -- person to show on stage
    stage,      -- place where to show 
    plotter     -- helper provides draw function and scaling/panning
)self:doInit(person,stage,plotter)end

function AGun:onTouch
(               -- called to proc touching
    touch       -- Codea Touch structure, contains info about touching
)self:doOnTouch(touch)end

function AGun:onDraw
(               -- called to draw all what needs
)self:doOnDraw()end

function AGun:drawNearShots
(               -- called to draw shots wich scaleRate is more than argument
    scaleRate
)self:doDrawNearShots(scaleRate)end

function AGun:drawFarShots
(               -- called to draw shots wich scaleRate is less than argument
    scaleRate
)self:doDrawFarShots(scaleRate)end

function AGun:update
(               -- called to update info from person
)self:doUpdate()end

------------------------------------------------------------------------------------------
-- implements
------------------------------------------------------------------------------------------

function AGun:doInit(person,stage,plotter)
    Actor.doInit(self,person,stage,plotter)
    self:createElements()
end

function AGun:doUpdate()
    self:updateShots()
end

function AGun:doOnTouch(t)
    if t.state == BEGAN or t.state == MOVING then 
        self.person:fire(t.x,t.y) 
    end
end

function AGun:doOnDraw()
    self:drawShots()
end

function AGun:doDrawNearShots(sr)
    for _,shot in pairs(self.shots) do
        if shot:getScaleRate()>=sr then
            shot:onDraw()
        end
    end   
end

function AGun:doDrawFarShots(sr)
    for _,shot in pairs(self.shots) do
        if shot:getScaleRate()<sr then
            shot:onDraw()
        end
    end   
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function AGun:createElements()
    self:createShots()
end

function AGun:createShots()
    self.shots={}
    for _,shot in pairs(self.person:getShots()) do
        table.insert(self.shots, AShot(shot,self.stage,self.plotter))
    end   
end

function AGun:drawShots()
    for _,shot in ipairs(self.shots) do
        shot:onDraw()
    end   
end

function AGun:updateShots()
    for i,shot in ipairs(self.shots) do
        local newPerson = self.person:getShots()[i]
        shot:setPerson(newPerson)
        shot:update()
    end   
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
