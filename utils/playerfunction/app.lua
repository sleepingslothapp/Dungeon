local Object = {}

function Object:init( p,w )
	local p = p or nil
	local obj = {}
	local orighp = 10;
	local temphp = orighp;
	p.obj = obj
	p.isDead = false

	obj.hp = display.newImageRect('assets/img/hp_bar.png', 46, 4 )
	obj.hp.x = conf.centerX - obj.hp.width/2
	obj.hp.y = conf.centerY
	obj.hp.anchorX = -1
	obj.hpcont = display.newImageRect('assets/img/hp_bar_container.png', 48, 6 )
	obj.hpcont.x = conf.centerX
	obj.hpcont.y = conf.centerY
	obj.hpcont.anchorX = -1
	
	obj.hp:setFillColor( convertHexToRGB('#6abe30') )
	obj.hpcont:setFillColor( convertHexToRGB('#6abe30') )

	obj.hitBox = display.newImageRect( p,player_settings.hitpath, player_settings.hitW,player_settings.hitH )
	obj.hitBox.alpha = 0
	
	

	function obj:hit(  )
		temphp = temphp - 0.5
		obj.hitBox.alpha = 0.8
		obj.hp.xScale = (temphp/orighp) + 0.0001
		if (temphp <= orighp/2 and temphp > orighp/4 ) then
			obj.hpcont:setFillColor( convertHexToRGB('#df7126') )
			obj.hp:setFillColor( convertHexToRGB('#df7126') )
		elseif (temphp <= orighp/4) then
			obj.hp:setFillColor( convertHexToRGB('#ac3232') )
			obj.hpcont:setFillColor( convertHexToRGB('#ac3232') )
		else
			obj.hp:setFillColor( convertHexToRGB('#6abe30') )
			obj.hpcont:setFillColor( convertHexToRGB('#6abe30') )
		end
		timer.performWithDelay( 100, function (  )
			obj.hitBox.alpha = 0
		end ,1 )
		
		if (temphp <= 0) then
			p.isDead = true
			-- obj.hpBar.alpha = 0
			-- obj.hpBarShadow.alpha = 0
			-- isNotDead = false
			playSequence(p,'die')
			playSequence(w,'die')
		end
	end
	
	function enterFrameObj()
		obj.hp.x = 30
		obj.hp.y = 50
		obj.hpcont.x = 29
		obj.hpcont.y = 50
		
	end
	
	Runtime:addEventListener( "enterFrame", enterFrameObj )
	return obj
end

return Object