

local BaseSolider = import(".Solider")

local PeopleSolider = class("PeopleSolider",BaseSolider)


function PeopleSolider:onEnter()
	PeopleSolider.super.onEnter( self )
	-- 默认 向右边
	self:setDirection("right")
	self._modeType = "people"

	self._enemyList = self._gameLayer._enemyList
end


function PeopleSolider:moveToBattleRegion()
	PeopleSolider.super.moveToBattleRegion( self )

	if self._status == self.STATUS.CREATE then
		self._status = self.STATUS.MARCH
		self:playMove()
		local dest_point = cc.p( self._gameLayer._battleLeftX,self:getPositionY() )
		local call_back = function()
			self._status = self.STATUS.CANFIGHT
			self:playIdle()
			self:searchEnemy()
		end
		self:moveToDestPoint( dest_point,call_back )
	end
end


function PeopleSolider:searchEnemy()

	if self._status ~= self.STATUS.CANFIGHT then
		
		return
	end

	-- 1:搜索玩家
	--[[
		1:在玩家队列里面 优先选择 玩家处于可以战斗状态的人 选择出来后，通知他 进行战斗 (选择一条道) 
		然后再通知其他 处于 可以战斗状态的人
	]]

	for i,enemy in ipairs( self._enemyList ) do
		if enemy:getStatus() == self.STATUS.CANFIGHT then
			-- 计算要战斗的赛道
			local track = random( self._track,enemy:getTrack() )

			-- 自己跑到要战斗的点
			-- self:moveToDestPoint( dest_point,call_back )
			-- enemy:moveToDestPoint( dest_point,call_back )

			enemy:setStatus( self.STATUS.FIGHTMOVE )
			self:setStatus( self.STATUS.FIGHTMOVE )

			return
		end
	end
	

end


return PeopleSolider