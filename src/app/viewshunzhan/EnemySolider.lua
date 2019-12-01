

local BaseSolider = import(".Solider")

local EnemySolider = class("EnemySolider",BaseSolider)

function EnemySolider:onEnter()
	EnemySolider.super.onEnter( self )
	-- 默认 向左边
	self._modeType = "enemy"
	self._enemyList = self._gameLayer._peopleList

	self._dir = 1 -- 方向 1:向左 2:向右
	self.Icon:getVirtualRenderer():getSprite():setFlipX( true )

	-- 变色
	local loading_sp = self.Hp:getVirtualRenderer():getSprite()
	redSprite( loading_sp )
end

-- 行军到战斗区域
function EnemySolider:moveToBattleRegion()
	-- 出生点在左边
	if self:getPositionX() < self._gameLayer:getBattleLeftX() then
		local speed = self._config.speed
		local pos_x = self:getPositionX()
		self:setPositionX( pos_x + speed )
		self:setDirection( 2 )
		if self:getPositionX() >= self._gameLayer:getBattleLeftX() then
			-- 设置状态
			self:setStatus( self.STATUS.CANFIGHT )
		end
		return
	end

	-- 出生点在右边
	if self:getPositionX() > self._gameLayer:getBattleRightX() then
		local speed = self._config.speed
		local pos_x = self:getPositionX()
		self:setPositionX( pos_x - speed )
		self:setDirection( 1 )
		-- 设置状态
		if self:getPositionX() <= self._gameLayer:getBattleRightX() then
			self:setStatus( self.STATUS.CANFIGHT )
		end
	end
end

return EnemySolider

















