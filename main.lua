Card = {height= 250, width= 100, x=nil, y=nil}
Card.__index = Card

Slot = {height=250, width=100}
Slot.__index = Slot

function Slot.draw(self)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 2)
end


function Slot:new(o)
	new_slot = o
	setmetatable(new_slot, Slot)
	return new_slot
end


function Card.update(self, dt)
	local cur_x
	local cur_y

	cur_x, cur_y = love.mouse.getPosition()

	if love.mouse.isDown(1) then
		if cur_x > self.x and cur_x < self.x + self.image:getPixelWidth() and cur_y > self.y and cur_y < self.y + self.image:getPixelHeight() then
			if not self.grabbed then
				self.offset_x = self.x - cur_x
				self.offset_y = self.y - cur_y
			end
			self.grabbed = true
		end
	else
		self.grabbed = false
	end

	if self.grabbed then
		self.x = cur_x + self.offset_x
		self.y = cur_y + self.offset_y
	end

end

function Card:new(o)
	new_card = o
	setmetatable(new_card, Card)
	return new_card
end


function love.load(args, unfilteredArgs)
	love.window.setFullscreen(true)

	quizi_vos = Card:new({x=0, y=0, image = love.graphics.newImage("images/path_cards/Quizi_Vos.jpg")})
	slots = {Slot:new({x=200, y=200}), Slot:new({x=400, y=200})}
end


function love.draw()

	love.graphics.draw(quizi_vos.image, quizi_vos.x, quizi_vos.y, 0, 0.5)

	for i, slot in pairs(slots) do
		slot:draw()
	end

end

function love.update(dt)

	quizi_vos:update(dt)

end



function love.keypressed(key, scancode, isrepeat)
	-- exit code
	if key == "c" then
		love.event.quit()
	end
end
