local Object = {}

function Object:init( p )
	local p = p or {}
	local this = {}
	local stage = display.getCurrentStage()
	local JS = display.newGroup()
	local ATK = display.newGroup()
	-- local setting = require('app.config.settings')

	--params
	local inR = p.innerRadius or 15
	local outR = p.outerRadius or 45
	local xPos = (p.x or 0)+outR+10
	local yPos = (p.y or display.actualContentHeight)-outR
	local stopRadius = outR - (inR/2)	
	local radToDeg = 180/math.pi
	local degToRad = math.pi/180	
	local directionId = 0
	local angle = 0
	local distance = 0

	local outerJoyStick = display.newCircle( JS,xPos, yPos, outR );outerJoyStick.alpha = 0.5
	local innerJoyStick = display.newCircle( JS,xPos, yPos, inR )

	function this:getDirection()
		return directionId
	end
	function this:getAngle()
		return angle
	end

	function JS:touch( event )
		local phase = event.phase
		if( (phase=='began') or (phase=="moved") ) then
			if (phase=="began") then
			stage:setFocus(JS, event.id)
			end
			local posX, posY = JS:contentToLocal(event.x, event.y)

			angle = (math.atan2( posX-xPos, posY-yPos )*radToDeg)-90
			if( angle < 0 ) then angle = 360 + angle end

			if( (angle>=45) and (angle<135) ) then directionId = 2
			elseif( (angle>=135) and (angle<225) ) then directionId = 3
			elseif( (angle>=225) and (angle<315) ) then directionId = 4
			else directionId = 1 end

			distance = math.sqrt(((posX-xPos)*(posX-xPos))+((posY-yPos)*(posY-yPos)))

			if (distance >= stopRadius) then
				distance = stopRadius
				local radAngle = angle*degToRad
				innerJoyStick.x = distance*math.cos(radAngle)+xPos
				innerJoyStick.y = -distance*math.sin(radAngle)+yPos
			else
				innerJoyStick.x = event.x
				innerJoyStick.y = event.y
			end
		else
			innerJoyStick.x = xPos
			innerJoyStick.y = yPos
			stage:setFocus(nil, event.id)
			directionId = 0
			angle = 0
			distance = 0
		end
	
	end

	JS:addEventListener( "touch", JS )

	return this
end

return Object