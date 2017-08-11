-- canvas.lua
-- RKdev (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Canvas -- scaled and panned draw area
    = class()

--------------------
-- mode
--------------------

Canvas.Mode              = {}
Canvas.Mode.Basis        = {}
Canvas.Mode.Basis.Center = 1
Canvas.Mode.Basis.Corner = 2

--------------------
-- config
--------------------

Canvas.Config           = {}
Canvas.Config.Scale     = 1
Canvas.Config.MaxScale  = 10
Canvas.Config.MinScale  = 0.1
Canvas.Config.BasisMode = Canvas.Mode.Basis.Center

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Canvas:init
(               -- called when instance created to initialise it
    obj,        -- canvas's owner and handler of callbacks
    x,y,        -- canvas left-bottom corner in screen coords
    w,h         -- canvas size in screen coords
)self:doInit(obj,x,y,w,h)end

function Canvas:onTick
(               -- called to make updates and calcs
)self:doOnTick()end

function Canvas:onTouch
(               -- called to proc touching
    touch       -- Codea Touch structure, contains info about touching
)self:doOnTouch(touch)end

function Canvas:clearTouch
(               -- stops tuoching processing
)self:doClearTouch()end

function Canvas:move
(               -- sets new position in "world" system
    x,y         -- new coords
)self:doMove(x,y)end

function Canvas:resize
(               -- sets new size
    w,h         -- new size
)self:doResize(w,h)end

function Canvas:setScale
(               -- sets scale with animation
    scaleRate,  -- new scale rate
    animTime    -- nil or animation duration for setting scale
)               -- return animation controller as [tween]
return self:doSetScale(scaleRate,animTime)end

function Canvas:setBasisMode
(               -- sets inner coords begining mode (corner or center)
    mode        -- basis mode as [Canvas.Mode.Basis.*]
)self:doSetBasisMode(mode)end

function Canvas:setOffset
(               -- sets offset with animation
    ox,oy,      -- new offset value in screen coords
    animTime    -- nil or animation duration for offsetting
)               -- return animation controller as [tween]
return self:doSetOffset(ox,oy,animTime)end

function Canvas:fitRect
(               -- adjusts scale and offset to fit rect with animation
    x,y,w,h,    -- area in world coords to fit in canvas' screen coords
    animTime,   -- nil or animation duration for offsetting
    maxScale    -- maximal allowed scale 
)self:doFitRect(x,y,w,h,animTime,maxScale)end

--------------------
-- draw
--------------------

function Canvas:background
(               -- fill area with specified color
    bgcolor     -- colour to fill canvas' area
)self:doBackground(bgcolor)end

--------------------
-- getters
--------------------

function Canvas:getPlotter      -- draw helper knows scale and offset, as [Plotter]
()return self.plotter end

function Canvas:getToucher      -- touch helper converting touches to guestures [Toucher]
()return self.toucher end

--------------------
-- callback setters
--------------------

function Canvas:setOnTap        -- called when Canvas feels that user tap it [c:f(x,y)]
(f)self.onTap=f end
function Canvas:setOnLongTap    -- when user tap it and hold [c:f(x,y)]
(f)self.onLongTap=f end
function Canvas:onSliding       -- when user sliding from side [c:f(x,y,[Toucher.Side])]
(f)self.setOnSliding=f end
function Canvas:setOnSlidingBeg -- when user begin slide [c:f(x,y,[Toucher.Side])]
(f)self.onSlidingBeg=f end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Canvas:doInit(obj,x,y,w,h)
    self:initConfig()
    self:initAttributes(obj,x,y,w,h)
    self:initWindowing()
    self:initCallbacks()
    self:createElements()
end

function Canvas:doOnTouch(t)
    self.toucher:onTouch(t)
end

function Canvas:doOnTick()
    self.toucher:onTick()
end

function Canvas:doClearTouch()
    self.toucher:clear()
end

--------------------
-- windowing
--------------------

function Canvas:doMove(x,y)
    self.x = x
    self.y = y
end

function Canvas:doResize(w,h)
    self.w = w
    self.h = h
end

function Canvas:doSetBasisMode(m)
    self.basisMode = m
end

function Canvas:doSetScale(s,t)
    s = self:correctScale(s) 
    if not t or t == 0 or self.scale == s then
        self.scale = s
        return tween(0.01,self,{})
    else
        return tween(t,self,{scale=s},tween.easing.linear,function()end,self)
    end
end

function Canvas:doSetOffset(ox,oy,t)
    if not t or t == 0 or (self.ox == ox and self.oy == oy) then
        self.ox = ox
        self.oy = oy
        return tween(0.01,self,{})
    else
        return tween(t,self,{ox=ox,oy=oy},tween.easing.linear,function()end,self)
    end
end

function Canvas:doFitRect(x,y,w,h,t,maxScale)
    local nox = -(x+w/2)
    local noy = -(y+h/2)
    local sx  = self.w / (w+0.01)
    local sy  = self.h / (h+0.01)
    local ns  = math.min(sx,sy,maxScale)
    self:setOffset(nox,noy,t)
    self:setScale (ns,t)
end

--------------------
-- draw
--------------------

function Canvas:doBackground(clr)
    if not clr then return end
    local x,y,w,h = self.x,self.y,self.w,self.h
    Sys.assert(x and y, "Unknown coords x,y")
    local rect = Rectangle(x+w/2,y+h/2,w,h, clr)
    rect:draw()
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- init
--------------------

function Canvas:initConfig()
    self.basisMode = Canvas.Config.BasisMode
end

function Canvas:initAttributes(obj,x,y,w,h)
    self.obj = obj
    self.x   = x
    self.y   = y
    self.w   = w
    self.h   = h
end

function Canvas:initWindowing()
    self.ox          = 0
    self.oy          = 0
    self.scale       = Canvas.Config.Scale
    self.maxScale    = Canvas.Config.MaxScale
    self.minScale    = Canvas.Config.MinScale
end

function Canvas:initCallbacks()
    self.onTap        = nil
    self.onLongTap    = nil
    self.onSlidingBeg = nil
    self.onSliding    = nil
end

--------------------
-- elements
--------------------

function Canvas:createElements()
    self:createToucher()
    self:createPlotter()
end

function Canvas:createPlotter()
    self.plotter  = Plotter(self,Canvas.scrX,Canvas.scrY,Canvas.scrS)
end

function Canvas:createToucher()
    local l,t,r,b = self.x, self.y+self.h, self.x+self.w, self.y
    self.toucher = Toucher(self,l,t,r,b)
    self.toucher:setOnTap        (Canvas._onTap)
    self.toucher:setOnLongTap    (Canvas._onLongTap)
    self.toucher:setOnPanning    (Canvas._onPanning)
    self.toucher:setOnScaling    (Canvas._onScaling)
    self.toucher:setOnSliding    (Canvas._onSliding)
    self.toucher:setOnPanningBeg (Canvas._onPanningBeg)
    self.toucher:setOnScalingBeg (Canvas._onScalingBeg)
    self.toucher:setOnSlidingBeg (Canvas._onSlidingBeg)
end

--------------------
-- windowing
--------------------

function Canvas:correctScale(s)
    Sys.assert(s,"scale is nil")
    return math.min(self.maxScale,math.max(self.minScale,s)) 
end

--------------------
-- call back
--------------------

function Canvas:call(method, ...)
    if method~=nil then
        method(self.obj, unpack({...}))
    end
end

--------------------
-- touch callbacks
--------------------

function Canvas:_onTap(x,y)
    self:call(self.onTap, x,y)
end

function Canvas:_onLongTap(x,y)
    self:call(self.onLongTap, x,y)
end

function Canvas:_onSlidingBeg(side,x,y)
    self:call(self.onSlidingBeg, side,x,y)
end

function Canvas:_onSliding(side,x,y)
    self:call(self.onSliding, side,x,y)
end

function Canvas:_onPanning(dx,dy) 
    self.ox = self.offsetBeg.x + dx/self.scale
    self.oy = self.offsetBeg.y + dy/self.scale
end

function Canvas:_onPanningBeg() 
    self.offsetBeg = vec2(self.ox, self.oy)
end

function Canvas:_onScalingBeg(f) 
    self.scaleBeg  = self.scale
    self.focusPrv  = vec2(f.x,f.y)
    self.offsetBeg = vec2(self.ox, self.oy)
end

function Canvas:_onScaling(s,f)
    self:shiftSchemeFocusToCanvasCenter  ()
    self:setScale                        (s*self.scaleBeg)
    self:shiftWorldFocusBackToStoredFocus(f)
    self:panToCurrentFocus               (f)
end

--------------------
-- focus
--------------------

function Canvas:shiftSchemeFocusToCanvasCenter()
    self.wfx = self:wX(self.focusPrv.x) 
    self.wfy = self:wY(self.focusPrv.y)
    self.ox = -self.wfx
    self.oy = -self.wfy
end
    
function Canvas:shiftWorldFocusBackToStoredFocus(f)
    local nwfx = self:wX(f.x)
    local nwfy = self:wY(f.y)   
    self.ox = self.ox + (nwfx-self.wfx)
    self.oy = self.oy + (nwfy-self.wfy)
end

function Canvas:panToCurrentFocus(f)
    self.focusPrv.x = f.x
    self.focusPrv.y = f.y
end

--------------------
-- coords start
--------------------

function Canvas:getCoordsBasis()
    return 
        self.basisMode == Canvas.Mode.Basis.Center and
        self:coordsBasisCenter() or
        self:coordsBasisCorner()
end

function Canvas:coordsBasisCenter()
    return vec2(self.x + self.w/2, self.y + self.h/2) 
end

function Canvas:coordsBasisCorner()
    return vec2(self.x, self.y) 
end

--------------------
-- transformations
--------------------

function Canvas:x0y0()        return self:getCoordsBasis() end
function Canvas:scrX(x)       return (x+self.ox)*self.scale + self:x0y0().x end
function Canvas:scrY(y)       return (y+self.oy)*self.scale + self:x0y0().y end
function Canvas:scrS(n)       return n*self.scale end
function Canvas:scrV2(v)      return vec2(self:scrX(v.x),self:scrY(v.y)) end
function Canvas:wX(x)         return (x-self:x0y0().x)/self.scale-self.ox end
function Canvas:wY(y)         return (y-self:x0y0().y)/self.scale-self.oy end
function Canvas:wV2(v)        return vec2(self:wX(v.x),self:wY(v.y)) end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------
