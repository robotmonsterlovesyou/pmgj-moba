zone = inheritsFrom( nil )

zoneStateNormal = 1
zoneStateOnFire = 2

zoneWidth = 100
zoneHeight = 100

function zone:init(options)
	local x = options.x
	local y = options.y

	self.layer = options.layer
	self.width = zoneWidth
	self.height = zoneHeight
	self.zoneState = options.zoneState or zoneStateNormal
	
	self.body = display.newGroup()
	self.layer:insert(self.body)
	self.body.x = x
	self.body.y = y

	self.box = display.newRect(0, 0, self.width, self.height)
	self.letter = display.newText( "zone", 0, 0, native.systemFont, 16 )
	self.box:setStrokeColor(1,1,1,1)
	self.letter:setFillColor(1,0,0,1)

	self.box:setFillColor(0,0,0,0)
	self.box.strokeWidth = 2

	self.body:insert(self.box)
	self.body:insert(self.letter)

	self.held = false

	self.updateTimer = timer.performWithDelay(10, function() 
		self:update()
	end, 0)
end

function zone:update()

	if self.zoneState == zoneStateNormal then
		self.letter:setFillColor(0,0,1,1)
		self.box:setStrokeColor(0,0,1,1)
	else 
		self.letter:setFillColor(1,0,0,1)
		self.box:setStrokeColor(1,0,0,1)
	end 
	-- if self.held then
	-- 	self.body.x = self.owner.body.x
	-- 	self.body.y = self.owner.body.y
	-- end 
end 

function zone:checkCollisions(persons)
	if self.held then return end 

	for k, person in pairs(persons) do
		if (person.body.x + guyWidth/2) > (self.body.x - itemWidth/2) and
			(person.body.x - guyWidth/2) < (self.body.x + itemWidth/2) and
			(person.body.y + guyHeight/2) > (self.body.y - itemHeight/2) and
			(person.body.y - guyHeight/2) < (self.body.y + itemHeight/2) then

			if person.item == nil then
				person:takeItem(self)
				self.owner = person
			else 
				person:dropItem(self.layer)
				person:takeItem(self)
				self.owner = person
			end
		end 
	end 
end 

return zone