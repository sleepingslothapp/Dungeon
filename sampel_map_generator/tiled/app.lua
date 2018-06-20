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

function M:new(data,dir)
	local layers = data.layers
	local tilesets = data.tilesets
	local map =  {}

	local mapTileLayer = display.newGroup()
	local mapObject = display.newGroup()
	local mapAll = display.newGroup()

	mapAll:insert(mapTileLayer )
	mapAll:insert(mapObject )

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

	-- add physics body for the image if the image properties bodyType is present
	local function add_P_Body(d,image)
		local data = nil
		local name = nil
		for i=1,#tilesets do
			local tileset = tilesets[i].tiles
			for t=1,#tileset do
				if (tileset[t].id+1) == d then
					data = tileset[t].objectGroup.properties
					name = tileset[t].objectGroup.name
					if (data.bodyType) then
						if (data.shape ~=nil) then
							local values = data.shape
							local shape = tostring( values ):splits(",")
							local shapeT = {}
							for b,v in ipairs(shape) do
								table.insert( shapeT, b, v )
							end
							data.shape = shapeT	
						end
						-- if (name == 'wall') then
						-- 	data.filter = { categoryBits=8, maskBits=5 }	
						-- end
						image.name = name
						physics.addBody( image,data.bodyType,data )
						data.shape = values
					end
				end
			end
		end
	end
	-- add physics body for the Rectabngle if the rect properties bodyType is present
	local function add_P_Body_Rect(rect,properties)
		local data = properties or nil
		local name = rect.name or nil
		if (data.bodyType) then
			if (name == 'wall') then
				data.filter = { categoryBits=8, maskBits=5 }	
			end
			physics.addBody( rect,data.bodyType,data )
		end
	end
	-- add physics body for the Polygon if the rect properties bodyType is present
	local function add_P_Body_Poly(poly,properties,vertices)
		local data = properties or nil
		local name = poly.name or nil
		if (data) then
			if (data.bodyType) then
				data.shape = vertices
				if (name == 'wall') then
					data.filter = { categoryBits=8, maskBits=5 }	
				end
				physics.addBody( poly,data.bodyType,data )
			end			
		end
	end

	-- show/hide if layer visible is true/false
	local function show_hide( isVisible,object,opacity )
		if isVisible then object.alpha = opacity; else object.alpha = 0; end
	end
	-- create the tile map template
	for i=1,#layers do
		local layer= layers[i]
		if layer.type == "tilelayer" then
			local objectSheet = graphics.newImageSheet(dir.."/"..tilesets[1].image, sheets )
			local index = 1
			for h=1, data.height do
				local xpos = 0
				local ypos = h*16
				for w=1, data.width do
					xpos = w*16
					if (layer.data[index]~=0) then	
						local image = display.newImageRect( mapTileLayer,objectSheet,layer.data[index] , 16, 16 )
						image.anchorX,image.anchorY = 1,1
						image.x = xpos
						image.y = ypos	
						show_hide(layer.visible,image,layer.opacity)			
					end
					index = index + 1
				end
			end
		elseif layer.type == "objectgroup" then
				local objectSheet = graphics.newImageSheet(dir.."/"..tilesets[1].image, sheets )
				for i=1,#layer.objects do
					local layerGroup = layer.objects[i]
					if layerGroup.gid ~= nil then
						local properties = nil
						local image = display.newImageRect(  mapObject,objectSheet,layerGroup.gid , layerGroup.width, layerGroup.height )
						-- mapObject:insert(image)
						image.x = layerGroup.x + layerGroup.width/2
						image.y = layerGroup.y - layerGroup.height/2
						add_P_Body(layerGroup.gid,image)	
						show_hide(layer.visible,image,layer.opacity)						
					else
						if layerGroup.shape == "rectangle" then
							local rect = display.newRect( layerGroup.x, layerGroup.y, layerGroup.width, layerGroup.height )
							mapObject:insert(rect)
							rect.name = layerGroup.name
							rect.id = layerGroup.id
							rect.anchorX = 0
							rect.anchorY = -1
							add_P_Body_Rect(rect,layerGroup.properties)	
							show_hide(layer.visible,rect,layer.opacity)
						elseif layerGroup.shape == "ellipse" then
							local cirlce = display.newCircle( layerGroup.x+8, layerGroup.y+8, layerGroup.width/2 )
							mapObject:insert(cirlce)
							cirlce.name = layerGroup.name
							show_hide(layer.visible,cirlce,layer.opacity)
						elseif layerGroup.shape == "polygon" then
							local vertices = {}
							for k,v in pairs(layerGroup.polygon) do
								table.insert( vertices, v.x )
								table.insert( vertices, v.y )
							end
							local polygon = display.newPolygon( layerGroup.x, layerGroup.y, vertices )
							mapObject:insert(polygon)
							polygon.name = layerGroup.name
							add_P_Body_Poly(polygon,layerGroup.properties,vertices)	
							show_hide(layer.visible,polygon,layer.opacity)
						end
					end
				end
		end
	end

	-- insert new object in tile map
	function map:insertNewObject( o )
		mapObject:insert(o)
		-- o.map = map
		mapObject[mapObject.numChildren]:toBack( )
	end
	--get object by name
	function map:findObjectByName(name)
		for i=1, mapObject.numChildren do
			if (mapObject[i].name == name) then
				return mapObject[i]
			end
		end
		return false
	end
	--get object by name
	function map:findListType(name)
		local objArray = {}
		for i=1, mapObject.numChildren do
			if (mapObject[i].name == name) then
				table.insert( objArray, mapObject[i] )
			end
		end
		return objArray
	end

	function map:centerObject(obj)
		mapAll.x = centerX - obj.x
		mapAll.y = centerY - obj.y
	end

	function map:getX()
		return mapAll.x
	end
	map.groupTile = mapTileLayer
	return map
end

return M