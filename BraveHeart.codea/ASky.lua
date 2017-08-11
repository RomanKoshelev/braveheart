-- asky.lua
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

ASky -- Sky's actor aimed to show stars
    = class(Actor)

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function ASky:init
(               -- represents some scheme's person on stage
    person,     -- person to show on stage
    stage,      -- place where to show 
    plotter     -- helper provides draw function and scaling/panning
)self:doInit(person,stage,plotter)end

function ASky:onDraw
(               -- called to draw all what needs
)self:doOnDraw()end

function ASky:update
(               -- called to update info from person
)self:doUpdate()end

------------------------------------------------------------------------------------------
-- implements
------------------------------------------------------------------------------------------

function ASky:doInit(person,stage,plotter)
    Actor.doInit(self,person,stage,plotter)
    self:createElements()
end

function ASky:doUpdate()
    self:updateStars()
end

function ASky:doOnDraw()
    self:drawStars()
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function ASky:createElements()
    self:createStars()
end

function ASky:createStars()
    self.stars={}
    for _,star in ipairs(self.person:getStars()) do
        table.insert(self.stars, AStar(star,self.stage,self.plotter))
    end   
end

function ASky:drawStars()
    for _,star in ipairs(self.stars) do
        star:onDraw()
    end   
end

function ASky:updateStars()
    for _,star in ipairs(self.stars) do
        star:update()
    end   
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
