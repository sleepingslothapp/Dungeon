local physics = require "physics"

local M = {}

local screenWidth = display.actualContentWidth
local screenHeight = display.actualContentHeight

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local sheets = { frames ={}}
local frame = {}


function string:splits( inSplitPattern )
    local outResults = {}
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
 
    while theSplitStart do
        table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
        theStart = theSplitEnd + 1
        theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    end
 
    table.insert( outResults, string.sub( self, theStart ) )
    return outResults
end

function M:new(arrayData,room,dir)
	local map =  {}
	local data = {}
	local mapTileLayer = display.newGroup()
	local mapObject = display.newGroup()
	local mapAll = display.newGroup()

	mapAll:insert(mapTileLayer )
	mapAll:insert(mapObject )
	
	
	for ad = 1, #arrayData do
		table.insert(data,require('tmx_tiles2.'..arrayData[ad]))
	end	
	
	-- insert new object in tile map
	function map:insertNewObject( o )
		mapObject:insert(o)
		o.x = room[1].x
		o.y = room[1].y
		-- o.map = map
		-- mapObject[mapObject.numChildren]:toBack( )
	end
	-- keep player on center
	function map:centerObject(obj)
		mapAll.x = centerX - obj.x
		mapAll.y = centerY - obj.y
	end
	
	for m = 1, #data do

		local layers = data[m].layers
		local tilesets = data[m].tilesets

		-- add sheet properties for the sprite
		for i=1,#tilesets do
			local tileset = tilesets[i]
			local tilesIndex = 1
			for y=0,(tileset.imageheight/tileset.tileheight)-1 do
				local y = y*tileset.tileheight
				local x = 0
				for i=0,(tileset.imagewidth/tileset.tilewidth)-1 do
					x = i*tileset.tilewidth
					sheets.frames[tilesIndex] = {
							x = x,
							y = y,
							width = tileset.tilewidth,
							height = tileset.tileheight
						}
					tilesIndex = tilesIndex + 1
				end
			end
		end
		
		for i=1,#layers do
			local layer= layers[i]
			if layer.type == "tilelayer" then
				local objectSheet = graphics.newImageSheet(dir.."/"..tilesets[1].image, sheets )
				local index = 1
				for h=1, data[m].height do
					local xpos = 0
					local ypos = (h*16) + room[m].y
					for w=1, data[m].width do
						xpos = (w*16) + room[m].x 
						if (layer.data[index]~=0) then	
							local image = display.newImageRect( mapTileLayer,objectSheet,layer.data[index] , 16, 16 )
							image.anchorX,image.anchorY = 1,1
							image.x = xpos - (data[m].width * data[m].tilewidth)/2
							image.y = ypos - (data[m].height * data[m].tileheight)/2
							-- show_hide(layer.visible,image,layer.opacity)			
						end
						index = index + 1
					end
				end
			end
		end
		
	end
	
	return map
end

return M