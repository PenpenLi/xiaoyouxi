
local FishLine = import(".FishLine")
local FishNode = import(".FishNode")
local FishLayer = class( "FishLayer",BaseLayer )

function FishLayer:ctor( gameLayer )
    FishLayer.super.ctor( self,"FishLayer" )

    self._gameLayer = gameLayer
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
		return
	end
	local fish_index = random( 1,#buyu_config.fish )
	local fish = FishNode.new( fish_index,self._fishLine )
	self:addChild( fish )
end










return FishLayer