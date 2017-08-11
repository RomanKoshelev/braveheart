-- calc.lua
-- RKdev (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Calc -- static class for various auxiliary calculations
    = class()

--------------------
-- config
--------------------

Calc.Config = {}

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Calc.round
(               -- calcs rounded value (1.2->1.0, 1.7->2.0, -1.7->-2.0, -1.2->-1.0)
    num         -- value as float
)               -- returns rounded result
return Calc.doRound(num)end

function Calc.randomPow
(               -- takes random value in range and deflect it to bound depended on [pow]
    min, max,   -- range to take result within
    pow         -- determines deflection to min (pow<1) or to max (pow>1)
)               -- returns deflected random value in range
return Calc.doRandomPow(min, max, pow)end

function Calc.frandom
(               -- calcs float random value within range
    min, max    -- range to take result within
)               -- returns random value
return Calc.doFrandom(min,max)end

function Calc.degree
(               -- calcs current position's progress degree between begin and end
    begPos,     -- begin position as number
    current,    -- current position as number
    endPos      -- end position as number 
)               -- returns degree = [0..1] where 0 means begin and 1 means end
return Calc.doDegree(begPos,current,endPos)end

function Calc.between
(               -- takes position value according to degree within range
    begPos,     -- begin position as number 
    endPos,     -- end position as number
    degree      -- value in [0..1] determines returned position 
)               -- returns value assitiated with degree between start and end positions
return Calc.doBetween(begPos,endPos,degree)end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Calc.doRound(num)
    if num >= 0 then 
        return math.floor(num + 0.5)
    else
        return math.ceil(num - 0.5)
    end
end

function Calc.doRandomPow(mn, mx, p)
    return mn + (mx-mn) * math.pow(math.random(), p)
end

function Calc.doFrandom(a,b)
    local d = math.max(1/(a+0.0001),1/(b+0.0001))*1000
    return math.random(d*a,d*b)/d
end

function Calc.doDegree(l,v,r)
    Sys.assert(l,"l==nill")
    Sys.assert(v,"v==nill")
    Sys.assert(r,"r==nill")
    if l==r then return 1 end
    if v <l then return 0 end
    if v >r then return 1 end
    local d  = r-l
    local p  = v-l
    return math.abs(p/d)
end

function Calc.doBetween(l,r,a)
    Sys.assert(l,"l==nill")
    Sys.assert(r,"r==nill")
    Sys.assert(a,"a==nill")
    if a<0 then return l end
    if a>1 then return r end
    return l+a*(r-l)
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
