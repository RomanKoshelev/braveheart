-- ui.lua 
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

UI -- user interface
    = class()

--------------------
-- config
--------------------

UI.Config                          = {}

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function UI:init
(               -- called when created instance to initialise it
)self:doInit()end

function UI:onTick
(               -- called to make updates and calcs
)self:doOnTick()end

function UI:onDraw
(               -- called to draw all what needs
)self:doOnDraw()end

---------------------------------------------------------------------
-- events
------------------------------------------------------------------------------------------

function UI:bindEvents()
    Events.bind(Game.Config.Events.HeartNum,    self, UI.onHeartNum)
end


function UI:onHeartNum(...)
    self:doOnHeartNum(unpack({...}))
end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function UI:doInit()
    self:initAttributes()
    self:bindEvents    ()
end

function UI:doOnTick()
    self.newHeartAnimProgress = math.min(1, self.newHeartAnimProgress + .015)
    self.oldHeartAnimProgress = math.min(1, self.oldHeartAnimProgress + .02)
end

function UI:doOnDraw()
    k = math.min(1, math.min(WIDTH, HEIGHT) / 600)
    p = self.oldHeartAnimProgress or 1
    w = 25*k
    d = w+4*k
    h = w
    x = d * (1-p) * k
    y = (HEIGHT - h - 2*k)
    s = -10 * k
    for i = 1,self.heartNum do
        s = s + ((i-1)%5==0 and 15 or -10) * k
        dy = -(i*(i+1)%7)*2 * k
        if i== self.heartNum then
            self:drawLastHeart(x+s+(i-1)*d, y+dy, w, h)
        else
            sprite("Small World:Heart Glow", x+s+(i-1)*d, y+dy, w, h)
        end
    end
end

function UI:drawLastHeart(x2,y2,w2,h2)
    p = self.newHeartAnimProgress or 1
    x1 = self.newHeartX or x2
    y1 = self.newHeartY or y2
    x = Calc.between(x1,x2,p)
    y = Calc.between(y1,y2,p)
    w = w2
    h = h2
    sprite("Small World:Heart Glow", x, y, w, h)
end

function UI:doOnHeartNum(hn, x, y)
    if hn > self.heartNum then
        self.newHeartX = x
        self.newHeartY = y        
        self.newHeartAnimProgress = .01
    elseif hn < self.heartNum then
        self.oldHeartAnimProgress = .01
    end
    self.heartNum = hn
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function UI:initAttributes()
    self.heartNum = 0
    self.newHeartX = 0
    self.newHeartY = 0
    self.newHeartAnimProgress = 1.
    self.oldHeartAnimProgress = 1.
end



------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
