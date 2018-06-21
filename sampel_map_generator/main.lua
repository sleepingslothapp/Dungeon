local tiled = require('tiled.app')
local tiledv2 = require('tiled.tiledv2')
local ms = require('ms')
local js = require('js')
local mg = require('mg')
display.setDefault("magTextureFilter", "nearest")
display.setDefault("minTextureFilter", "nearest")

function convertHexToRGB(hexCode)
   assert(#hexCode == 7, "The hex value must be passed in the form of #XXXXXX");
   local hexCode = hexCode:gsub("#","")
   return tonumber("0x"..hexCode:sub(1,2))/255,tonumber("0x"..hexCode:sub(3,4))/255,tonumber("0x"..hexCode:sub(5,6))/255;
end


display.setDefault( "background",convertHexToRGB('#e4eef0') )

local gameMap = tiledv2:new(mg.roomNameArray,mg.roomArray,"tmx_tiles2")
local pl = display.newRect( 0, 0, 15, 15 )
local joyStick = js:init({})
local playerController = ms:init({player=pl,js=joyStick})
playerController:initRunTime()

gameMap:insertNewObject(pl)

function GameRunTime( event )
	gameMap:centerObject(pl)
end

Runtime:addEventListener( 'enterFrame', GameRunTime )

