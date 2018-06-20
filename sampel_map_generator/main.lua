local tiled = require('tiled.app')
local tiledv2 = require('tiled.tiledv2')
local ms = require('ms')
local js = require('js')
local mg = require('mg')
display.setDefault("magTextureFilter", "nearest")
display.setDefault("minTextureFilter", "nearest")


local gameMap = tiledv2:new(mg.roomNameArray,mg.roomArray,"tmx_tiles")
local pl = display.newRect( 0, 0, 15, 15 )
local joyStick = js:init({})
local playerController = ms:init({player=pl,js=joyStick})
playerController:initRunTime()

gameMap:insertNewObject(pl)

function GameRunTime( event )
	gameMap:centerObject(pl)
end

Runtime:addEventListener( 'enterFrame', GameRunTime )

