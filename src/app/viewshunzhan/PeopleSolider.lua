

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

	-- 添加点击
	TouchNode.extends( self.Icon, function(event)
		return self:touchPeople( event ) 
	end )
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




function PeopleSolider:touchPeople( event )
	if event.name == "began" then
		self._startPos = cc.p(event.x,event.y)
		return true
	elseif event.name == "moved" then
		
	elseif event.name == "ended" then
		local now_pos = cc.p(event.x,event.y)
	end
end


return PeopleSolider