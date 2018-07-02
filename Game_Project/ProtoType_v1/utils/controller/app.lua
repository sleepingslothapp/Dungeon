local Object = {}

function Object:d_pad()
	local group = display.newGroup()
	local stage = display.getCurrentStage()

	local inR =  15
	local outR = 45
	local xPos = outR+(outR/2)
	local yPos = display.actualContentHeight-outR
	local stopRadius = outR - inR
	local radToDeg = 180/math.pi
	local degToRad = math.pi/180	
	local directionId = 0
	local angle = 0
	local distance = 0

	local innerCircle = display.newCircle( group, xPos, yPos, inR )
	local outerCircle = display.newCircle( group, xPos, yPos, outR )
	innerCircle.alpha = 0.5
	outerCircle.alpha = 0.5

	function group:getDirection()
		return directionId
	end
	function group:getAngle()
		return angle
	end

	function group:touch( event )
		local phase = event.phase
		if( (phase=='began') or (phase=="moved") ) then
			if (phase=="began") then
			stage:setFocus(group, event.id)
			end
			local posX, posY = group:contentToLocal(event.x, event.y)

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
				innerCircle.x = distance*math.cos(radAngle)+xPos
				innerCircle.y = -distance*math.sin(radAngle)+yPos
			else
				innerCircle.x = event.x
				innerCircle.y = event.y
			end
		else
			innerCircle.x = xPos
			innerCircle.y = yPos
		end
	
	end
	group:addEventListener( "touch", group )

	return group
end

function Object:attack_button()
	local group = display.newGroup()
	local button = display.newCircle( group, gameWidth - 60, gameHeight  - 40, 40 )
	button.alpha = 0.5
end
return Object