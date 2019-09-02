

local FishLayer   = import(".FishLayer")
local BulletLayer = import(".BulletLayer")

local GamePlay = class( "GamePlay",BaseLayer )

function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbbuyu/Play.csb" )

    -- 1:创建鱼层
	local fish_layer = FishLayer.new( self )
	self:addChild( fish_layer,1 )
	self._fishLayer = fish_layer
	-- 2:子弹层
	local bullet_layer = BulletLayer.new( self )
	self:addChild( bullet_layer,2 )
	self._bulletLayer = bullet_layer
end

-- 创建鱼和控制鱼数量的方法
function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
end

-- 获取鱼层
function GamePlay:getFishLayer( ... )
	return self._fishLayer
end










return GamePlay