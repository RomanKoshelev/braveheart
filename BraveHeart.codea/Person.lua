-- person.lua 
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Person -- abstract class belongs to scheme and describes it's element behaviour
    = class()

--------------------
-- config
--------------------

Person.Config = {}

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Person:init
(               -- called when created instance to initialise it
)self:doInit()end

function Person:update
(               -- called to make updates and calcs
)self:doUpdate()end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Person:doInit()
    self:initConfig()
    self:initAttributes()
    self:createElements()
end

function Person:doUpdate()
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

function Person:createElements()
end

function Person:initConfig()
end

function Person:initAttributes()
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
