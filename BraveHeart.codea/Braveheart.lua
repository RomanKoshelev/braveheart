-- Brave Heart game project
-- Roman Koshelev (c) 2017
   BraveHeart={ok=true}
--[[

------------------------------------------------------------------------------------------
-- todo
------------------------------------------------------------------------------------------

--------------------
-- 1.0.3 "XCode"
--------------------

- ui: draw hearts
- ui: draw score
- stage: show prize while striken in-place

- dragon: worth depends on speed (box side)
- heart: ajust increase logic
- score: depends only on accurancy (shot num, scale and age) and comlexity
- scheme: heart appearence logic (when smth goes wrong -- cant strike, many stars etc)
- scheme: heart activates if dragon is not striken for a long time
- score: ignore stars in scoring
- scheme: rely complexity on dragons, not shots 
- scheme: switch to hunting mode if all heart collected
- scheme: complexity must rise only if skill rised (average prize of 30 last shots)
- training mode (dragon represented as goal)
- ui different music on diff mode
- ui draw new flying heart on increase
- scheme game-over event when all hearts left
- ignore scale factor for worth
- star collapse sound protect from multy repeating

- shot cost must depend on score
- use "level" based on complexity

- refactoring
- heart sound to aheart via events

- stat buttom
- remove special buttons
- rebuild and test
- test storage

--------------------
-- 1.0.4 "Appstore"
--------------------

- verify texts (Ira Tsarkova)
- send to friends (NikFokin)
- send to appstore

--------------------
-- 1.1.0 "Marketing"
--------------------

- viral snapshot button -- to share in social networks
- acvives (snapshots as well)
- online scores
- online dueles -- just show apponent result in current competition

--------------------
-- 1.2.0 "Gameplay"
--------------------

- best w/o sight
- score w/ sight
- averege
- downloadable images with landscapes via storable webimage draw item
- dragon count
- bestshot today
- pause/exit buttons
- Pause mode -- rules, stats, bestshot hint, dragon continue move
- statistics rate "score on strikes"
- global hi score (statistics rate)
- levels based on landscape, shot sight size, speed, gun properties, etc
- downloadable landscapes
- different tint color for diff loundscapes
- numerous dragons
- shot and dragon collision logic
- spec shots to feed dragon to make it longer to get more scores when hit it
- radius for shot and head
- use animation to make interesting behaviour of dragon
- dragon: opacity
- dragon: wave segments using seg scale -- to "eat" gamer
- different gun shooting logics
- use clouds as obstacles
- use hearts which needs to be protected from dragons
- sometimes use "corners" spritemode in dragon draw instead of "center"

------------------------------------------------------------------------------------------
-- done
------------------------------------------------------------------------------------------

+ scheme: mode "show" (middle scale) to show the beuity of dragon, use big length (110)
x dragon: size randomize 
+ dragon: ini scale depends on mode and complexity 
x save/restore stars
+ gun: variate shot max duration
+ gun: mode
+ gun: complexy
+ gun: use simple shot in defence mode
x dragon ini -- minScaleRate depends on score -- to make game more complex
+ two mode:  hunt and defend 
+ hunt mode: no heart, far small dragons, selected sprites
+ defend mode: heart, near large dragons
+ heart statistics
+ heart adding logic (when dragon strikin near heart)
+ heart strike logic -- minus life
x sky -- starNum depends on dragonNum
+ heart arising logic
+ aheart beating visualisation method
+ heart and aheart
+ heart moving logic
x dragon worth base on total starlit from all stars
+ star factor depends on dist: 1000..1 pt => 1..100
+ dragon worth depends on age 0..10 sec => 100..1 
+ max worth = 100*100*100 = 1M (stars * dist factor * age factor)
x dragon: accelerate
x sky: storage
x worth factor depends on scale 0.0 - 0.3 +(max - 0)
+ dragon: eat stars 
+ sky: create star after shot deactivation
+ sky: think out stars apearence and disapeaeence logic
+ optimize drawing large sprites (draw them to 20x20 image buffer and then use it)
+ dragon worth: max worth depend on score, nominal worth, 3 ways to up worth
+ star: starlit
+ worth factor depends on star dist 0.0 - 1000 +(mac - 0) for every star
+ astar srarlit show depends on dragon dist 0..100 --> 0.2-1.5 opacity
+ star and astar classes
+ draw shot before or behind dragon acording to their scaleRates (agun:onDraw(scale))
+ shot: strike dragon only if shot's scaleRate aprox (1/2-2) equal to the dragon's one
x use buffer for control panel
+ music selection (in rb corner)
+ uilib buttons
+ music loop 
+ per shot
+ error no updating radar at begining
+ move String to commonlib
+ limit worth 1000...totalscore*rand(0.9,2) -- dragon:setWorthLimit() from scheme
+ test show radar logic
+ Game reset bttn
+ Err: does not update Score in ios simulator (?)
+ xcode

--------------------
-- 1.0.2 "Appication"
--------------------

+ decide when show Sight and when no
x refactoring Sound
x tutorial mode -- 1-20 dragons, limit with 1000 of reward, textbox ir rt-corner
x show radar after several shots (1-2-..50)
x appear info text after 1-2-5-10 shots
x use radar sound when wirth more 1000
+ draw score more accurately in LT corner
+ stats -- bestshot, bestshot today, earn per shot, dragons total, earn per hour
+ dragon's worth depends on coords, age, img, length etc, guess maximum worth and strike!
+ support orientation changing in ui -- via Screen -- special widget
+ save total score in storage
+ move sound execution on strike to ADragon class via event from Scheme class
+ count shot cost
+ simple scoring "total (last)" based on reaction and accurancy (via penalty time)
+ rise events (ui?)
+ UILib
+ use sprites for drawing shots

--------------------
-- 1.0.1 "Refactoring"
--------------------

+ all orientations support
x GameLib
+ UIlib refactoring
+ shot refactoring
+ shot sound to events?
+ refactoring proj structure
+ guns refactoring
+ fps from appbase to own class
+ remove vector sprites from pack
+ use common lib
+ implement source control
x dragon: wh factor to more intetst figures
+ refactoring
+ invite Scheme and Stage
+ stage using
+ renamed in Drag'n'twist

--------------------
-- 1.0.0 "Init"
--------------------

--]]
------------------------------------------------------------------------------------------
-- eof
------------------------------------------------------------------------------------------
