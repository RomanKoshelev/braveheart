-- main.lua
-- Author: Roman Koshelev
-- Roman Koshelev (c) 2017

------------------------------------------------------------------------------------------
-- dependencies
------------------------------------------------------------------------------------------

BraveHeart.ok = true

------------------------------------------------------------------------------------------
-- config
------------------------------------------------------------------------------------------

Main                    = {}
Main.Config             = {}
Main.Config.Name        = "Brave Heart"
Main.Config.Description = "Help the Heart fight the Dragons"
Main.Config.Domain      = "pgs"

------------------------------------------------------------------------------------------
-- main
------------------------------------------------------------------------------------------

local app

-- displayMode (FULLSCREEN_NO_BUTTONS)

function setup()
    app=App(
        Main.Config.Name,
        Main.Config.Domain,
        Main.Config.Description
    )
end

function draw()
    app:onTick()
    app:onDraw()
end

function touched(t)
    app:onTouch(t)
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------




