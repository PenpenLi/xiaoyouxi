

local BaseSolider = import(".Solider")

local EnemySolider = class("EnemySolider",BaseSolider)

function EnemySolider:onEnter()
	EnemySolider.super.onEnter( self )
	-- 默认 向左边
	self:setDirection("left")
	self._modeType = "enemy"
end





function EnemySolider:moveToBattleRegion()
	EnemySolider.super.moveToBattleRegion( self )

	if self._status == self.STATUS.CREATE then
		self._status = self.STATUS.MARCH
		self:playMove()
		local dest_point = cc.p( self._gameLayer._battleRightX,self:getPositionY() )
		local call_back = function()
			self._status = self.STATUS.CANFIGHT
			self:playIdle()
			self:searchEnemy()
		end
		self:moveToDestPoint( dest_point,call_back )
	end
end


function EnemySolider:searchEnemy()
	-- 1:搜索玩家
	--[[
		1:在玩家队列里面 优先选择 玩家处于可以战斗状态的人 选择出来后，通知他 进行战斗 (选择一条道) 
		然后再通知其他 处于 可以战斗状态的人
	]]
end





return EnemySolider

















