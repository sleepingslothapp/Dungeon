require('configs.settings')
collision:initCollision(true)
local mapJson = require('map.testmap.testmap');
local gameMap = tiled:new(mapJson, "map/testmap")

local player = animate:init({file='default',name='player'})
physics.addBody( player, 'dynamic',player_settings.properties )
local weapon = animate:init({file='sword_red',name='weapon'})


local joyStick = joy_stick:init({})


local playerController = player_controller:init({player=player,js=joyStick,weapon=weapon})
playerController:initRunTime()

local actionButton = action_button:init({})
actionButton:attackButton(weapon)


local getPlayerPos = gameMap:findObjectByName('respawnPoint')
gameMap:insertNewObject(weapon)
gameMap:insertNewObject(player)
player.x = getPlayerPos.x + 8
player.y = getPlayerPos.y + 8
weapon.x = getPlayerPos.x + 8
weapon.y = getPlayerPos.y + 8

timer.performWithDelay( math.random( 1000,2000 ), function (  )
	local enemy1 = animate:init({file='enemy_1',name='enemy'})
	enemy1.speed = -0.7
	physics.addBody( enemy1, 'dynamic',enemy_settings.properties )
	gameMap:insertNewObject(enemy1)
	transition.to(enemy1, {x = math.random(30,180), y = math.random(30,180), time=0})
	ai:init({this = enemy1,map=gameMap,player = player,file='enemy_1',})
end ,5 )

function GameRunTime( event )
	gameMap:centerObject(player)
end

Runtime:addEventListener( 'enterFrame', GameRunTime )