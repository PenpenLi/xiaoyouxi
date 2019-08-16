
local FishLine = import(".FishLine")
local SharkFishNode = import(".SharkFishNode")

local CreateFish = class( "CreateFish",BaseLayer )

function CreateFish:ctor( param )

	for i=1,50 do
		local fish = SharkFishNode.new()
		dump( fish,"-----------fish1 = ")
		param:addChild( fish )
		-- self:shark( fish )
		FishLine:shark( fish )
	end
end


function CreateFish:onEnter()
	
end












return CreateFish