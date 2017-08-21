-- game.lua 
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Game -- dirrctor class, combine scheme, stage and ui (logic, presentation and control) 
    = class()

--------------------
-- config
--------------------

Game.Config                          = {}
Game.Config.Events                   = {}
Game.Config.Events.TotalScore        = "Game.TotalScore"
Game.Config.Events.Reward            = "Game.Reward"
Game.Config.Events.BestShot          = "Game.BestShot"
Game.Config.Events.BestShotSound     = "Game.BestShot.Sound"
Game.Config.Events.LastShot          = "Game.LastShot"
Game.Config.Events.Shot              = "Shot"
Game.Config.Events.ShotNum           = "Shot.Num"
Game.Config.Events.CanFire           = "CanFire"
Game.Config.Events.DragonNum         = "Dragon.Num"
Game.Config.Events.HeartNum          = "Heart.Num"
Game.Config.Events.DragonStrike      = "Dragon.Strike"
Game.Config.Events.DragonInit        = "Dragon.Init"
Game.Config.Events.Waiting           = "Game.Waiting"
Game.Config.Events.Reset             = "Game.Reset"
Game.Config.Events.ShowRadar         = "Game.ShowRadar"
Game.Config.Events.ShotDeactivated   = "Game.Shot.Deactivated"
Game.Config.Events.HeartIncrease     = "Heart.Increase"
Game.Config.Events.HeartDecrease     = "Heart.Decrease"
Game.Config.Events.HeartStolen       = "Heart.Stolen"

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Game:init
(               -- called when created instance to initialise it
)self:doInit()end

function Game:onTick
(               -- called to make updates and calcs
)self:doOnTick()end

function Game:onDraw
(               -- called to draw all what needs
)self:doOnDraw()end

function Game:onTouch
(               -- called to proc touching
    touch       -- Codea Touch structure, contains info about touching
)self:doOnTouch(touch)end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Game:doInit()
    self:createElements()
    self.ui:init ()
    self:doOnTick()
end

function Game:doOnTick()
    self.scheme:onTick()
    self.stage:onTick ()
    self.ui:onTick    ()
end

function Game:doOnTouch(t)
    if not self.ui:onTouch(t) then
        self.stage:onTouch(t)
    end
end

function Game:doOnDraw()
    self.stage:onDraw ()
    self.ui:onDraw    ()
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function Game:createElements()
    self.pack   = Pack  ()
    self.scheme = Scheme()
    self.stage  = Stage (self.scheme)
    self.ui     = UI    ()
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
