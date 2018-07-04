composer = require ('composer')
json = require ('json')
JsonUtils = require ('utils.json_utils')
Controller = require ('utils.controller.app')
ExternalFunction = require ('configuration.ExternalFunction')
	ExternalFunction.JsonUtils = JsonUtils

gameWidth = display.actualContentWidth
gameHeight = display.actualContentHeight
gameCenterX = display.contentCenterX
gameCenterY = display.contentCenterY

system.activate( "multitouch" )
display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "background",ExternalFunction:convertHexToRGB('#e4eef0') )
-- display.setDefault( "background",ExternalFunction:convertHexToRGB('#00ffff') )
display.setDefault("magTextureFilter", "nearest")
display.setDefault("minTextureFilter", "nearest")


local player = ExternalFunction:animate({isPlayer=true,})
local weapon = ExternalFunction:animate({isPlayer=true,model="weapons",type="uslash"})
Controller:init({player,weapon})

