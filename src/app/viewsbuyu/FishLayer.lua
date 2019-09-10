
local FishLine = import(".FishLine")
local FishNode = import(".FishNode")
local FishLayer = class( "FishLayer",BaseLayer )

function FishLayer:ctor( gameLayer )
    FishLayer.super.ctor( self,"FishLayer" )

    self._gameLayer = gameLayer
    self._fishLine = FishLine.new()

    self._fishContainer = cc.Node:create()
    -- dump( self._fishContainer,"-----------self._fishContainer = ")
    self:addChild( self._fishContainer )

    self._iceState = false -- 冰封技能，不创建鱼
end


function FishLayer:onEnter()
	FishLayer.super.onEnter( self )

	self:schedule( function ()
		self:createFish()
	end,0.5 )
end

function FishLayer:createFish()
	if self._iceState then
		return
	end
	local childs = self._fishContainer:getChildren()
	-- dump( childs,"--------------childs = ")
	if #childs >= 50 then
		return
	end
	local fish_index = random( 1,#buyu_config.fish )
	-- if self._gameLayer._playLevel == 1 then
	-- 	local fish_index = random( 1,#buyu_config.fish1 )
	-- else
	-- 	local fish_index = random( 1,#buyu_config.fish2 )
	-- end
	
	local fish = FishNode.new( self._gameLayer,fish_index,self._fishLine )
	self._fishContainer:addChild( fish )
end










return FishLayer