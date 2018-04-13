require "config"
require "particle_system"
require "shooter"
require "enemy"


function  checkCollisions(enemies, shooter)
	for i, e in ipairs(enemies) do
		--check for bulltets hitting enemies
		for ib, b in pairs(shooter.bullets) do
			--if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
			if b.course == e.position then 
				if (b.course == 'r' and b.x > e.x ) or (b.course == 'l' and b.x < e.x) or (b.course == 'd' and b.y > e.y) or (b.course == 'u' and b.y < e.y) then
					if e.status == 'bad' then
						particle_system:spawn(e.x, e.y)
						table.remove(enemies, i)
						love.audio.stop(enemies_controller.explosionSound)
						love.audio.play(enemies_controller.explosionSound)
						table.remove(shooter.bullets, ib)
						config.kills = config.kills + 1
					else 
						table.remove(enemies, i)
						table.remove(shooter.bullets, ib)
						particle_system:spawn(e.x, e.y,'red')
						config.game_over = true
						love.audio.play(config.game_over_sound)
					end
				end
			end
		end

			--check for enemies hiting the shooter
		if (e.position == 'r' and shooter.x > e.x ) or (e.position == 'l' and shooter.x < e.x) or (e.position == 'd' and shooter.y > e.y) or (e.position == 'u' and shooter.y < e.y) then
			if e.status == 'bad' then
				config.game_over = true
				love.audio.play(config.game_over_sound)
			else
				table.remove(enemies,i)
				love.audio.play(config.coin_sound)
				config.lifes_saved = config.lifes_saved + 1
			end
		end
	end
end

function love.load()
	local music = love.audio.newSource("sounds/recorder-music.wav")
	music:setLooping(true)
	love.audio.play(music)
end

function love.draw()
	if config.level_complete == true then 
		config.levelCompleteMessage()
	else
		if config.game_over == true then
			config.gameOverMessage()
		end

		love.graphics.setColor(255,255,255)
		particle_system:draw()

		love.graphics.scale(1)
		love.graphics.print("lifes saved:".. tostring(config.lifes_saved),0,40)
		love.graphics.print("kills:".. tostring(config.kills), 0,0)
		love.graphics.print("level:".. tostring(config.level),0,20)
		

		for _, b in pairs(shooter.bullets) do
			love.graphics.rectangle("fill", b.x, b.y, 2, 3)
		end

		for _,e in pairs(enemies_controller.enemies) do
			if e.status == 'bad' then
				love.graphics.draw(enemy.image, e.x, e.y, e.orientation *math.pi, 1, 1, e.width / 2, e.height / 2)
			else
				love.graphics.draw(enemy.innocentImage, e.x, e.y, e.orientation *math.pi, 1, 1, e.width / 2, e.height / 2)
			end
		end

		love.graphics.draw(shooter.image, shooter.x, shooter.y, shooter.orientation * math.pi, 1, 1, shooter.width / 2, shooter.height / 2)
	end
end


function love.update(dt)
	if config.game_over == true then
		if #enemies_controller.enemies > 0 then 
			enemies_controller.enemies = {}
			config.stop_spawning = true
		end 
	elseif config.level_complete == true then
		config.stop_spawning = true
		if config.keysPressed > 0 then
			shooter.cooldown = 0
			config.startNewLevel()
		end
	elseif config.pause == false then 
		

		shooter.cooldown = shooter.cooldown + 1

		if config.kills == 10 then 
			config.level_complete = true
		end

		--set time interval between every enemy created
		if (enemies_controller.cooldown < config.spawn_speed) and config.stop_spawning == false then
			enemies_controller.cooldown = enemies_controller.cooldown + 1
		else
			enemies_controller:spawnEnemy()
			enemies_controller.cooldown = 0
		end

		--move the enemies
		for _, e in pairs(enemies_controller.enemies) do
			if e.position == 'l' then
				e.x = e.x + 2
			elseif e.position == 'r' then
				e.x = e.x - 2
			elseif e.position == 'd' then
				e.y = e.y - 2
			else
				e.y = e.y + 2
			end
		end

		--move the bullets
		for i, b in pairs(shooter.bullets) do
			if b.x < 0 or b.y < 0 or b.x > config.stage_width or b.y > config.stage_height then 
				table.remove(shooter.bullets, i)
			elseif b.course == 'l' then
				b.x = b.x - 2
			elseif b.course == 'r' then
				b.x = b.x + 2
			elseif b.course == 'd' then
				b.y = b.y + 2
			else
				b.y = b.y - 2 
			end	
		end

		--shoot
		if love.keyboard.isDown("f") then
			shooter.fire()
		end

		--change shooter orientation
		if love.keyboard.isDown("left") then
			shooter.orientation = 1
		elseif love.keyboard.isDown("right") then
			shooter.orientation = 2
		elseif love.keyboard.isDown("down") then
			shooter.orientation = 1/2 
		elseif love.keyboard.isDown("up") then
			shooter.orientation = -1/2
		end

		checkCollisions(enemies_controller.enemies,shooter)
	end

	particle_system:update(dt)
	particle_system:cleanup()
end

function love.keypressed(key)
	config.keysPressed = config.keysPressed + 1
	if key == "escape" then
		config.pause = not config.pause
	end	
	if key == "return" then 
		if config.game_over == true then
			config.restartGame()
		end
	end
end

function love.keyreleased(key)
	config.keysPressed = config.keysPressed - 1
end

