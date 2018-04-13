shooter  = {}
shooter.image = love.graphics.newImage("sprites/shooter.png")
shooter.fireSound = love.audio.newSource("sounds/my_laser.wav")
shooter.width = 30
shooter.height = 30
shooter.cooldown = 0
shooter.x = (config.stage_width/ 2) - (shooter.width / 2)
shooter.y = (config.stage_height/ 2) - (shooter.height / 2)
shooter.orientation = 2
shooter.bullets = {}
shooter.fire = function()
	if shooter.cooldown > 20 then
		bullet = {}
		bullet.x = shooter.x
		bullet.y = shooter.y
		if shooter.orientation == 1 then
			bullet.course = 'l' -- l for left
		elseif shooter.orientation == 2 then
			bullet.course = 'r'
		elseif  shooter.orientation == 1/2 then
			bullet.course = 'd'
		else 
			bullet.course = 'u'
		end

		shooter.cooldown  = 0
		table.insert(shooter.bullets, bullet)
		love.audio.play(shooter.fireSound)
	end	
	
end


return shooter