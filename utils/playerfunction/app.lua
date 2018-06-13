local Object = {}

function Object:init( p )
	local p = p or nil
	local obj = {}
	p.obj = obj

	obj.hp = display.newImageRect('assets/img/hp_bar.png', 46, 4 )
	obj.hp.x = conf.centerX - obj.hp.width/2
	obj.hp.y = conf.centerY
	obj.hp.anchorX = -1
	obj.hpcont = display.newImageRect('assets/img/hp_bar_container.png', 48, 6 )
	obj.hpcont.x = conf.centerX
	obj.hpcont.y = conf.centerY
	obj.hp:setFillColor( convertHexToRGB('#6abe30') )
	obj.hpcont:setFillColor( convertHexToRGB('#6abe30') )

	obj.hitBox = display.newImageRect( p,player_settings.hitpath, player_settings.hitW,player_settings.hitH )
	obj.hitBox.alpha = 0

	function obj:hit(  )
		obj.hitBox.alpha = 0.8
		obj.hp.xScale = 0.5
		-- green
			obj.hp:setFillColor( convertHexToRGB('#6abe30') )
			obj.hpcont:setFillColor( convertHexToRGB('#6abe30') )
		-- orange
			-- obj.hp:setFillColor( convertHexToRGB('#df7126') )
			-- obj.hpcont:setFillColor( convertHexToRGB('#df7126') )
		-- red
			-- obj.hp:setFillColor( convertHexToRGB('#ac3232') )
			-- obj.hpcont:setFillColor( convertHexToRGB('#ac3232') )
		timer.performWithDelay( 100, function (  )
			obj.hitBox.alpha = 0
		end ,1 )
	end
	return obj
end

return Object