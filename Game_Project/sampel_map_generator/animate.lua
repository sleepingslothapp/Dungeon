local Object = {}

local json = require('json')
local json_function = require('json.app')
function Object:init( p )
	local p = p or {}
	local group = display.newGroup()
	group.joystick  = nil
	-- local setting = require('configs.settings')
	local filename = p.file or 'default'
	local group_name = p.name or 'default'
	local group_x = p.x or display.contentCenterX
	local group_y = p.y or display.contentCenterY	

	local p_jsonSheet = json.decode( json_function.loadAsset(filename..'.json'))
	local frames = p_jsonSheet.frames
	local sequenceData = p_jsonSheet.meta

	group.sequence = {}
	group.anim = ""
	group.animation = ""
	group.name = group_name
	group.ID = group_name
	group.isMove = false
	group.sheetData = { width=frames[1].sourceSize.w, height=frames[1].sourceSize.h, numFrames=#frames, sheetContentWidth=sequenceData.size.w, sheetContentHeight=sequenceData.size.h }
	group.sheet = graphics.newImageSheet( filename..'.png', group.sheetData )
	group.animation = set_sequence( group.sequence , group, group.sheet,group.anim,sequenceData,frames)


	function group:play()
		seqName = 'walk'
		group.animation:setSequence( seqName)
		group.animation:play()
		group.isMove = true
	end
	group.x = group_x
	group.y = group_y
	group:play()
	return group
end

function set_sequence( seq , group, sheet,animation,meta,frames)
	local loopCountValue = 1
	for i=1,#meta.frameTags do
		if (meta.frameTags[i].name == "walk" or meta.frameTags[i].name == "walk") 
		then loopCountValue = 0; 
		else loopCountValue = 1; end
		seq[i] = 
		{
			name = meta.frameTags[i].name,
			start = meta.frameTags[i].from+1,
			count = (meta.frameTags[i].to+1) - (meta.frameTags[i].from),
			time = ((meta.frameTags[i].to+1) - (meta.frameTags[i].from) )* frames[i].duration,
			loopCount = loopCountValue
		}
	end
	animation = display.newSprite( sheet, seq )
	group:insert(animation)
	return animation;
end

return Object