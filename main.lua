Card = {height= 340, width= 240, x=nil, y=nil}
Card.__index = Card

Slot = {height=340, width=240}
Slot.__index = Slot

Zone = {height=340, width=1080}
Zone.__index = Zone

ANIMATION_SPEED = 10

function Slot.draw(self)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 2)
end


function Slot:new(o)
	new_slot = o
	setmetatable(new_slot, Slot)
	return new_slot
end


function Zone:new(o)
	new_zone = o
	setmetatable(new_zone, Zone)
	return new_zone

end


function Zone.draw(self)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 2)
end

function Zone.move_cards(self, cards)

	local contained_cards = {}

	for i, card in pairs(cards) do


	end


end


function Card.within(self, x, y, width, height)
	-- check each corner of the card
	-- if any are within the dimensions of the slot return true
	local corners = {
		{x=self.x, y=self.y},
		{x=self.x + self.width, y=self.y},
		{x=self.x, y=self.y + self.height},
		{x=self.x + self.width, y=self.y + self.height}
	}

	for j, corner in pairs(corners) do
		if corner.x >= x and corner.x <= x + width and corner.y >= y and corner.y <= y + height then
			return true
		end
	end
	return false
end


function Card.slot_in(self)

	local slots = slots

	for i, slot in pairs(slots) do
		if self:within(slot.x, slot.y, slot.width, slot.height) then
			self.target_x = slot.x
			self.target_y = slot.y
			return
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


		self:animate(dt)

		self.grabbed = false
	end

	if self.grabbed then
		self.x = cur_x + self.offset_x
		self.y = cur_y + self.offset_y
		self.target_x = self.x
		self.target_y = self.y
	end
end


function Card.animate(self, dt)

	local x_offset = self.target_x - self.x
	local y_offset = self.target_y - self.y


	self.x = self.x + x_offset * ANIMATION_SPEED * dt
	self.y = self.y + y_offset * ANIMATION_SPEED * dt

end



function Card.draw(self)
	local image_width, image_height = self.image:getDimensions()

	local y_scale = self.height / image_height
	local x_scale = self.width / image_width


	love.graphics.draw(self.image, self.x, self.y, 0, y_scale, x_scale)
end

function Card:new(o)
	new_card = o
	new_card.target_x = o.x
	new_card.target_y = o.y
	setmetatable(new_card, Card)
	return new_card
end


function love.load(args, unfilteredArgs)
	love.window.setFullscreen(true)

	slots = {Slot:new({x=720, y=240})}

	-- zones = {Zone:new({x=240, y=240})}
	quizi_vos = Card:new({x=0, y=0, image = love.graphics.newImage("images/path_cards/Quizi_Vos.jpg")})

end


function love.draw()

	quizi_vos:draw()

	for i, slot in pairs(slots) do
		slot:draw()
	end

	-- for i, zone in pairs(zones) do
 	-- 	zone:draw()
 	-- end
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
