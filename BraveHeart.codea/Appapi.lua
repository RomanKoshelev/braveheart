-- appapi.lua 
-- RKdev (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

App -- describes App claas intetface, implemented in App.lua
    = class(Appbase)

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function App:init
(               -- called from .setup() to initialise whole app
    name,       -- app name
    domain,     -- source control domain
    descr       -- nil or app description
)self:doInit(name,domain,descr)end

--------------------
-- events
--------------------

function App:onTick
(               -- called from .draw() before OnDraw to do updates and calcs
)self:doOnTick()end

function App:onDraw
(               -- called from .draw() to draw all you need
)self:doOnDraw()end

function App:onTouch
(               -- called from .touched(t) to proc touching
    touch       -- Codea Touch structure, contains info about touching
)self:doOnTouch(touch)end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
