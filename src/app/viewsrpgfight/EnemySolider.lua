

local BaseSolider = import(".Solider")

local EnemySolider = class("EnemySolider",BaseSolider)

function EnemySolider:ctor( soliderId,gameLayer )
	EnemySolider.super.ctor( self,soliderId,gameLayer )
	-- 默认 向左边
	self._modeType = "enemy"
	self._enemyList = self._gameLayer._peopleList
	self._dir = 1 -- 方向 1:向左 2:向右
	self.Icon:getVirtualRenderer():getSprite():setFlippedX( true )
	-- 变色
	local loading_sp = self.Hp:getVirtualRenderer():getSprite()
	redSprite( loading_sp )
end


function EnemySolider:onEnter()
	EnemySolider.super.onEnter( self )
end


return EnemySolider

















