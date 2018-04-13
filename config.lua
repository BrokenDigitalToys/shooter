config = {}

config.stage_width = love.graphics.getWidth()
config.stage_height = love.graphics.getHeight()
config.game_over = false
config.game_over_sound = love.audio.newSource("sounds/large-crash.wav")
config.coin_sound = love.audio.newSource("sounds/coin-sound.wav")
config.pause = false
config.kills = 0
config.lifes_saved = 0 
config.level = 1
config.level_complete = false
config.keysPressed = 0
config.spawn_speed = 100
config.stop_spawning = false


config.levelCompleteMessage = function()
	font = love.graphics.newFont(15)
	love.graphics.setColor(255,105,180)
	gameOverWidth = font:getWidth("Level Complete")
	pressAnyButtonWidth = font:getWidth("Press any button for next level")
	love.graphics.print("Level Complete", config.stage_width/2 - gameOverWidth/2, config.stage_height/ 2)
	love.graphics.print("Press any button for next level", config.stage_width/2 - pressAnyButtonWidth/2, (config.stage_height/ 2) + 30)
end

config.gameOverMessage = function()
	font = love.graphics.newFont(15)
	love.graphics.setColor(255,105,180)
	gameOverWidth = font:getWidth("Game Over")
	pressAnyButtonWidth = font:getWidth("Press ENTER to restart!")
	love.graphics.print("Game Over", config.stage_width/2 - gameOverWidth/2, config.stage_height/ 2)
	love.graphics.print("Press ENTER to restart!", config.stage_width/2 - pressAnyButtonWidth/2, (config.stage_height/ 2) + 30)
end


config.restartGame = function()
	config.level_complete = false
	config.kills = 0
	config.spawn_speed = 100
	config.level = 1
	config.game_over = false
	config.stop_spawning = false
end

config.startNewLevel = function()
	config.level_complete = false
	config.level = config.level + 1
	config.kills = 0
	config.lifes_saved = 0
	config.spawn_speed = config.spawn_speed - 10
	config.stop_spawning = false
	particle_system:clean_all()
end