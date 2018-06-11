
-- physics [
physics = require("physics")
physics.start()
physics.setGravity( 0, 0 )
-- physics.setDrawMode( "hybrid" )
 --]
-- display set [
system.activate( "multitouch" )
display.setDefault( "background",0.1,0.1,0.1 )
display.setStatusBar( display.HiddenStatusBar )
display.setDefault("magTextureFilter", "nearest")
display.setDefault("minTextureFilter", "nearest")
-- ]
json = require("json")

-- system config [
conf = {
	isPrint = true,
	centerX = display.contentCenterX,
	centerY = display.contentCenterY,
}
--]

--Object Properties [
player_settings = {
	speed = -0.55,
	isMove = false,
	isAttack = false,
	flip = 1,
	properties = {
		shape={-4,0, 4,0, 4,8, -4,8},
		filter = { categoryBits=1, maskBits=234 },
	}
}
weapon_settings = {
	properties = {
		shape = {0,-16, 16,-16, 16,16, 0,16},
	 	filter = { categoryBits=2, maskBits=4 },
	 	isSensor = true
	 }
 }
e_weapon_settings = {
	properties = {
		shape = {},
	 	filter = { categoryBits=128, maskBits=1 },
	 	isSensor = true
	 }
 }
enemy_settings = {
	flip = 1,
	properties = {
		shape={-4,0, 4,0, 4,8, -4,8},
	 	filter = { categoryBits=4, maskBits=11 }
	 }
 }
--]
require('configs.global')
-- reuired library [
animate = require('utils.animate.app')
joy_stick = require('utils.joystick.app')
player_controller = require('utils.controller.movement')
action_button = require('utils.controller.attack')
ai = require('utils.ai.app')

json_function = require('lib.json.app')
collision = require('lib.collision.app')

tiled = require('lib.tiled.app')


enemy_stats = json.decode(json_function.loadAsset('assets/json/enemy_stats.json'))
--]
