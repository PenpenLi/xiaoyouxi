

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


-- 设置要移动的目标点
function PeopleSolider:setMoveSelectPos( col,row )
	if self._status ~= self.STATUS.MOVE then
		self:unscheduleUpdate()
		self:stopAllActions()
		self:setStatus( self.STATUS.MOVE )
		self:runToEnemy( { col = col,row = row } )
		self._gameLayer:createTargetCsb( col,row )
		self._gameLayer:clearSelectPeople()
	end
end


return PeopleSolider