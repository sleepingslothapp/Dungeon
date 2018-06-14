require('configs.settings')
collision:initCollision(true)
local mapJson = require('map.testmap.testmap');
local gameMap = tiled:new(mapJson, "map/testmap")

local player = animate:init({file='default',name='player'})
physics.addBody( player, 'dynamic',player_settings.properties )

local weapon = animate:init({file='sword_1',name='weapon'})
pf:init(player,weapon)

local joyStick = joy_stick:init({})

local playerController = player_controller:init({player=player,js=joyStick,weapon=weapon})
playerController:initRunTime()

local actionButton = action_button:init({})
actionButton:attackButton(weapon)


local getPlayerPos = gameMap:findObjectByName('respawnPoint')
local getPlayerPos1 = gameMap:findListType('enemy_respawn')

gameMap:insertNewObject(weapon)
gameMap:insertNewObject(player)
player.x = getPlayerPos.x + 8
player.y = getPlayerPos.y + 8
weapon.x = getPlayerPos.x + 8
weapon.y = getPlayerPos.y + 8

-- timer.performWithDelay( math.random( 1000,2000 ), function (  )
	local enemy1 = animate:init({file='enemy_1',name='enemy'})
	local pos = math.random(#getPlayerPos1)
	physics.addBody( enemy1, 'dynamic',enemy_settings.properties )
	gameMap:insertNewObject(enemy1)
	transition.to(enemy1, {x = getPlayerPos1[pos].x, y = getPlayerPos1[pos].y, time=0})
	ai:init({this = enemy1,map=gameMap,player = player,file='enemy_1',type='M'})
-- end ,5 )

function GameRunTime( event )
	gameMap:centerObject(player)
end

Runtime:addEventListener( 'enterFrame', GameRunTime )


