local Platform = require "scripts.platform"
local Person = require "scripts.person"
local Item = require "scripts.item"
local Zone = require "scripts.zone"
-- local physics = require "physics"

board = inheritsFrom( nil )

function board:init(options)
	-- physics.start()
	-- physics.setGravity(0,0)
	-- physics.pause()

	self.boardLayer = options.layer

	self.platformLayer = display.newGroup()
	self.boardLayer:insert(self.platformLayer)

	self.itemLayer = display.newGroup()
	self.boardLayer:insert(self.itemLayer)
	
	self.personLayer = display.newGroup()
	self.boardLayer:insert(self.personLayer)

	function createPersons()
		self.persons = {}

		self.redPlayer = Person:create({
			layer = self.personLayer,
			x = 50, y = 768 - 120,
			teamNumber = 1,
			collisionEntities = self.entities
		})
		table.insert(self.persons, self.redPlayer)

		self.bluePlayer = Person:create({
			layer = self.personLayer,
			x = 1024-50, y = 768 - 120,
			teamNumber = 2,
			collisionEntities = self.entities
		})
		table.insert(self.persons, self.bluePlayer)
	end 

	function createPlatforms()
		self.entities = {};

		function createPlatform(x, y, w, h)
			table.insert(self.entities, Platform:create({
				layer = self.platformLayer,
				x = x, y = y,
				width = w, height = h
			}))
		end 

		createPlatform(260, 768 - 441, 320, 15)
		createPlatform(1024 - 270, 768 - 441, 320, 15)
		createPlatform(1024/2, 768 - 331, 320, 15)
		createPlatform(260, 768-231, 320, 15)
		createPlatform(1024-270, 768-231, 320, 15)
		
		-- floor
		createPlatform(1024/2, 768-89, 1024, 30)
	end

	function createItems()
		self.items = {};

		function createItem(x, y, itemType, otherimage)
			table.insert(self.items, Item:create({
				layer = self.itemLayer,
				x = x, y = y,
				itemType = itemType,
				otherimage = otherimage
			}))
		end 

		createItem(200, 150, itemTypeFlameThrower)
		createItem(350, 150, itemTypeExtinguisher)


		createItem(1024- 350, 150, itemTypeFlameThrower, true)
		createItem(1024-200, 150, itemTypeExtinguisher, true)
	end

	function createZones()
		self.zones = {};

		function createZone(x, y, artPieceIndex, zoneState)
			table.insert(self.zones, Zone:create({
				layer = self.itemLayer,
				x = x, y = y,
				artPieceIndex = artPieceIndex,
				zoneState = zoneState
			}))
		end 

		createZone(200, 300, 1, 2)
		createZone(1024-200, 300, 2)

		createZone(200, 510, 3, 2)
		createZone(1024-200, 510, 4)

		createZone(1024/2, 380, 5)
		createZone(1024/2, 580, 6, 2)
	end

	createPlatforms()
	createPersons()
	createItems()
	createZones()

	self.updateTimer = timer.performWithDelay(20, function() 
		self:update()
	end, 0)
end

function board:update()
	for i, person in ipairs(self.persons) do
		person:setMinY(self.entities)
	end

	for i, person in ipairs(self.persons) do
		person:setPunchTarget(self.persons)
	end

	for i, item in ipairs(self.items) do
		item:checkCollisions(self.persons)
	end

	for i, zone in ipairs(self.zones) do
		zone:checkCollisions(self.persons)
	end

end 

return board