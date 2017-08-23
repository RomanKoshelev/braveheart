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

Main                       = {}
Main.Config                = {}
Main.Config.Name           = "Brave Heart"
Main.Config.Description    = "Help the Heart fight the Dragons"
Main.Config.Domain         = "Roman Koshelev"
Main.Config.FullVersion    = false
Main.Config.FullVersionURL = 'http://www.ya.ru'


------------------------------------------------------------------------------------------
-- main
------------------------------------------------------------------------------------------

local app

displayMode (FULLSCREEN_NO_BUTTONS)
sound("A Hero's Quest:Level Up")

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




