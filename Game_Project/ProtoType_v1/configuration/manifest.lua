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

gameScale = 1.2

system.activate( "multitouch" )
display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "background",ExternalFunction:convertHexToRGB('#e4eef0') )
-- display.setDefault( "background",ExternalFunction:convertHexToRGB('#00ffff') )
display.setDefault("magTextureFilter", "nearest")
display.setDefault("minTextureFilter", "nearest")


local player = ExternalFunction:animate({isPlayer=true,})
-- local weapon = ExternalFunction:animate({isPlayer=true,model="weapons",type="dslash",id="1"})
-- local weapon = ExternalFunction:animate({isPlayer=true,model="weapons",type="dslash",id="2"})
-- local weapon = ExternalFunction:animate({isPlayer=true,model="weapons",type="thrust",id="3"})
-- local weapon = ExternalFunction:animate({isPlayer=true,model="weapons",type="thrust",id="4"})
-- local weapon = ExternalFunction:animate({isPlayer=true,model="weapons",type="slam",id="5"})
local weapon = ExternalFunction:animate({isPlayer=true,model="weapons",type="slam",id="6"})
Controller:init({player,weapon})

