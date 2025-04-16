Card = {height= 340, width= 240, x=nil, y=nil}
Card.__index = Card

Slot = {height=340, width=240}
Slot.__index = Slot

function Slot.draw(self)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 2)
end


function Slot:new(o)
	new_slot = o
	setmetatable(new_slot, Slot)
	return new_slot
end


function Card.slot_in(self)
	-- check each corner of the card
	-- if any are within the dimensions of the slot
	-- fix the position of the card to the slot
	-- TODO a smooth animation for this
	local corners = {
		{x=self.x, y=self.y},
		{x=self.x + self.width, y=self.y},
		{x=self.x, y=self.y + self.height},
		{x=self.x + self.width, y=self.y + self.height}
	}

	local slots = slots

	for i, slot in pairs(slots) do
		for j, corner in pairs(corners) do
			if corner.x >= slot.x and corner.x <= slot.x + slot.width and corner.y >= slot.y and corner.y <= slot.y + slot.height then
				self.x = slot.x
				self.y = slot.y
				return
			end
		end
	end
end


function Card.update(self, dt)
	local cur_x, cur_y = love.mouse.getPosition()

	if love.mouse.isDown(1) then
		if cur_x > self.x and cur_x < self.x + self.image:getPixelWidth() and cur_y > self.y and cur_y < self.y + self.image:getPixelHeight() then
			if not self.grabbed then
				self.offset_x = self.x - cur_x
				self.offset_y = self.y - cur_y
			end
			self.grabbed = true
		end
	else
		if self.grabbed then
			-- if just released
			-- snap to a slot if the card is within it
			self:slot_in()
		end

		self.grabbed = false
	end

	if self.grabbed then
		self.x = cur_x + self.offset_x
		self.y = cur_y + self.offset_y
	end
end



function Card.draw(self)
	local image_width, image_height = self.image:getDimensions()

	local y_scale = self.height / image_height
	local x_scale = self.width / image_width


	love.graphics.draw(self.image, self.x, self.y, 0, y_scale, x_scale)
end

function Card:new(o)
	new_card = o
	setmetatable(new_card, Card)
	return new_card
end


function love.load(args, unfilteredArgs)
	love.window.setFullscreen(true)

	slots = {Slot:new({x=240, y=240}), Slot:new({x=720, y=240})}
	quizi_vos = Card:new({x=0, y=0, image = love.graphics.newImage("images/path_cards/Quizi_Vos.jpg")})

end


function love.draw()

	quizi_vos:draw()

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
