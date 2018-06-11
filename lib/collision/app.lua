local Object = {}

function onGlobalCollision( event )
    if ( event.phase == "began" ) then        
		enemyChase({event=event,seq1='alert',seq2='walk',time=200,isChase=true})
		enemyAttack({event=event,isAttack=true,seq1='attack',seq2='walk'})
		enemyHit({event=event})
    elseif ( event.phase == "ended" ) then  
		enemyChase({event=event,seq1='idle',seq2='walk',time=200,isChase=false}) 
		enemyAttack({event=event,isAttack=false,seq1='walk',seq2='walk'})
		enemyHit({event=event})
    end
end
 
function Object:initCollision(action)
	if (action) then
		Runtime:addEventListener( 'collision', onGlobalCollision )
	else
		Runtime:removeAddEventListener( 'collision', onGlobalCollision )
	end
end

--ENEMY FUNCTION [
function collisionChecker( params,obj1,obj2 )
	local obj = nil
	if (params.event.object1.name == obj1 and params.event.object2.name == obj2) then
		obj = params.event.object2
	elseif (params.event.object2.name == obj1 and params.event.object1.name == obj2) then
		obj = params.event.object1
	end
	return obj
end

function enemyChase (params) 
	local params = params or {}
	local collisionVariable = collisionChecker(params,'player','sensor') or nil
	if(collisionVariable) then
		if (collisionVariable.obj.isRespawn) then
		collisionVariable.obj.isChase = params.isChase	
			if (params.isChase) then
				collisionVariable.obj.isRespawn = true
				collisionVariable.obj:playSequence(params.seq1)
			end
		end
	end
end

function enemyAttack(params)
	local params = params or {}
	local speed = 0
	local collisionVariable = collisionChecker( params,'player','range' ) or nil
	if (collisionVariable) then
		collisionVariable.obj.isAttack = params.isAttack
		if (collisionVariable.obj.isAttack) then
			collisionVariable.obj:attack()
		end
		speed = -1
		collisionVariable.this.speed = speed		
	end
end
--]

--HITTING ENEMY [
function enemyHit(params)
	local params = params or {}
	local collisionVariable = collisionChecker( params,'weapon','enemy' ) or nil
	if (collisionVariable) then
		collisionVariable.obj:hit(  )
	end
end
--]

return Object