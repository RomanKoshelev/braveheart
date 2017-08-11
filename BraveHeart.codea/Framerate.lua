-- framerate.lua 
-- RKdev (c) 2014 (based on Kilam Malik's code)

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Framerate -- calculates and draw averege frame rate
    = class()

--------------------
-- config
--------------------

Framerate.Config            = {}
Framerate.Config.Prefix     = "fps:"
Framerate.Config.Font       = "AmericanTypewriter"
Framerate.Config.FontSize   = 14
Framerate.Config.Color      = color(177, 175, 32, 255)
Framerate.Config.BufMaxSize = 60

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Framerate:init
(               -- called when instance created to initialise it
    optSize     -- number of frames count in calculation average value, nil=[BufMaxSize]
)self:doInit()end

function Framerate:onTick
(               -- called to calc and update framerate value
)self:doOnTick()end

function Framerate:onDraw
(               -- called to draw framerate value
)self:doOnDraw()end

function Framerate:setDrawParams
(               -- define how to draw info about frame rate
    font,       -- text font name
    fontSize,   -- text font size
    color       -- text color
)self:doSetDrawParams(font,fontSize,color)end

--------------------
-- getters
--------------------

function Framerate:getFrameRate  -- frame rate as number
()return self.frameRate end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Framerate:doInit(size)
    self:initConfig()
    self:initAttributes(size)
    self:initBuffer()
end

function Framerate:doOnTick()
    self:calcFrameRate()
end

function Framerate:doSetDrawParams(f,c,s)
    self.font     = f
    self.fontSize = s
    self.color    = c
end

function Framerate:doOnDraw()
    self:defaultDraw()
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- init
--------------------

function Framerate:initConfig()
    self.prefix   = Framerate.Config.Prefix
    self.font     = Framerate.Config.Font
    self.fontSize = Framerate.Config.FontSize
    self.color    = Framerate.Config.Color
end

function Framerate:initAttributes(size)
    self.tabMaxSize = size or Framerate.Config.BufMaxSize
end

function Framerate:initBuffer()
    self.tabSum  = 0
    self.tabIdx  = 1
    self.tabSize = 0
    self.frameRateTable={}
    for i = 1,self.tabMaxSize do
        self.frameRateTable[i] = 0
    end
end

--------------------
-- calc
--------------------

function Framerate:calcFrameRate()
    local thisFrameRate = 1.0 / DeltaTime
    self.tabSum = self.tabSum - self.frameRateTable[self.tabIdx]
    self.tabSum = self.tabSum + thisFrameRate
    self.frameRateTable[self.tabIdx] = thisFrameRate
    if self.tabIdx < self.tabMaxSize then
        self.tabIdx = self.tabIdx + 1
    else
        self.tabIdx = 1
    end
    if self.tabSize < self.tabMaxSize then
        self.tabSize = self.tabSize + 1
    end
    self.frameRate = math.floor(self.tabSum / self.tabSize)
end

--------------------
-- draw
--------------------

function Framerate:defaultDraw()
    pushStyle()
    pushMatrix()
    local s = string.format("fps:%3d",self.frameRate)
    font(self.font)
    fontSize(self.fontSize)
    fill(self.color)
    textMode(CORNER)
    local w,h = textSize(self.prefix.."123")
    local x = self.x or WIDTH-w-self.fontSize/2
    local y = self.y or HEIGHT-h
    text(s,x,y)
    popMatrix()
    popStyle()
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
