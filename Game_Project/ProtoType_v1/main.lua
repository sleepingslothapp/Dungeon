require ('configuration.manifest')

composer.gotoScene( "Home" )


-- sample map
local group = display.newGroup( )
local grid = 3
local SR = math.round(grid/2)
local SRT = "TLBR"
group.tileArray = {}
group.tileArrayTemp = {}

for a=1,grid do
	for b=1,grid do
		local tileTemp = display.newImage(group, 'assets/images/minimap/BLOCK.png' ,16*a,16*b )
		tileTemp.alpha = 0.05
		table.insert(group.tileArrayTemp,{(16*a),(16*b),false,tileTemp})
	end
	table.insert(group.tileArray,group.tileArrayTemp)
	group.tileArrayTemp = {}
end
group.x = gameCenterX - group.width/2
group.y = gameCenterY - group.height/2

-- middle [SR][SR]
-- top [SR][SR-1]
-- left [SR+1][SR]
-- bottom [SR][SR+1]
-- right [SR-1][SR]

function checkRoom(p) 
	local getPost = {}
	for b = 0, #p.filename-1 do 
		table.insert(getPost,p.filename:sub(-#p.filename+b,1+b))
	end
	checkPost(getPost,p.currentPos,p.filename)
	
end

function showroom( rms,n1,n2 )
	local rm = rms
	rm = rm[math.random(#rms)]
	group.tileArray[n1][n2][4]:removeSelf()
	group.tileArray[n1][n2][4] = display.newImage(group, 'assets/images/minimap/'..rm..'.png' ,group.tileArray[n1][n2][1],group.tileArray[n1][n2][2] )
	group.tileArray[n1][n2][3] = true
	checkRoom({filename = rm, currentPos = {n1,n2}})
end

function checkPost(post,currentPos,rm)
	local n1 = currentPos[1];
	local n2 = currentPos[2];
	for lp = 1 , #post do
		if post[lp] == 'T' then
			timer.performWithDelay(100,function () 
					if not group.tileArray[n1][n2-1][3] then
						if n2-1 ~= 1 then
							showroom( {"TB","B","BR"},n1,n2-1 )
						else
							showroom( {"B","BR"},n1,n2-1 )
						end
					end
				end,1)
		elseif post[lp] == 'L' then	
			timer.performWithDelay(120,function () 
					if not group.tileArray[n1+1][n2][3] then
						if n1+1 > grid then
							showroom( {"LR","R","BR","TR"},n1+1,n2 )
						else
							showroom( {"R","BR","TR"},n1+1,n2 )
						end
					end
				end,1)
		elseif post[lp] == 'B' then
			timer.performWithDelay(130,function () 
					if not group.tileArray[n1][n2+1][3] then
						if n2+1 > grid then
							showroom( {"TL","TR","T","TB"},n1,n2+1 )
						else
							showroom( {"TL","TR","T"},n1,n2+1 )
						end
					end
				end,1)
		elseif post[lp] == 'R' then
			timer.performWithDelay(140,function () 
					if not group.tileArray[n1-1][n2][3] then
						if n1-1 ~= 1 then
							showroom( {"LR","LB","L"},n1-1,n2 )
						else
							showroom( {"LB","L"},n1-1,n2 )
						end
					end
				end,1)
		end
	end
end

group.tileArray[SR][SR][4]:removeSelf()
group.tileArray[SR][SR][3] = true
group.tileArray[SR][SR][4] = display.newImage(group, 'assets/images/minimap/'..SRT..'.png' ,group.tileArray[SR][SR][1],group.tileArray[SR][SR][2] )

checkRoom({filename = SRT, currentPos = {SR,SR}})