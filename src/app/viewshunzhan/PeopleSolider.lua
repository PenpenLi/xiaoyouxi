

local BaseSolider = import(".Solider")

local PeopleSolider = class("PeopleSolider",BaseSolider)


function PeopleSolider:onEnter()
	PeopleSolider.super.onEnter( self )
	-- 默认 向右边
	self:setDirection("right")
	self._modeType = "people"
	self._enemyList = self._gameLayer._enemyList
end


-- 行军到战斗区域
function PeopleSolider:moveToBattleRegion()
	if self:getPositionX() < self._gameLayer:getBattleLeftX() then
		local speed = self._config.speed
		local pos_x = self:getPositionX()
		self:setPositionX( pos_x + speed )

		if self:getPositionX() >= self._gameLayer:getBattleLeftX() then
			-- 设置状态
			self:setStatus( self.STATUS.CANFIGHT )
		end
	end
end


return PeopleSolider