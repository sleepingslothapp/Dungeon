local Object = {}
function move_in_angle(player,angle)
	-- if (not player_settings.isAttack ) then
		local movementScale = {}
		movementScale.x = math.cos( math.rad( angle - 0 ) )
		movementScale.y = math.sin( math.rad( angle - 0 ) )
		local velocity = {}
		velocity.x = movementScale.x * 0.3 
		velocity.y = movementScale.y * 0.3
		player.x = player.x + movementScale.x  + velocity.x
		player.y = player.y + movementScale.y*-1  - velocity.y
	-- end
end
function Object:init( p )
	local p = p or {}
	local player = p.player or nil
	local weapon = p.weapon or nil
	local js = p.js or nil
	local obj = {}
	local groupObject = {player,weapon}
	p.player.controller = obj
	function obj:playSequence(seq,ismove)
		for k,v in pairs(groupObject) do			
			v.animation:setSequence( seq)
			v.animation:play()
		end
		player_settings.isMove = ismove
	end

	function obj:runtime(event)
		local direction = js:getDirection()
		local angle = js:getAngle()
		player.isBodyActive = true
		player.rotation = 0
		-- weapon.rotation = 0
		if (direction == 0) then -- no
			player.x = player.x + 0.00001
			-- if (not player_settings.isMove) then
			-- 	-- obj:playSequence('idle',true)
			-- end
		else
			-- if (not player_settings.isAttack) then
				if (direction == 1) then -- right
					move_in_angle(player,angle)
				elseif (direction == 2) then -- up
					move_in_angle(player,angle)
				elseif (direction == 3) then -- left
					move_in_angle(player,angle)
				elseif (direction == 4) then -- down
					move_in_angle(player,angle)
				end
				-- if (player_settings.isMove) then
					-- obj:playSequence('walk',false)
				-- end				
				for k,v in pairs(groupObject) do			
					v.x = player.x
					v.y = player.y
				end
			-- end				
		end
		if (angle>91 and angle<269) then
			for k,v in pairs(groupObject) do
				-- if (not player_settings.isAttack) then
				-- 	v.xScale = -1
				-- 	player_settings.flip = -1
				-- end
			end
		elseif (angle ~= 0) then	
			for k,v in pairs(groupObject) do
				-- if (not player_settings.isAttack) then
				-- 	v.xScale = 1
				-- 	player_settings.flip = 1
				-- end
			end
		end
	end
	function obj:initRunTime()
		Runtime:addEventListener( "enterFrame", obj.runtime )
	end
	function obj:removeRunTime()
		Runtime:removeEventListener( "enterFrame", obj.runtime )
	end
	return obj
end

return Object