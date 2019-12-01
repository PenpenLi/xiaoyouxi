

local BaseSolider = import(".Solider")

local PeopleSolider = class("PeopleSolider",BaseSolider)

function PeopleSolider:ctor( soliderId,gameLayer )
	PeopleSolider.super.ctor( self,soliderId,gameLayer )
	-- 默认 向右边
	self._modeType = "people"
	self._enemyList = self._gameLayer._enemyList
	self._dir = 2 -- 方向 1:向左 2:向右
	self.Icon:getVirtualRenderer():getSprite():setFlippedX( false )
end


function PeopleSolider:onEnter()
	PeopleSolider.super.onEnter( self )
end


-- 行军到战斗区域
function PeopleSolider:moveToBattleRegion()
	local speed = self._config.speed
	local pos_x = self:getPositionX()
	self:setPositionX( pos_x + speed )

	if self:getPositionX() >= self._gameLayer:getBattleLeftX() then
		-- 设置状态
		self:setStatus( self.STATUS.CANFIGHT )
	end
end


return PeopleSolider