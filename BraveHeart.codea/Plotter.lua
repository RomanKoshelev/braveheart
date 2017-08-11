-- plotter.lua
-- RKdev (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Plotter -- helper class for drawning with coords translation
    = class()

--------------------
-- config
--------------------

Plotter.Config           = {}
Plotter.Config.ArcShader = "Patterns:Arc"

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Plotter:init
(               -- called when instance created to initialise it
    world,      -- master object which needs to draw in self coords via plotter translator
    screenX,    -- nil or world's method to convert its' coord X to screen X [c:f(wx)->sx]
    screenY,    -- nil or world's method to convert its' coord Y to screen Y [c:f(wy)->sy]
    screenS     -- nil or world's method to convert its' scalar S to screen S [c:f(w)->s]
)self:doInit(world,screenX,screenY,screenS)end

--------------------
-- context
--------------------

function Plotter:open
(               -- call it before drawing to save context
)self:doOpen()end

function Plotter:close
(               -- call it after drawing to restore context
)self:doClose()end

--------------------
-- ext draw api
--------------------

function Plotter:arc
(               -- draw arc using shaders
    x,y,        -- world coords
    radius      -- radius in world measure
)self:doArc(x,y,radius)end

function Plotter:polygon
(               -- draw polygon using meshes
    x,y,        -- world coords
    radius,     -- radius in world measure
    num         -- nil or number of polygon's sides
)self:doPolygon(x,y,radius,num)end

function Plotter:circle
(               -- draw arc using ellipse
    x,y,        -- world coords
    radius      -- radius in world measure
)self:doCircle(x,y,radius)end

function Plotter:frame
(               -- draw frame using lines
    x,y,        -- world coords
    w,h         -- size
)self:doFrame(x,y,w,h)end

function Plotter:cross
(               -- draw straigt cross using lines 
    x,y,        -- world coords crosss center
    w,h         -- size
)self:doCross(x,y,w,h)end

function Plotter:xcross
(               -- draw oblique cross using lines 
    x,y,        -- world coords crosss center
    w,h         -- size
)self:doXcross(x,y,w,h)end

--------------------
-- standart draw api
--------------------

function Plotter:line(...)              return self:doLine(unpack({...}))end
function Plotter:stroke(...)            return self:doStroke(unpack({...}))end
function Plotter:noStroke(...)          return self:doNoStroke(unpack({...}))end
function Plotter:strokeWidth(...)       return self:doStrokeWidth(unpack({...}))end
function Plotter:lineCapMode(...)       return self:doLineCapMode(unpack({...}))end
function Plotter:lineCapMode(...)       return self:doLineCapMode(unpack({...}))end

function Plotter:sprite(...)            return self:doSprite(unpack({...}))end
function Plotter:spriteMode(...)        return self:doSpriteMode(unpack({...}))end
function Plotter:tint(...)              return self:doTint(unpack({...}))end
function Plotter:noTint(...)            return self:doNoTint(unpack({...}))end
function Plotter:zLevel(...)            return self:doZLevel(unpack({...}))end

function Plotter:rect(...)              return self:doRect(unpack({...}))end
function Plotter:rectMode(...)          return self:doRectMode(unpack({...}))end
function Plotter:ellipse(...)           return self:doEllipse(unpack({...}))end
function Plotter:fill(...)              return self:doFill(unpack({...}))end
function Plotter:noFill(...)            return self:doNoFill(unpack({...}))end

function Plotter:text(...)              return self:doText(unpack({...}))end
function Plotter:font(...)              return self:doFont(unpack({...}))end
function Plotter:fontSize(...)          return self:doFontSize(unpack({...})) end
function Plotter:textWrapWidth(...)     return self:doTextWrapWidth(unpack({...}))end
function Plotter:textAlign(...)         return self:doTextAlign(unpack({...}))end
function Plotter:textMode(...)          return self:doTextMode(unpack({...}))end
function Plotter:textSize(...)          return self:doTextSize(unpack({...}))end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Plotter:doInit(world,scrX,scrY,scrS)
    self.world  = world
    self.scrX   = scrX
    self.scrY   = scrY
    self.scrS   = scrS
end

--------------------
-- context
--------------------

function Plotter:doOpen()
    pushStyle()
    pushMatrix()  
end

function Plotter:doClose()
    popMatrix()
    popStyle()
end

--------------------
-- ext draw
--------------------

function Plotter:doArc(x,y,r)
    if r<=0 then return end
    local m = mesh()
    x,y,r = self:x(x), self:y(y), self:s(r)
    m:addRect(x, y, r*2, r*2)
    m.shader       = shader(Plotter.Config.ArcShader)
    m.shader.size  = (1 - strokeWidth()/r) * 0.5
    m.shader.color = color(stroke())
    m.shader.a1    = 0
    m.shader.a2    = 0
    m:draw()
end

function Plotter:doPolygon(x,y,r,n)
    if r<=0 then return end
    x,y,r = self:x(x), self:y(y), self:s(r)
    p = Polygon(x,y,r,n,color(fill()))
    p:draw(x,y,r,n)
end

function Plotter:doCircle(x,y,r)
    if r<=0 then return end
    ellipse(self:x(x), self:y(y), self:s(r*2)) 
end

function Plotter:doFrame(x,y,w,h)
    local l,t,r,b
    local mode = rectMode()
    if mode == CORNER then 
        l,b,r,t = x,y,x+w,y+h
    elseif mode == CENTER then 
        l,b,r,t = x-w/2,y-h/2,x+w/2,y+h/2
    else
        Sys.error("Unsupported rectMode="..mode)
    end
    self:line(l,t,r,t)
    self:line(l,t,l,b)
    self:line(r,b,r,t)
    self:line(r,b,l,b)
end

function Plotter:doCross(x,y,w,h)
    self:line(x,y+h/2,x+w,y+h/2)
    self:line(x+w/2,y,x+w/2,y+h)
end

function Plotter:doXcross(x,y,w,h)
    local l,t,r,b
    l,b,r,t = x,y,x+w,y+h
    self:line(l,t,r,b)
    self:line(r,t,l,b)
end


--------------------
-- standart draw
--------------------

function Plotter:doFontSize(fs) 
    return fs and fontSize(self:s(fs)) or fontSize()/self:s(1)
end

function Plotter:doNoStroke() 
    noStroke() 
end

function Plotter:doNoFill() 
    noFill() 
end

function Plotter:doText(t,x,y) 
    if t then text(t, self:x(x), self:y(y)) end
end

function Plotter:doRect(x,y,w,h) 
    rect(self:x(x), self:y(y), self:s(w), self:s(h))
end

function Plotter:doRectMode(rm) 
    return rm and rectMode(rm) or rectMode()
end

function Plotter:doEllipse(x,y,w,h) 
    ellipse(self:x(x), self:y(y), self:s(w), self:s(h))
end

function Plotter:doLine(x1,y1,x2,y2)
   line(self:x(x1),self:y(y1),self:x(x2),self:y(y2))
end

function Plotter:doLineCapMode(m) 
    return m and lineCapMode(m) or lineCapMode()
end

function Plotter:doFill(clr) 
    return clr and fill(clr) or fill()
end

function Plotter:doStroke(clr) 
    return clr and stroke(clr) or stroke()
end

function Plotter:doLineCapMode(lcm) 
    return lcm and lineCapMode(lcm) or lineCapMode()
end

function Plotter:doTextAlign(ta) 
    return ta and textAlign(ta) or textAlign()
end

function Plotter:doTextMode(tm) 
    return tm and textMode(tm) or textMode()
end

function Plotter:doFont(f) 
    return f and font(f) or font()
end
    
function Plotter:doTextSize(t) 
    w,h = textSize(t)
    return w/self:s(1), h/self:s(1)
end
    
function Plotter:doTextWrapWidth(w) 
    return w and textWrapWidth(self:s(w)) or textWrapWidth()/self:s(1)
end

function Plotter:doStrokeWidth(w) 
    return w and strokeWidth(self:s(w)) or strokeWidth()/self:s(1)
end

function Plotter:doSprite(i,x,y,w,h)
    x = x or 0
    y = y or 0
    if not w then w,h = spriteSize(i) end
    if w<=0 or h<=0 then return end
    x,y = self:x(x), self:y(y)
    w,h = self:s(w), self:s(h)
    sprite(i,x,y,w,h) 
end

function Plotter:doSpriteMode(sm) 
    return sm and spriteMode(sm) or spriteMode()
end

function Plotter:doTint(...)
    tint(unpack(arg))
end

function Plotter:doNoTint()
    noTint()
end

function Plotter:doZLevel(z)
    zLevel(z)
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- coords
--------------------

function Plotter:x(x)
    Sys.assert(x,"x==nill")
    return self.scrX and self.scrX(self.world,x) or x
end

function Plotter:y(y)
    Sys.assert(y,"y==nill")
    return self.scrY and self.scrY(self.world,y) or y
end

function Plotter:s(n)
    Sys.assert(n,"n==nill")
    return self.scrS and self.scrS(self.world,n) or n
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
