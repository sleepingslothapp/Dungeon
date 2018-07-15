local Object = {}
Object.JsonUtils = nil

-- test function
function Object:test()
	print( 'externalfunction' )
end
-- convertRGB
function Object:convertRGB(r, g, b)
   assert(r and g and b and r <= 255 and r >= 0 and g <= 255 and g >= 0 and b <= 255 and b >= 0, "You must pass all 3 RGB values within a range of 0-255");
   return r/255, g/255, b/255;
end
-- convertHexToRGB
function Object:convertHexToRGB(hexCode)
   assert(#hexCode == 7, "The hex value must be passed in the form of #XXXXXX");
   local hexCode = hexCode:gsub("#","")
   return tonumber("0x"..hexCode:sub(1,2))/255,tonumber("0x"..hexCode:sub(3,4))/255,tonumber("0x"..hexCode:sub(5,6))/255;
end
-- play sprite in sequence
function playSequence(groupObject,seq)		
	for k,v in pairs(groupObject) do			
		v.animation:setSequence( seq)
		v.animation:play()
	end
end
function playSequenceSprite(groupObject,seq)		
	for k,v in pairs(groupObject) do			
		v:setSequence(seq)
		v:play()
	end
end
-- Set Sheet Sequence
function set_sequence( seq , group, sheet,animation,meta,frames)
	local loopCountValue = 1
	function setSequenceTime( frameCount,framesPosition, frames )
		local result = 0
		for i=1,frameCount do
			result = result + (frames[framesPosition+i].duration)
		end
		return result
	end
	for i=1,#meta.frameTags do
		if (meta.frameTags[i].name == "walk" or meta.frameTags[i].name == "idle") 
		then loopCountValue = 0; 
		else loopCountValue = 1; end
		seq[i] = 
		{
			name = meta.frameTags[i].name,
			start = meta.frameTags[i].from+1,
			count = (meta.frameTags[i].to+1) - (meta.frameTags[i].from),
			time = setSequenceTime(((meta.frameTags[i].to+1) - (meta.frameTags[i].from)),meta.frameTags[i].from,frames),
			loopCount = loopCountValue
		}
	end
	animation = display.newSprite( sheet, seq )
	group:insert(animation)
	return animation;
end
-- animate object with spriteSheet
function Object:animate(params)
	modelJson = json.decode(Object.JsonUtils.loadAsset('assets/json/model.json'))
	local p = params or {}
	local group = display.newGroup( )
	local id = p.id or "0"
	local model = p.model or "player"
	local type = p.type or "dslash"
	local group_x = p.x or gameCenterX
	local group_y = p.y or gameCenterY	
	local group_flip = gameScale
	if (p.flip) then
		group_flip = -gameScale
	end	

	local JsonSheet = json.decode( Object.JsonUtils.loadAsset(modelJson[model][id].json))
	local frames = JsonSheet.frames
	local sequenceData = JsonSheet.meta

	group.sequence = {}
	group.anim = ""
	group.animation = ""
	group.name = group_name
	group.ID = group_name
	group.isMove = false
	group.sheetData = { width=frames[1].sourceSize.w, height=frames[1].sourceSize.h, numFrames=#frames, sheetContentWidth=sequenceData.size.w, sheetContentHeight=sequenceData.size.h }
	group.sheet = graphics.newImageSheet( modelJson[model][id].sheet, group.sheetData )
	group.animation = set_sequence( group.sequence , group, group.sheet,group.anim,sequenceData,frames)

	function group:play()
		seqName = 'idle'
		group.animation:setSequence( seqName)
		group.animation:play()
		group.isMove = true
	end
	group.x = group_x
	group.y = group_y

	group.xScale = group_flip
	group.yScale = gameScale
	group:play()

	group.animation.isMove = false
	group.animation.isAttacking = false
	group.animation.model = model
	group.animation.type = type
	
	return group
end
-- move object in angle
function move_in_angle(object,angle)
		local movementScale = {}
		movementScale.x = math.cos( math.rad( angle - 0 ) )
		movementScale.y = math.sin( math.rad( angle - 0 ) )
		local velocity = {}
		velocity.x = movementScale.x * -0.1
		velocity.y = movementScale.y * -0.1
		object.x = object.x + movementScale.x  + velocity.x
		object.y = object.y + movementScale.y*-1  - velocity.y
end

return Object