

local BaseSolider = import(".Solider")

local EnemySolider = class("EnemySolider",BaseSolider)

function EnemySolider:onEnter()
	EnemySolider.super.onEnter( self )

	-- 默认 向左边
	self:setDirection("left")
end





function EnemySolider:moveToBattleRegion()
	EnemySolider.super.moveToBattleRegion( self )
	local posx = self:getPositionX()
	posx = posx - self._config.speed
	self:setPositionX(posx)
	if posx <= self._gameLayer._battleRightX then
		-- 进入到可以战斗的状态
		self._status = self.STATUS.CANFIGHT
		self:playIdle()
	end
end











return EnemySolider

















