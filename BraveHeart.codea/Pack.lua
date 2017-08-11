-- pack.lua 
-- Papa's game studio (c) 2014

------------------------------------------------------------------------------------------
-- class
------------------------------------------------------------------------------------------

Pack -- static class for storing game data such as sprites, levels, rules etc
    = class()

--------------------
-- balance
--------------------

Pack.Balance  = {}
Pack.Balance.DragonSegmentWorth =  1
Pack.Balance.ShotCost           =100

--------------------
-- balance
--------------------

Pack.Config                    = {}
Pack.Config.DragonBestTreshold = 3
Pack.Config.DragonBestSize     = 30

--------------------
-- sprites
--------------------

Pack.Sprites            = {}
Pack.Sprites.Dragon     = {}
Pack.Sprites.DragonBest = {}

------------------------------------------------------------------------------------------
-- api
------------------------------------------------------------------------------------------

function Pack:init
(               -- called when created instance to initialise it
)self:doInit()end

function Pack.getRandomSprite
(               -- static method for obtaining random sprite from selected storage
    storage     -- refers to Pack.Sprites.<storage>
)               -- returns random sprite from the storage
return Pack.doGetRandomSprite(storage)end

function Pack.getRandomDragonSprite
(               -- static method for obtaining random dragon sprite
    bestOnly    -- get only the best sprites, option
)               -- returns random sprite from Pack.Sprites.Dragon
return Pack.doGetRandomDragonSprite(bestOnly)end

------------------------------------------------------------------------------------------
-- implementation
------------------------------------------------------------------------------------------

function Pack:doInit()
    self:initDragonSprites()
end

function Pack.doGetRandomSprite(storage)
    local n = #storage
    local i = math.random(1,n)
    local s = storage[i]
    print(s)
    return s
end

function Pack.doGetRandomDragonSprite(bestOnly)
    local sp = bestOnly and Pack.Sprites.DragonBest or Pack.Sprites.Dragon
    return Pack.getRandomSprite(sp)
end

------------------------------------------------------------------------------------------
-- utils
------------------------------------------------------------------------------------------

--------------------
-- sprites
--------------------

function Pack:initSprites()
    self:initDragonSprites()
end

function Pack:initDragonSprites()
    self:addDragonSprite("Tyrian Remastered:Canister",1)
    self:addDragonSprite("Tyrian Remastered:Bullet Streak",1)
    self:addDragonSprite("Tyrian Remastered:Enemy Ship C",1)
    self:addDragonSprite("Tyrian Remastered:Flame Wave",2)
    self:addDragonSprite("Tyrian Remastered:Icon Ship Spheres",2)
    self:addDragonSprite("Tyrian Remastered:Missile Big",1)
    self:addDragonSprite("Tyrian Remastered:Organic Claw",3)
    self:addDragonSprite("Tyrian Remastered:Part B",2)
    self:addDragonSprite("Tyrian Remastered:Part I",2)
    self:addDragonSprite("Tyrian Remastered:Space Bug Ship",1)
    self:addDragonSprite("Tyrian Remastered:Tower",2)
    self:addDragonSprite("Cargo Bot:Claw Right",1)
    self:addDragonSprite("Cargo Bot:Clear Button",2)
    self:addDragonSprite("Cargo Bot:Claw Middle",2)
    self:addDragonSprite("Cargo Bot:Toolbox",2)
    self:addDragonSprite("Planet Cute:Chest Open",2)
    self:addDragonSprite("Planet Cute:SpeechBubble",1)
    self:addDragonSprite("Planet Cute:Grass Block",1)
    self:addDragonSprite("Planet Cute:Ramp North",1)
    self:addDragonSprite("Planet Cute:Shadow North",1)
    self:addDragonSprite("Small World:Chest",2)
    self:addDragonSprite("Small World:Chest Bottom",2)
    self:addDragonSprite("Small World:House",2)
    self:addDragonSprite("Small World:Mine Medium",3)
    self:addDragonSprite("Small World:Grass Patch",1)
    self:addDragonSprite("Small World:Store", 2)
    self:addDragonSprite("Small World:Store Medium",2)
    self:addDragonSprite("Small World:Treasure",2)
    self:addDragonSprite("Tyrian Remastered:Bad Case",2)
    self:addDragonSprite("Tyrian Remastered:Drill",2)
    self:addDragonSprite("Tyrian Remastered:Cracked Block",2)
    self:addDragonSprite("Cargo Bot:Claw Right",2)
    self:addDragonSprite("Cargo Bot:Condition Any",1)
    self:addDragonSprite("Cargo Bot:Game Area",2)
    self:addDragonSprite("Cargo Bot:Level Select Frame",2)
    self:addDragonSprite("Planet Cute:Character Princess Girl",1)
    self:addDragonSprite("Planet Cute:Gem Green",1)
    self:addDragonSprite("Planet Cute:Character Horn Girl",1)
    self:addDragonSprite("Planet Cute:Enemy Bug",1)
    self:addDragonSprite("Planet Cute:Gem Orange",1)
    self:addDragonSprite("Planet Cute:Rock",1)
    self:addDragonSprite("Planet Cute:Selector",2)
    self:addDragonSprite("Planet Cute:Tree Short",3)
    self:addDragonSprite("Planet Cute:Tree Tall",2)
    self:addDragonSprite("Planet Cute:Tree Ugly",1)
    self:addDragonSprite("Planet Cute:Water Block",3)
    self:addDragonSprite("Planet Cute:Key",2)
    self:addDragonSprite("Small World:Base Large",1)
    self:addDragonSprite("Small World:Beam",1)
    self:addDragonSprite("Small World:Church",5)
    self:addDragonSprite("Small World:Court",3)
    self:addDragonSprite("Small World:Dirt Patch",1)
    self:addDragonSprite("Small World:Explosion",2)
    self:addDragonSprite("Small World:Flag",2)
    self:addDragonSprite("Small World:Fountain",1)
    self:addDragonSprite("Small World:House White",3)
    self:addDragonSprite("Small World:Mine Large",3)
    self:addDragonSprite("Small World:Glow",1)
    self:addDragonSprite("Small World:Mine",3)
    self:addDragonSprite("Small World:Store Extra Large", 2)
    self:addDragonSprite("Small World:Observatory",2)
    self:addDragonSprite("Small World:Tower",3)
    self:addDragonSprite("Small World:Windmill",2)
    self:addDragonSprite("Small World:Watch Tower",2)
    self:addDragonSprite("Small World:Tree Cone",1)
    self:addDragonSprite("SpaceCute:Beetle Ship",1)
    self:addDragonSprite("SpaceCute:Planet",2)
    self:addDragonSprite("Tyrian Remastered:Blimp Boss",3)
    self:addDragonSprite("Tyrian Remastered:Boss A",3)
    self:addDragonSprite("Tyrian Remastered:Boss B",3)
    self:addDragonSprite("Tyrian Remastered:Boss C",3)
    self:addDragonSprite("Tyrian Remastered:Boss D",3)
    self:addDragonSprite("Tyrian Remastered:Chest Mecha",3)
    self:addDragonSprite("Tyrian Remastered:Capsule Mecha",3)
    self:addDragonSprite("Tyrian Remastered:Evil Head",3)
    self:addDragonSprite("Tyrian Remastered:Mine Spiked Huge",2)
    self:addDragonSprite("Tyrian Remastered:Part N",1)
    self:addDragonSprite("Tyrian Remastered:Explosion Huge",1)
    self:addDragonSprite("Tyrian Remastered:Eye Mecha",1)
    self:addDragonSprite("Tyrian Remastered:Evil Orb",2)
    self:addDragonSprite("Tyrian Remastered:Firestroid",1)
    self:addDragonSprite("Tyrian Remastered:Plane Boss",2)
    self:addDragonSprite("Tyrian Remastered:Rock 5",3)
    self:addDragonSprite("Tyrian Remastered:Rock 4",3)
    self:addDragonSprite("Tyrian Remastered:Rock 3",3)
    self:addDragonSprite("Tyrian Remastered:Space Ice 5",3)
    self:addDragonSprite("Tyrian Remastered:Super Brain",2)
    self:addDragonSprite("Tyrian Remastered:Space Bug Left",3)
    self:addDragonSprite("Tyrian Remastered:Space Bug Right",3)
    self:addDragonSprite("Tyrian Remastered:Satellite",3)
    self:addDragonSprite("Tyrian Remastered:Space Ice 8",2)
    self:addDragonSprite("Cargo Bot:Codea Logo",1)
    self:addDragonSprite("Cargo Bot:Made With Codea",1)
    self:addDragonSprite("Cargo Bot:Game Area Floor",1)
    self:addDragonSprite("Cargo Bot:Opening Crates",2)
    self:addDragonSprite("Cargo Bot:Loading Bar",2)
    self:addDragonSprite("Planet Cute:Shadow East",0)
    self:addDragonSprite("Planet Cute:Stone Block Tall",1)
    self:addDragonSprite("Planet Cute:Wall Block Tall",1)
    self:addDragonSprite("Planet Cute:Roof South West",1)
    self:addDragonSprite("Planet Cute:Roof South East",1)
    self:addDragonSprite("Planet Cute:Window Tall",1)
    self:addDragonSprite("Small World:Sign",1)
    self:addDragonSprite("Small World:Tree Round Flower",2)
    self:addDragonSprite("Small World:Sword",4)
    self:addDragonSprite("Small World:Bunny Skull",2)
    self:addDragonSprite("Small World:Raindrop Soft",2)
    self:addDragonSprite("SpaceCute:Collision Circle",1)
    self:addDragonSprite("Tyrian Remastered:Boss A Destroyed",3)
    self:addDragonSprite("Tyrian Remastered:Bullet Streak",2)
    self:addDragonSprite("Tyrian Remastered:Flame 1",2)
    self:addDragonSprite("Tyrian Remastered:Evil Spike", 2)
    self:addDragonSprite("Tyrian Remastered:Organic Part A",2)
    self:addDragonSprite("Tyrian Remastered:Huge Missile",3)
    self:addDragonSprite("Tyrian Remastered:Twisted",2)
    self:addDragonSprite("Tyrian Remastered:Rock Boss Left",3)
    self:addDragonSprite("Tyrian Remastered:Rock Boss Right",3)
    self:addDragonSprite("Tyrian Remastered:Warning Arrow",0)
end

function Pack:addDragonSprite(sname,n)
    n = n or 1000
    for i=1,n,1 do
        table.insert(Pack.Sprites.Dragon, sname)
    end
    if n>=Pack.Config.DragonBestTreshold then
        local s = math.max(spriteSize(sname))
        if s>= Pack.Config.DragonBestSize then
            table.insert(Pack.Sprites.DragonBest, sname)
        end
    end
end

------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
