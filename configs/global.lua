function move_in_angle(player,angle)
	if (not player_settings.isAttack ) then
		local movementScale = {}
		movementScale.x = math.cos( math.rad( angle - 0 ) )
		movementScale.y = math.sin( math.rad( angle - 0 ) )
		local velocity = {}
		velocity.x = movementScale.x * player_settings.speed 
		velocity.y = movementScale.y * player_settings.speed
		player.x = player.x + movementScale.x  + velocity.x
		player.y = player.y + movementScale.y*-1  - velocity.y
	end
end

function move_in_angle_ai(obj,angle)
		local movementScale = {}
		movementScale.x = math.cos( math.rad( angle - 0 ) )
		movementScale.y = math.sin( math.rad( angle - 0 ) )
		local velocity = {}
		velocity.x = movementScale.x * obj.speed
		velocity.y = movementScale.y * obj.speed
		obj.x = (obj.x + movementScale.x  + velocity.x)
		obj.y = (obj.y + movementScale.y*-1  - velocity.y)
end