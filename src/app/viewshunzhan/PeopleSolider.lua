

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

-- 设置要移动的目标点
function PeopleSolider:setMoveSelectPos( pos )
	self._selectDestPos = pos
	self:setStatus( self.STATUS.SELECT )
	self:unscheduleUpdate()
	self:playMove()
	self:onUpdate( function() self:updateStatus() end )
end

function PeopleSolider:moveToSelectPos()
	local p1 = cc.p( self:getPosition() )
	local p2 = self._selectDestPos
	-- 设置朝向
	if p1.x < p2.x then
		self:setDirection( 2 )
	elseif p1.x > p2.x then
		self:setDirection( 1 )
	end
	local dis = cc.pGetDistance( p1,p2 )
	if dis > 5 then
		local x_speed,y_speed = self:getAngleBySpeedForXAndY( p1,p2,self._config.speed )
		local pos_x = self:getPositionX() + x_speed
		local pos_y = self:getPositionY() + y_speed
		self:setPositionX( pos_x )
		self:setPositionY( pos_y )
	else
		-- 到达目标
		self:resetCanFightStatus()
		self._gameLayer:clearSelectPeople()
	end
end

return PeopleSolider