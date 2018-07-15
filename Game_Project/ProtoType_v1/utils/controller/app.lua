local Object = {}

Object.dPad = nil

function Object:init( params )	
	Object:d_pad({})
	Object:attack_button(params)
	Object:addController(params)
	Object:spriteAddEvent(params)
end
function spriteListener ( event )
	local phase = event.phase
	local sequence = event.target.sequence
	local this = event.target
	if (sequence:sub( 1,7 ) == "attack_") then
		if (phase == 'ended') then
			this.isAttacking = false
			if (this.isMove) then
				playSequenceSprite({this},'idle')
				this.isMove = true
			else							
				playSequenceSprite({this},'walk')
				this.isMove = false
			end
		end
	end
	-- print( event.name, event.target.isAttacking, event.phase, event.target.sequence )
end

function Object:spriteAddEvent( groupObject )
	for k,v in pairs(groupObject) do
		v.animation:addEventListener( "sprite", spriteListener )
	end
end
-- create direction pad
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
			stage:setFocus(nil, event.id)
			directionId = 0
			angle = 0
			distance = 0
		end
	
	end
	group:addEventListener( "touch", group )
	Object.dPad = group
end
-- create attack button
function Object:attack_button(groupObject)
	local group = display.newGroup()
	local button = display.newCircle( group, gameWidth - 60, gameHeight  - 40, 40 )
	button.alpha = 0.5
	
	local attackCount = 0
	
	function group:touch(event) 
		local phase = event.phase
		local patternCount = 1
		local lastAttack = ''
		if( (phase=='began')) then			
			if (not groupObject[1].animation.isAttacking) then
				attackCount = attackCount + 1
				for k,v in pairs(groupObject) do			
					v.animation.isAttacking = true
					if (v.animation.model == 'weapons') then
						lastAttack = v.animation.type
					end
				end
				local lastArr = {'1','2','dslash','uslash','thrust','slam'}
				playSequence(groupObject,'attack_'..lastArr[math.random(#lastArr)])
				-- if (attackCount == 3) then
				-- 	local lastArr = {'dslash','uslash','thrust'}
				-- 	playSequence(groupObject,'attack_'..lastAttack)
				-- else
				-- 	playSequence(groupObject,'attack_'..attackCount)
				-- end
				if (attackCount >= 3) then
					attackCount = 0
				end
			end	
		end
	end 
	group:addEventListener('touch',group)
end
-- add controller function
function Object:addController( groupObject )
	local obj = {}
	function moveObject(angle)
		for k,v in pairs(groupObject) do			
			move_in_angle(v,angle)
		end
	end
	function isMoving(groupObject,bool)
		for k,v in pairs(groupObject) do			
			v.animation.isMove = bool
		end
	end
	function obj:runtime(event)
		local direction = Object.dPad:getDirection()
		local angle = Object.dPad:getAngle()
		if (direction == 0) then
			if (not groupObject[1].animation.isAttacking) then
				if (not groupObject[1].animation.isMove) then
					playSequence(groupObject,'idle')
					isMoving(groupObject,true)
				end
			end
		else
			if (not groupObject[1].animation.isAttacking) then
				if (groupObject[1].animation.isMove) then
					playSequence(groupObject,'walk')
					isMoving(groupObject,false)
				end
				if (direction == 1) then -- right
					moveObject(angle)
				elseif (direction == 2) then -- up
					moveObject(angle)
				elseif (direction == 3) then -- left
					moveObject(angle)
				elseif (direction == 4) then -- down
					moveObject(angle)
				end
			end
		end
		if (not groupObject[1].animation.isAttacking) then
			if (angle>91 and angle<269) then
				for k,v in pairs(groupObject) do
					v.xScale = -gameScale
				end
			elseif (angle ~= 0) then	
				for k,v in pairs(groupObject) do
					v.xScale = gameScale
				end
			end
		end
	end
	
	Runtime:addEventListener( "enterFrame", obj.runtime )
end
return Object