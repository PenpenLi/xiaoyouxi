

local BaseSolider = import(".Solider")

local PeopleSolider = class("PeopleSolider",BaseSolider)


function PeopleSolider:onEnter()
	PeopleSolider.super.onEnter( self )
	-- 默认 向右边
	self:setDirection("right")
end


function PeopleSolider:moveToBattleRegion()
	PeopleSolider.super.moveToBattleRegion( self )
	local posx = self:getPositionX()
	posx = posx + self._config.speed
	self:setPositionX(posx)
	if posx >= self._gameLayer._battleLeftX then
		-- 进入到可以战斗的状态
		self._status = self.STATUS.CANFIGHT
		self:playIdle()
	end
end


return PeopleSolider