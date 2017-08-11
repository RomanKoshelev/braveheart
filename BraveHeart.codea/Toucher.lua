-- toucher.lua
-- RKdev (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Toucher -- helper class which processes user touchings and forms guestes for holder object
    = class()

--------------------
-- config
--------------------

Toucher.Config                 = {}
Toucher.Config.LongTapDuration = 0.25

--------------------
-- sides
--------------------

Toucher.Side         = {}
Toucher.Side.Left    = 1
Toucher.Side.Top     = 2
Toucher.Side.Right   = 3
Toucher.Side.Bottom  = 4
    
------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Toucher:init
(               -- called when instance created to initialise it
    holder,     -- master object which get callbacks from toucher on guestes
    l,t,r,b     -- left,top,right,bottom sides of touching area
)self:doInit(holder,l,t,r,b)end

function Toucher:onTick
(               -- called to make updates and calcs
)self:doOnTick()end

function Toucher:onTouch
(               -- called to proc touching
    touch       -- Codea Touch structure, contains info about touching
)self:doOnTouch(touch)end

function Toucher:clear
(               -- stop touching processing and reset all internal states
)self:doClear()end

--------------------
-- callback setters
--------------------

function Toucher:setOnTap        -- called when Toucher detects that user tap [c:f(x,y)]
(f)self.onTap=f end
function Toucher:setOnLongTap    -- when user tap and hold [c:f(x,y)]
(f)self.onLongTap=f end
function Toucher:setOnSliding    -- when user sliding from side [c:f(x,y,[Toucher.Side])]
(f)self.setOnSliding=f end
function Toucher:setOnSlidingBeg -- when user begin slide [c:f(x,y,[Toucher.Side])]
(f)self.onSlidingBeg=f end
function Toucher:setOnSlidingEnd -- when user end sliding [c:f(x,y,[Toucher.Side])]
(f)self.onSlidingEnd=f end
function Toucher:setOnWaitingBeg -- when user begin touch [c:f()]
(f)self.onWaitingBeg=f end      
function Toucher:setOnPanning    -- when user paning [c:f(dx,dy)] (dx=curX-prevX)
(f)self.onPanning=f end      
function Toucher:setOnPanningBeg -- when user begin panning area [c:f()]
(f)self.onPanningBeg=f end      
function Toucher:setOnPanningEnd -- when user end panning [c:f()]
(f)self.onPanningEnd=f end      
function Toucher:setOnScaling    -- when user scaling area [c:f(scale, focus as vec2)]
(f)self.onScaling=f end      
function Toucher:setOnScalingBeg -- when user begin scaling [c:f(focus as vec2)]
(f)self.onScalingBeg=f end      
function Toucher:setOnScalingEnd -- when user end scaling [c:f()]
(f)self.onScalingEnd=f end      

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Toucher:doInit(holder,l,t,r,b)
    self:initConfig    ()
    self:initAttributes(holder,l,t,r,b)
    self:initTouches   ()
    self:initCallbacks ()
end

function Toucher:doOnTick()
    local t = CurrentTouch
    if 
        self.mode == Toucher.Mode.Waiting
        and ElapsedTime-self.beganTime > self.longTapDuration
    then
        self:_onLongTap(t.x, t.y)
        self:clear()
    end
end

function Toucher:doOnTouch(t)
    local inBounds = Geometry.pointInBounds(t.x,t.y,self.l,self.t,self.r,self.b)
    if t.state == BEGAN then
        self:began(t)
    elseif t.state == MOVING  then
        self:moving(t,inBounds)
    elseif t.state == ENDED  then
        self:ended(t,inBounds)
    end
end

function Toucher:doClear()
    self.mode  = Toucher.Mode.Nothing
    self.side  = nil
    self:initTouches()
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- init
--------------------

function Toucher:initConfig()
    self.longTapDuration = Toucher.Config.LongTapDuration
end

function Toucher:initAttributes(holder,l,t,r,b)
    self.l            = l or 0
    self.t            = t or HEIGHT
    self.r            = r or WIDTH
    self.b            = b or 0
    self.mode         = Toucher.Mode.Nothing
    self.holder       = holder    
end

function Toucher:initTouches()
    self.t1id         = nil
    self.t1beg        = nil
    self.t1cur        = nil    
    self.t2id         = nil
    self.t2beg        = nil
    self.t2cur        = nil
end

function Toucher:initCallbacks()
    self.onTap        = nil
    self.onLongTap    = nil
    self.onWaitingBeg = nil
    self.onPanning    = nil
    self.onPanningBeg = nil
    self.onPanningEnd = nil
    self.onScaling    = nil
    self.onScalingBeg = nil
    self.onScalingEnd = nil    
    self.onSliding    = nil
    self.onSlidingBeg = nil
    self.onSlidingEnd = nil    
end

--------------------
-- modes
--------------------

Toucher.Mode         = {}
Toucher.Mode.Nothing = 0
Toucher.Mode.Waiting = 1
Toucher.Mode.Panning = 2
Toucher.Mode.Scaling = 3
Toucher.Mode.Sliding = 4

--------------------
-- processing
--------------------
    
function Toucher:began(t)
    self.beganTime = ElapsedTime
    if self.t1id == nil then
        self.t1id  = t.id
        self.t1beg = vec2(t.x,t.y)
        self.t1cur = vec2(t.x,t.y)
        self.mode  = Toucher.Mode.Waiting
        self:_onWaitingBeg()
    elseif self.t2id == nil then
        self.t2id  = t.id
        self.t2beg = vec2(t.x,t.y)
        self.t2cur = vec2(t.x,t.y)
        self.mode  = Toucher.Mode.Scaling
        self:_onScalingBeg(self:focus())
    end
end

function Toucher:ended(t,inBounds)
    if inBounds and self.mode == Toucher.Mode.Waiting and t.id==self.t1id then
        self:_onTap(t.x, t.y)
    elseif self.mode == Toucher.Mode.Panning then
        self:_onPanningEnd()
    elseif self.mode == Toucher.Mode.Scaling then
        self:_onScalingEnd()
    elseif self.mode == Toucher.Mode.Sliding then
        self:_onSlidingEnd()
    end
    self:clear()
end

function Toucher:moving(t,inBounds)
    self:updateCoords(t)
    if self.mode == Toucher.Mode.Waiting and self:fromSide() and inBounds then
        self.mode = Toucher.Mode.Sliding
        self.side = self:fromSide()
        self:_onSlidingBeg(self.side,t.x,t.y)
    elseif self.mode == Toucher.Mode.Waiting and inBounds then
        self.mode = Toucher.Mode.Panning
        self:_onPanningBeg()
    elseif self.mode == Toucher.Mode.Panning then
        self:_onPanning(t.x-self.t1beg.x, t.y-self.t1beg.y)
    elseif self.mode == Toucher.Mode.Scaling then
        local dbeg = self.t1beg:dist(self.t2beg)
        local dcur = self.t1cur:dist(self.t2cur)
        local s    = dcur/(dbeg+0.0001)
        self:_onScaling(s, self:focus())
    elseif self.mode == Toucher.Mode.Sliding then
        self:_onSliding(self.side, t.x,t.y)
    end
end

--------------------
-- sliding
--------------------

function Toucher:fromSide()
    if self.t1beg.x<=self.l+1 then 
        return Toucher.Side.Left
    elseif self.t1beg.x>=self.r-1 then 
        return Toucher.Side.Right
    elseif self.t1beg.y>=self.t-1 then 
        return Toucher.Side.Top
    elseif self.t1beg.y<=self.b+1 then 
        return Toucher.Side.Bottom
    end
    return nil
end

--------------------
-- focus vector
--------------------

function Toucher:focus()
    if self.mode == Toucher.Mode.Waiting then
        return self.t1cur
    elseif self.mode == Toucher.Mode.Panning then
        return self.t1cur
    elseif self.mode == Toucher.Mode.Scaling then
        return Geometry.vectorMiddle(self.t1cur,self.t2cur)
    end
    return nil
end

--------------------
-- coords
--------------------

function Toucher:updateCoords(t)
    if t.id == self.t1id then
        self.t1cur = vec2(t.x,t.y)
    elseif t.id == self.t2id then
        self.t2cur = vec2(t.x,t.y)
    end
end

--------------------
-- callbacks
--------------------

function Toucher:call(method, ...)
    if method~=nil then 
        method(self.holder, unpack({...}))
    end
end

function Toucher:_onTap        (...) self:call(self.onTap,        ...) end
function Toucher:_onLongTap    (...) self:call(self.onLongTap,    ...) end
function Toucher:_onWaitingBeg (...) self:call(self.onWaitingBeg, ...) end
function Toucher:_onPanning    (...) self:call(self.onPanning,    ...) end
function Toucher:_onPanningBeg (...) self:call(self.onPanningBeg, ...) end
function Toucher:_onPanningEnd (...) self:call(self.onPanningEnd, ...) end
function Toucher:_onScaling    (...) self:call(self.onScaling,    ...) end
function Toucher:_onScalingBeg (...) self:call(self.onScalingBeg, ...) end
function Toucher:_onScalingEnd (...) self:call(self.onScalingEnd, ...) end
function Toucher:_onSliding    (...) self:call(self.onSliding,    ...) end
function Toucher:_onSlidingBeg (...) self:call(self.onSlidingBeg, ...) end
function Toucher:_onSlidingEnd (...) self:call(self.onSlidingEnd, ...) end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
