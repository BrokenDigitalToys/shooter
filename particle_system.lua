particle_system = {}
particle_system.list = {}
particle_system.img = love.graphics.newImage('sprites/particle.png')


function particle_system:spawn(x,y,color)
	local ps = {}
	ps.ps = love.graphics.newParticleSystem(particle_system.img, 8)
	ps.x = x
	ps.y = y 
	ps.lifetime = 10
	ps.ps:setParticleLifetime(1,10) --particle life 1-2 sec
	ps.ps:setEmissionRate(1000) --number of particles per sec
	ps.ps:setSizeVariation(1) --variation on maximum
	ps.ps:setLinearAcceleration(-20,-20,20,20)
	if(color == 'red') then
		ps.ps:setColors(255,0,0,255)
	else
		ps.ps:setColors(255,255, 255,255)
	end
	table.insert(particle_system.list, ps)
end

function particle_system:draw()
	for _, v in pairs(particle_system.list) do
		love.graphics.draw(v.ps, v.x, v.y)
	end
end

function particle_system:update(dt)
	for  _,v in pairs(particle_system.list) do
		v.lifetime = v.lifetime + 1
		v.ps:update(dt)
	end
end

function particle_system:cleanup()
	for  i,v in pairs(particle_system.list) do
		if v.lifetime  > 50 then
			table.remove(particle_system.list, i)
		end
	end
end	

function particle_system:clean_all()
	for  i,v in pairs(particle_system.list) do
		table.remove(particle_system.list, i)
	end
end

return particle_system