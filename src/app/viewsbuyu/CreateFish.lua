
local FishLine = import(".FishLine")
local SharkFishNode = import(".SharkFishNode")

local CreateFish = class( "CreateFish",BaseLayer )

function CreateFish:ctor( param )
	self._parent = param

	-- for i=1,50 do
	-- 	local fish = SharkFishNode.new()
	-- 	dump( fish,"-----------fish1 = ")
	-- 	param:addChild( fish )
	-- 	-- self:line11( fish )
	-- 	FishLine:line11( fish )
	-- end

	-- local fish = SharkFishNode.new()
	-- dump( fish,"-----------fish1 = ")
	-- param:addChild( fish )
	-- -- self:shark( fish )
	-- FishLine:line11( fish )

	self:createMaxFish()
end


function CreateFish:onEnter()
	
end

function CreateFish:createMaxFish( ... )
	local max = 50
	print("---------------1111111111")
	local num = 0
	self:schedule( function ()
		local fish = SharkFishNode.new()
		dump( fish,"-----------fish1 = ")
		self._parent:addChild( fish )
		-- self:shark( fish )
		FishLine:line11( fish )
		num = num + 1
		if num == max then
			self:unSchedule()
		end
	end,1 )
end










return CreateFish