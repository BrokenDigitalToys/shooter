enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.explosionSound = love.audio.newSource('sounds/explosion2.wav')
enemies_controller.spawn_speed = 100
enemies_controller.stop_spawning = false
enemies_controller.cooldown = enemies_controller.spawn_speed

enemies_controller.positionCodes = {'l', 'r', 'd', 'u'}
enemies_controller.possibleStatus = {'good', 'bad'}

enemy = {}
enemy.width = 30
enemy.height = 30
enemy.image =  love.graphics.newImage("sprites/enemy.png")
enemy.innocentImage = love.graphics.newImage("sprites/innocent.png")

function enemy:new (o)
      o = o or {}   -- create object if user does not provide one
      setmetatable(o, self)
      self.__index = self
      return o
end

function enemy:setPosition()
	if self.position == 'l' then
		self.x = 0 + (self.width/2)
		self.y = config.stage_height/2 - (self.height/2)
		self.orientation = 0
	elseif self.position == 'r' then
		self.x = config.stage_width - (self.width/2)
		self.y = config.stage_height/2  - (self.height/2)
		self.orientation = 1
	elseif self.position == 'd' then
		self.x = config.stage_width/2 - (self.width / 2)
		self.y = config.stage_height - (self.height / 2)
		self.orientation = -1/2
	else 
		self.x = config.stage_width/2 - (self.width / 2)
		self.y = 0 + (self.height / 2)
		self.orientation = 1/2
	end
end

function enemies_controller:spawnEnemy()
	e = enemy:new()
	e.position = self.positionCodes[math.random(4)]
	e:setPosition()
	e.status = self.possibleStatus[math.random(2)]
	table.insert(self.enemies, e)
end

return enemy