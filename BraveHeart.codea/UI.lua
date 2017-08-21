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

UI.Config = {}

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

function UI:onTouch
(               -- called to proc touching
    touch       -- Codea Touch structure, contains info about touching
)return self:doOnTouch(touch)end

---------------------------------------------------------------------
-- events
------------------------------------------------------------------------------------------

function UI:bindEvents()
    Events.bind(Game.Config.Events.HeartNum, self, UI.onHeartNum)
    Events.bind(Game.Config.Events.ShotNum, self, UI.onShotNum)
end
function UI:onHeartNum(...)
    self:doOnHeartNum(unpack({...}))
end
function UI:onShotNum(...)
    self:doOnShotNum(unpack({...}))
end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function UI:doInit()
    self:initAttributes()
    self:bindEvents    ()
end

function UI:doOnTick()
    self.stealNewHeart = not Main.Config.FullVersion and self.heartNum > Scheme.Config.MaxFreeHeartNum
    local nd = self.stealNewHeart and .003 or .015
    self.newHeartAnimProgress = math.min(1, self.newHeartAnimProgress + nd)
    self.oldHeartAnimProgress = math.min(1, self.oldHeartAnimProgress + .02)
    
    if self.stealNewHeart then
        self.sendStolenEvent = self.sendStolenEvent or false
        if not self.sendStolenEvent and self.newHeartAnimProgress> .1 then
            self.sendStolenEvent = true
        end
        if self.sendStolenEvent and self.newHeartAnimProgress > .99 then
            Events.trigger(Game.Config.Events.HeartStolen)
            self.sendStolenEvent = false
        end
    end
end

function UI:doOnDraw()
    self:drawHearts()
    if not Main.Config.FullVersion then
        self:drawBuyButton()
        -- self:drawFreePanel()
        -- self:drawShotNum()
    end
end

function UI:drawHearts()
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
    
    if self.stealNewHeart then
        x2 = 0
        y2 = 0
    end

    x1 = self.newHeartX or x2
    y1 = self.newHeartY or y2
    x = Calc.between(x1,x2,p)
    y = Calc.between(y1,y2,p)
    w = w2
    h = h2
    sprite("Small World:Heart Glow", x, y, w, h)
end


function UI:drawBuyButton()
    bc = color(0,0,0,120)
    tc = color(200, 200, 200, 120)
    if self.shotNum >= Scheme.Config.MaxFreeShotNum then
        bc = color(250,0,0,220)
        tc = color(255, 255, 0, 220)
    end
    if self.heartNum > Scheme.Config.MaxFreeHeartNum and self.newHeartAnimProgress<1 then
        bc = color(250,0,0,220)
        tc = color(255, 255, 0, 220)
    end

    pushStyle()
    pushMatrix()
        s = "BUY FULL VERSION"
        self.button_w = 260
        self.button_h = 50
        b = -1
        self.button_x = b
        self.button_y = b
        fill(bc)
        noStroke()
        rect(self.button_x, self.button_y, self.button_w, self.button_h)
        textMode(CORNER)
        font("SourceSansPro-Bold")
        fontSize(28)
        fill(tc)
        tw, th = textSize(s)
        text(s, self.button_x+(self.button_w-tw)/2, self.button_y+(self.button_h-th)/2)
    popMatrix()
    popStyle()
end

function UI:doOnTouch(t)
    if not Main.Config.FullVersion then
        if t.state == BEGAN or t.state == MOVING then
            if t.x > self.button_x and t.x < self.button_x+self.button_w then
                if t.y > self.button_y and t.y < self.button_y+self.button_h then
                    openURL(Main.Config.FullVersionURL)
                    return true
                end
            end
        end
    end
    return false
end

function UI:drawFreePanel()
    pushStyle()
    pushMatrix()
        fill(color(0,0,0,200))
        noStroke()
        rect(-1,-1,WIDTH+10, 40)
    popMatrix()
    popStyle()
end

function UI:drawShotNum()
    pushStyle()
    pushMatrix()
        local s = string.format("shots left: %3d", Scheme.Config.MaxFreeShotNum - self.shotNum)
        font("AmericanTypewriter")
        fontSize(20)
        fill(color(177, 175, 32, 255))
        textMode(CORNER)
        local x = 6
        local y = 6
        text(s,x,y)
    popMatrix()
    popStyle()
end

function UI:doOnHeartNum(hn, x, y)
    if hn > self.heartNum then
        self.newHeartX = x
        self.newHeartY = y
        self.newHeartAnimProgress = .01
    elseif hn < self.heartNum and not self.stealNewHeart then
        self.oldHeartAnimProgress = .01
    end
    self.heartNum = hn
end

function UI:doOnShotNum(sn)
    self.shotNum = sn
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function UI:initAttributes()
    self.shotNum = 0
    self.heartNum = 0
    self.newHeartX = 0
    self.newHeartY = 0
    self.newHeartAnimProgress = 1.
    self.oldHeartAnimProgress = 1.
    self.stealNewHeart = false
end



------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
