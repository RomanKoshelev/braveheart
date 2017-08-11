-- star.lua 
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Star -- Controls logic of star in the game's scheme
    = class(Person)

--------------------
-- config
--------------------

Star.Config                = {}
Star.Config.MaxDragonDist  = 1000

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Star:init
(               -- called when created instance to initialise it
    id          -- star identificator
)self:doInit(id)end

function Star:update
(               -- called to make updates and calcs
    dx,dy,dr    -- dragon's coords and radius
)self:doUpdate(dx,dy,dr)end

function Star:activate
(               -- lights star in determinated position
    x,y         -- position
)self:doActivate(x,y)end

function Star:deactivate
(               -- shut down star
)self:doDeactivate()end
    
--------------------
-- getters
--------------------

function Star:getPosition    -- star coords as [x,y]
()return self.x,self.y end
function Star:getLightRate   -- star light rate as [0..1]
()return self.lightRate end
function Star:getId          -- star id
()return self.id end
function Star:isActive       -- is star in game
()return self.active end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Star:doInit(id)
    self:initConfig()
    self:initAttributes(id)
end

function Star:doUpdate(dx,dy,dr)
    self.lightRate = self:calcLightRate(dx,dy,dr)
    if self.lightRate<0 then
        self:doDeactivate()
    end
end

function Star:doActivate(x,y)
    self:initAttributes()
    self.x         = x
    self.y         = y
    self.active    = true
end

function Star:doDeactivate()
    self:initAttributes()
    self.active    = false
    -- todo to astar via event
    sound("Game Sounds One:Explode 1")
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- init
--------------------

function Star:initConfig()
    self.maxDragonDist = Star.Config.MaxDragonDist
end

function Star:initAttributes(id)
    self.x         = nil
    self.y         = nil
    self.id        = id or self.id
    self.active    = false
    self.lightRate = 0
end

--------------------
-- starlit
--------------------

function Star:calcLightRate(dx,dy,dr)
    if not self.active then return 0 end
    local x,y = self.x,self.y
    local D   = self.maxDragonDist
    local d  = vec2(x,y):dist(vec2(dx,dy))-dr
    local r   = 0 
    if d <=0 then
        r =-1
    elseif d>0 and d<D then 
        r = 1-Calc.degree(0,d,D)
        r = math.pow(r,50)
    end
    return r
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
