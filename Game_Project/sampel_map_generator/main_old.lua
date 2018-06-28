local tiled = require('tiled.app')
local ms = require('ms')
local js = require('js')
display.setDefault("magTextureFilter", "nearest")
display.setDefault("minTextureFilter", "nearest")


local pl = display.newRect( 0, 0, 15, 15 )
local joyStick = js:init({})
local playerController = ms:init({player=pl,js=joyStick})
playerController:initRunTime()
local tn = 1
local th = {}
local thmp = {}
local start = math.random( 4 )
local rc = 1
local last_room = 1
local room_count = 1
local rt = {}
for a=1,4 do
	for b=1,4 do
		local t = display.newRect( 0,0, 112, 112 )
		t.isSelect = false
		t:setFillColor( 0.1 )
		t.x = t.x + (b*112)
		t.y = t.y + (a*112)
		table.insert( th, t )
	end
end
function checkRoom( n,r )
	if (room_count < 8) then
		if (not th[n].isSelect) then
			room_count = room_count + 1
			th[n].isSelect = true
			th[n]:setFillColor( 0,1,0 )
			nxtRoom(n)
			rc = 1
		else
			n = r[math.random(#r)]
			rc = rc + 1
			if rc < 20 then
				checkRoom(n,r)
			else
				th[last_room]:setFillColor( 1,0,0 )
			end
		end
	else
		th[last_room]:setFillColor( 1,0,0 )
	end
end
function nxtRoom( n )
	last_room = n
	table.insert( rt,n )
	if (n == 1 or n == 5 or n == 9 ) then
		local nxtR = {n + 1, n + 4}
		local nxt = nxtR[math.random(#nxtR)]
		checkRoom( nxt, nxtR )
	elseif (n == 2 or n == 3 or n == 6 or n == 7 or n == 10 or n == 11) then
		local nxtR = {n + 1, n + 4, n - 1}
		local nxt = nxtR[math.random(#nxtR)]
		checkRoom( nxt, nxtR )
	elseif (n == 4 or n == 8 or n == 12) then
		local nxtR = { n + 4, n - 1}
		local nxt = nxtR[math.random(#nxtR)]
		checkRoom( nxt, nxtR )	
	elseif (n == 13) then
		local nxtR = {n + 1}
		local nxt = nxtR[math.random(#nxtR)]
		checkRoom( nxt, nxtR )
	elseif (n == 14 or n == 15) then
		local nxtR = {n + 1, n - 1}
		local nxt = nxtR[math.random(#nxtR)]
		checkRoom( nxt, nxtR )
	elseif (n == 16) then
		local nxtR = { n - 1}
		local nxt = nxtR[math.random(#nxtR)]
		checkRoom( nxt, nxtR )
	end
end
function generateMap( ... )
	th[start]:setFillColor( 0,0,1 )
	th[start].isSelect = true

	nxtRoom(start)
end
function pickRoom( index,room,rn )
	print( index,room,rn )
	if (index == 1 and room == true) then
		return 'U'
	elseif (index == 2 and room == true) then
		if ((rn-1) == 4 or (rn-1) == 8 or (rn-1) == 12 or (rn-1) == 16) then
			return ''
		else
			return 'L'
		end
	elseif (index == 3 and room == true) then
		return 'D'
	elseif (index == 4 and room == true) then
		
		if ((rn+1) == 1 or (rn+1) == 5 or (rn+1) == 9 or (rn+1) == 13) then
			return ''
		else
			return 'R'
		end
	else
		return ''
	end
end
local pos = 1
function roomAssign( rt )
	local c = {rt-4,rt+1,rt+4,rt-1}
	local rn = ''
	for i=1,4 do
		if (c[i]>=1 and c[i]<=16) then
			rn = rn..pickRoom(i,th[c[i]].isSelect,c[i])	
		end
	end
	local mapJson = require('tmx_tiles.'..rn);
	local gameMap = tiled:new(mapJson, "tmx_tiles")
	gameMap.groupTile.x = th[rt].x
	gameMap.groupTile.y = th[rt].y


	if (pos == 1) then
		gameMap:insertNewObject(pl)
		pl.x = th[rt].x
		pl.y = th[rt].y
		pos = -1
	end
end

generateMap()

for i=1,#rt do
	roomAssign( rt[i] )
end

for i=1,#th do
	th[i]:removeSelf( )
end

