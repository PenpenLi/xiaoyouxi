

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

-- 设置出生点位  1:在左边 2:在右边 
function EnemySolider:setCreatePoint( pointType )
	self._pointType = pointType
	if self._pointType == 1 then
		self._borderX = self._gameLayer:getBattleLeftX() + random( 150,1000 )
	else
		self._borderX = self._gameLayer:getBattleRightX() - random( 150,1000 )
	end
end

function EnemySolider:onEnter()
	EnemySolider.super.onEnter( self )
end

-- 行军到战斗区域
function EnemySolider:moveToBattleRegion()
	-- 出生点在左边
	if self._pointType == 1 then
		local border = nil
		if #self._enemyList == 0 then
			border = self._borderX
		else
			border = self._gameLayer:getBattleLeftX()
		end
		local speed = self._config.speed
		local pos_x = self:getPositionX()
		self:setPositionX( pos_x + speed )
		self:setDirection( 2 )
		if self:getPositionX() >= border then
			-- 设置状态
			self:setStatus( self.STATUS.CANFIGHT )
		end
		return
	end

	-- 出生点在右边
	if self._pointType == 2 then
		local border = nil
		if #self._enemyList == 0 then
			border = self._borderX
		else
			border = self._gameLayer:getBattleRightX()
		end
		local speed = self._config.speed
		local pos_x = self:getPositionX()
		self:setPositionX( pos_x - speed )
		self:setDirection( 1 )
		-- 设置状态
		if self:getPositionX() <= border then
			self:setStatus( self.STATUS.CANFIGHT )
		end
	end
end

return EnemySolider

















