local Object = {}

function Object:init( p )
	local p = p or nil
	local obj = {}
	p.obj = obj

	obj.hitBox = display.newImageRect( p,player_settings.hitpath, player_settings.hitW,player_settings.hitH )
	obj.hitBox.alpha = 0

	function obj:hit(  )
		obj.hitBox.alpha = 0.8
		timer.performWithDelay( 100, function (  )
			obj.hitBox.alpha = 0
		end ,1 )
	end
	return obj
end

return Object