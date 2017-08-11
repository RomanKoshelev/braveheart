-- color.lua
-- RKdev (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Color -- static class, supports operations with colours
    = class()

--------------------
-- config
--------------------

Color.Config        = {}
Color.Config.Opaque = 255

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Color.grey
(               -- makes grey transparent colour
    b,          -- brightness
    a           -- alpha or nil for opaque colour
)               -- returns grey (transparent) colour
return Color.doGrey(b,a) end

function Color.setAlpha
(               -- makes new color base on r,g,b part of parameter and new alpha value
    c,          -- color, alpha component will be replaced
    a           -- new alpha component
)               -- returns nee color base on c.r,c.g,c.b and a as alpha
return Color.doSetAlpha(c,a)end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Color.doGrey(b,a)
    a = a or Color.Config.Opaque
    return color(b,b,b,a)
end

function Color.doSetAlpha(c,a)
    return color(c.r,c.g,c.b,a)
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
