-- sky.lua 
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Sky -- Game-scheme's element that generates and controls stars 
    = class(Person)

--------------------
-- config
--------------------

Sky.Config                 = {}
Sky.Config.MaxStarNum      = 64

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Sky:init
(               -- called when created instance to initialise it
)self:doInit()end

function Sky:update
(               -- called to make updates and calcs
    dx,dy,dr    -- dragon's coords and radius
)self:doUpdate(dx,dy,dr)end

function Sky:canUpdateStars
(               -- enables or disables Sky to update stars
    flag        -- flag shows updating possibility
)self:doCanUpdateStars(flag)end

--------------------
-- getters
--------------------

function Sky:getStars   -- Sky's stars as array of [Star]
()return self.stars end
function Sky:getStarlit -- Sky stars' light
()return self.starlit end
function Sky:getStarNum -- Sky stars num
()return self.starNum end

------------------------------------------------------------------------------------------
-- events
------------------------------------------------------------------------------------------

function Sky:bindEvents()
    Events.bind(Game.Config.Events.ShotDeactivated,  self, Sky.onShotDeactivated)
end

function Sky:onShotDeactivated(...)
    return self:doOnShotDeactivated(unpack({...}))
end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Sky:doInit()
    self:initConfig    ()
    self:initAttributes()
    self:createElements()
    self:bindEvents    ()
end

function Sky:doUpdate(dx,dy,dr)
    self:updateStars(dx,dy,dr)
end

function Sky:doOnShotDeactivated(x,y)
    self:activateStar(x,y)
end

function Sky:doCanUpdateStars(flag)
    self.canUpdateStarsFlag = flag
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function Sky:createElements()
    self:createStars()
end

function Sky:initConfig()
    self.maxStarNum = Sky.Config.MaxStarNum
end

function Sky:initAttributes()
    self.starlit            = 0
    self.starNum            = 0
    self.starIndex          = 0
    self.canUpdateStarsFlag = false
end

--------------------
-- stars
--------------------

function Sky:createStars()
    self.stars = {} 
    for i=1,self.maxStarNum do
        self.stars[i] = Star(i)
    end
end

function Sky:updateStars(dx,dy,dr)
    if not self.canUpdateStarsFlag then return end
    self.starlit   = 0
    self.starNum   = 0
    for _,star in ipairs(self.stars) do
        if star:isActive() then
            star:update(dx,dy,dr)
            self.starlit = self.starlit + star:getLightRate()
            self.starNum = self.starNum + 1 
        end
    end   
end

--------------------
-- activation
--------------------

function Sky:getNextStar()
    self.starIndex = self.starIndex + 1
    if self.starIndex > self.maxStarNum then
        self.starIndex = 1
    end
    return self.stars[self.starIndex]
end

function Sky:getStarToAvtivate()
    for _,star in ipairs(self.stars) do
        if not star:isActive() then
            return star
        end
    end
    return self:getNextStar()
end

function Sky:activateStar(x,y)
    local star = self:getStarToAvtivate()
    star:activate(x,y)
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------  
