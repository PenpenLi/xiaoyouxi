

local FishLayer = import(".FishLayer")

local GamePlay = class( "GamePlay",BaseLayer )

function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbbuyu/Play.csb" )
end

-- 创建鱼和控制鱼数量的方法
function GamePlay:onEnter()
	GamePlay.super.onEnter( self )

	-- 1:创建鱼层
	local fish_layer = FishLayer.new()
	self:addChild( fish_layer )
	-- 2:子弹层
end












return GamePlay