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

function convertRGB(r, g, b)
   assert(r and g and b and r <= 255 and r >= 0 and g <= 255 and g >= 0 and b <= 255 and b >= 0, "You must pass all 3 RGB values within a range of 0-255");
   return r/255, g/255, b/255;
end

function convertHexToRGB(hexCode)
   assert(#hexCode == 7, "The hex value must be passed in the form of #XXXXXX");
   local hexCode = hexCode:gsub("#","")
   return tonumber("0x"..hexCode:sub(1,2))/255,tonumber("0x"..hexCode:sub(3,4))/255,tonumber("0x"..hexCode:sub(5,6))/255;
end

function playSequence(obj,seq)		
	obj.animation:setSequence( seq)
	obj.animation:play()
end