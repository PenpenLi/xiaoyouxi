
local FishLine = import(".FishLine")
local FishNode = import(".FishNode")
local FishLayer = class( "FishLayer",BaseLayer )

function FishLayer:ctor()
    FishLayer.super.ctor( self,"FishLayer" )

    self._fishArray = {}
    self._fishLine = FishLine.new()
end


function FishLayer:onEnter()
	FishLayer.super.onEnter( self )

	self:schedule( function ()
		self:createFish()
	end,0.5 )
end

function FishLayer:createFish()
	local childs = self:getChildren()
	if #childs >= 50 then
		print("------------------> 不需要创建新鱼")
		return
	end
	print("-----------------> 创建新鱼")
	local fish_index = random( 1,#buyu_config.fish )
	local fish = FishNode.new( fish_index,self._fishLine )
	self:addChild( fish )
end










return FishLayer