-- app.lua 
-- Papa's game studio (c) 2014

theApp = nil

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function App:doInit(name,domain,descr)
    Appbase.doInit(self,name,domain,descr)
    self:initDisplay     ()
    self:createElements  ()
    self:createParameters()
    theApp = self
end

function App:doOnTick()   
    Appbase.doOnTick(self)
    self.game:onTick()
    self.framerate:onTick()
end

function App:doOnDraw() 
    self.game:onDraw()
    if self.framerate:getFrameRate() < 40 then
        self.framerate:onDraw()
    end
    Appbase.doOnDraw(self)
end

function App:doOnTouch(t) 
    Appbase.doOnTouch(self)
    self.game:onTouch(t)
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function App:initDisplay()
    Appbase.initDisplay(self)
    supportedOrientations(ANY)
end

function App:createElements()
    Appbase.createElements(self)
    self.game      = Game()
    self.framerate = Framerate()
end

function App:createParameters()
    Appbase.createParameters(self)
    parameter.action("Reset game", function()Events.trigger(Game.Config.Events.Reset)end)
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
