

local BaseSolider = import(".Solider")

local EnemySolider = class("EnemySolider",BaseSolider)

function EnemySolider:onEnter()
	EnemySolider.super.onEnter( self )
	-- 默认 向左边
	self:setDirection("left")
	self._modeType = "enemy"
	self._enemyList = self._gameLayer._peopleList
end

-- 行军到战斗区域
function EnemySolider:moveToBattleRegion()
	if self:getPositionX() > self._gameLayer:getBattleRightX() then
		local speed = self._config.speed
		local pos_x = self:getPositionX()
		self:setPositionX( pos_x - speed )
		if self:getPositionX() <= self._gameLayer:getBattleRightX() then
			-- 设置状态
			self:setStatus( self.STATUS.CANFIGHT )
		end
	end
end

return EnemySolider

















