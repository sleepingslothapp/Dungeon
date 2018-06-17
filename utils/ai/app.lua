local Object = {}

function Object:init( p )
	local p = p or {}
	local obj = {}
	local tm ={}
	local orighp = enemy_stats[p.file].hp;
	local temphp = orighp;
	p.this.obj = obj
	obj.flip = 1
	obj.isChase = false
	obj.isAttack = false
	obj.isAttacking = false
	obj.isRespawn = false
	obj.eType = p.type
	
	p.this.speed = enemy_stats[p.file].speed
	p.this.id = math.random(0,999)..os.time()..math.random(0,999)

	local xPos = 0
	local yPos = 0
	local angle = 0
	local isNotDead = true
	local dieValue = {'die1','die2','die3'}
	local die = dieValue[math.random(1,3)]
	
	local attackFPS = 0

	obj.hitBox = display.newImageRect( p.this,enemy_stats[p.file].hitShadowPath, enemy_stats[p.file].hitW,enemy_stats[p.file].hitH )
	obj.hitBox.alpha = 0


	obj.hpBarShadow = display.newRect( p.this, 5, 8, 10, 2 )
	obj.hpBarShadow.fill = {0.5,0.5,0.5}
	obj.hpBarShadow.anchorX = 1
	obj.hpBarShadow.anchorY = 0
	obj.hpBarShadow.alpha = 0
	obj.hpBar = display.newRect( p.this, 5, 8, 10, 2 )
	obj.hpBar.anchorX = 1
	obj.hpBar.anchorY = 0
	obj.hpBar.alpha = 0


	local weaponHolder = display.newCircle( p.this, 0, 0,  enemy_stats[p.file].range )
	weaponHolder.alpha = 0
	weaponHolder.name = 'eWeapon'

	local sensor = display.newCircle( p.this, 0, 0,  enemy_stats[p.file].sensor )
	sensor.alpha = 0
	sensor.id = p.this.id
	sensor.obj = obj
	sensor.this = p.this
	sensor.name = 'sensor'
	physics.addBody( sensor, 'static', {isSensor=true,radius= enemy_stats[p.file].sensor,filter= { categoryBits=32, maskBits=1 }} )

	local attackRange = display.newCircle( p.this, 0, 0,  enemy_stats[p.file].range )
	attackRange.alpha = 0
	attackRange.obj = obj
	attackRange.this = p.this
	attackRange.name = 'range'
	attackRange.sensor = sensor
	attackRange.weaponHolder = weaponHolder
	physics.addBody( attackRange, 'static', {isSensor=true,radius= enemy_stats[p.file].range,filter={ categoryBits=64, maskBits=1 }} )


	p.map:insertNewObject(sensor)
	p.map:insertNewObject(attackRange)
	p.map:insertNewObject(weaponHolder)

	function obj:attack( )
		if (isNotDead) then	
			playSequence(p.this,'attack')
		else
			playSequence(p.this,die)
		end

	end

	playSequence(p.this,'respawn')

	function obj:actionAI()
		if (p.this.animation.sequence == 'walk' and obj.isChase ~= true) then
			p.this.speed = enemy_stats[p.file].speed
			local randomFlip = math.random(1,9999)
			if (randomFlip>100 and randomFlip<150) then
				angle = math.random( 0,360 )
			end
		end
		p.this.rotation = 0
		sensor.x = p.this.x
		sensor.y = p.this.y
		attackRange.x = p.this.x
		attackRange.y = p.this.y + enemy_stats[p.file].positioning
		weaponHolder.x = p.this.x
		weaponHolder.y = p.this.y + enemy_stats[p.file].positioning
		if (obj.isRespawn) then
			if (obj.isChase) then
				angle = (math.atan2( sensor.x-(p.player.x), sensor.y-(p.player.y) )*(180/math.pi))+90
				move_in_angle_ai(p.this,angle)
			else
				move_in_angle_ai(p.this,angle)
			end
		end
	
		if (angle>91 and angle<269) then
			p.this.xScale = -1
			obj.flip = -1
			obj.hpBarShadow.xScale = 1
			obj.hpBar.xScale = (temphp/orighp) + 0.0001
			obj.hpBarShadow.x = 5
			obj.hpBar.x = 5
		elseif (angle ~= 0) then	
			p.this.xScale = 1
			obj.flip = 1
			obj.hpBarShadow.xScale = -1
			obj.hpBar.xScale = -(temphp/orighp) + 0.0001
			obj.hpBarShadow.x = -5
			obj.hpBar.x = -5
		end
	end

	function obj:hit(  )
		if (isNotDead) then
			temphp = temphp - 2
			obj.hitBox.alpha = 0.8
			timer.performWithDelay( 100, function (  )
				obj.hitBox.alpha = 0
			end ,1 )
		end
		obj.hpBar.xScale = (temphp / orighp) + 0.0001
		if (temphp <= 0) then
			obj.hpBar.alpha = 0
			obj.hpBarShadow.alpha = 0
			isNotDead = false
			playSequence(p.this,die)
		end
	end

	function obj:destroy()
		Runtime:removeEventListener( "enterFrame", obj )
			physics.removeBody(sensor)
			physics.removeBody(attackRange)
			physics.removeBody(p.this)
		timer.performWithDelay( 25000, function (  )
			p.this:removeSelf( )
			sensor:removeSelf( )
			weaponHolder:removeSelf( )
			attackRange:removeSelf( )
		end ,1 )

	timer.performWithDelay( math.random( 1000,2000 ), function (  )
		local getPlayerPos1 = p.map:findListType('enemy_respawn')
		local enemy1 = animate:init({file=p.file,name='enemy'})
		local pos = math.random(#getPlayerPos1)
		physics.addBody( enemy1, 'dynamic',enemy_settings.properties )
		p.map:insertNewObject(enemy1)
		transition.to(enemy1, {x = getPlayerPos1[pos].x, y = getPlayerPos1[pos].y, time=0})
		ai:init({this = enemy1,map=p.map,player = p.player,file=p.file,})
	end ,2 )
	end

	function obj:enterFrame()
		obj:actionAI()
	end

	local function spriteListener( event )
		local name = event.name
		local target = event.target
		local phase = event.phase
		local sequence = target.sequence
		if (sequence == 'attack') then
			obj.isAttacking = true
			attackFPS = attackFPS + 1
			if (attackFPS > 9) then
				if (p.type == "M") then
					e_weapon_settings.properties.radius = enemy_stats[p.file].range
				end
				physics.addBody( weaponHolder, 'dynamic',e_weapon_settings.properties )
			end
			if (phase == 'ended') then
				obj.isAttacking = false
				physics.removeBody( weaponHolder, 'dynamic' )
				if (obj.isAttack) then					
					if (not player_settings.isDead) then
						obj:attack()
					else
						obj.isAttack = false
						obj.isChase = false
						playSequence(p.this,'walk')		
						p.this.speed = enemy_stats[p.file].speed	
					end
				else
					playSequence(p.this,'walk')		
					p.this.speed = enemy_stats[p.file].speed	
				end
			end
		elseif (sequence == 'alert') then
			if (phase == 'ended') then					
				playSequence(p.this,'walk')
				obj.isChase = true
			end
		elseif (sequence == die) then
			if (phase == 'ended') then					
				obj:destroy()
			end
		elseif (sequence == 'respawn') then
			if (phase == 'ended') then					
				obj.isRespawn = true
				playSequence(p.this,'walk')
			end
		end
		if (event.phase == 'ended' or event.phase == 'loop') then
			attackFPS = 0
		end
	end

	p.this.animation:addEventListener( "sprite", spriteListener )
	Runtime:addEventListener( "enterFrame", obj )
	return obj
end
return Object;