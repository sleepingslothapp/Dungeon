local Object = {}

function Object:init( p )
	local this = {}
	local attackFPS = 0

	function this:attackButton(w)
		local button = display.newCircle(conf.centerX * 2 - (30*1.5), conf.centerY * 2 - (30*2.5), 30 );
		function listener(event)
			local phase = event.phase
			if (phase == 'began' or phase == 'moved') then
				if (phase == 'began') then
					if (not player_settings.isDead) then
						if (not player_settings.isAttack) then
							player_settings.isAttack = true
							playSequence(w,'attack')
						end
					end
				end
			end
		end

		local function spriteListener( event )
			local name = event.name
			local target = event.target
			local phase = event.phase
			local sequence = target.sequence
			if (sequence == 'attack') then
				attackFPS = attackFPS + 1
				if (attackFPS > 3) then
					button:removeEventListener( 'touch', listener )
					weapon_settings.properties.shape = {0,-15, (15*player_settings.flip),-15, (15*player_settings.flip),15, (5*player_settings.flip),10}		
					physics.addBody( w, 'dynamic',weapon_settings.properties )
				end
				if (phase == 'ended') then					
					physics.removeBody( w, 'dynamic' )
					timer.performWithDelay( 100, function ()
					playSequence(w,'idle')
					end,1)
					-- timer.performWithDelay( 800, function (  )
						button:addEventListener( 'touch', listener )
					-- end ,1 )
				end
			else
				player_settings.isAttack = false
			end
			if (event.phase == 'ended' or event.phase == 'loop') then
				attackFPS = 0
			end
		end
		w.animation:addEventListener( "sprite", spriteListener )

		button:addEventListener( 'touch', listener )
	end

	return this
end

return Object