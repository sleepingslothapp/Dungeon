local Object = {}

local tempRoom = {}
local room = {}
local roomArray = {}
local roomNameArray = {}
local exit_room = 0
local room_count = 1
local room_check = 1
local starting_room = math.random(4)
for column=1,4 do
	for row=0,3 do
		local tempt = display.newRect( 0,0, 112, 112 )
		tempt.isSelect = false
		tempt:setFillColor( 0.1 )
		tempt.x = tempt.x + (row*112) + 56
		tempt.y = tempt.y + (column*112) - 56
		table.insert( tempRoom, tempt )
	end
end
function checkRoom( n,r )
	if (room_count < 10) then
		if (not tempRoom[n].isSelect) then
			room_count = room_count + 1
			tempRoom[n].isSelect = true
			tempRoom[n]:setFillColor( 0,1,0 )
			nxtRoom(n)
			room_check = 1
		else
			n = r[math.random(#r)]
			room_check = room_check + 1
			if room_check < 20 then
				checkRoom(n,r)
			else
				tempRoom[exit_room]:setFillColor( 1,0,0 )
			end
		end
	else
		tempRoom[exit_room]:setFillColor( 1,0,0 )
	end
end
function nxtRoom( n )
	exit_room = n
	table.insert( room,n )
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
function pickRoom( index,room,roomName )
	if (index == 1 and room == true) then
		return 'U'
	elseif (index == 2 and room == true) then
		if ((roomName-1) == 4 or (roomName-1) == 8 or (roomName-1) == 12 or (roomName-1) == 16) then
			return ''
		else
			return 'L'
		end
	elseif (index == 3 and room == true) then
		return 'D'
	elseif (index == 4 and room == true) then		
		if ((roomName+1) == 1 or (roomName+1) == 5 or (roomName+1) == 9 or (roomName+1) == 13) then
			return ''
		else
			return 'R'
		end
	else
		return ''
	end
end
function roomAssign( rt )
	local c = {rt-4,rt+1,rt+4,rt-1}
	local roomName = ''
	for i=1,4 do
		if (c[i]>=1 and c[i]<=16) then
			roomName = roomName..pickRoom(i,tempRoom[c[i]].isSelect,c[i])	
		end
	end
	table.insert(roomNameArray,roomName)
	table.insert(roomArray,tempRoom[rt])
end
function generateMapHolder( )
	tempRoom[starting_room]:setFillColor( 0,0,1 )
	tempRoom[starting_room].isSelect = true
	nxtRoom(starting_room)
end
generateMapHolder( )
for i=1,#room do
	roomAssign( room[i] )
end
for i=1,#tempRoom do
	tempRoom[i]:removeSelf( )
	tempRoom[i] = nil
end

Object.roomNameArray  = roomNameArray
Object.roomArray  = roomArray

return Object