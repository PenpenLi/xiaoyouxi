

local BaseSolider = import(".Solider")

local EnemySolider = class("EnemySolider",BaseSolider)

function EnemySolider:onEnter()
	EnemySolider.super.onEnter( self )
	-- 默认 向左边
	self:setDirection("left")
	self._modeType = "enemy"
	self._peopleList = self._gameLayer._peopleList
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

	if self._status ~= self.STATUS.CANFIGHT then
		
		return
	end

	-- 1:搜索玩家
	--[[
		1:在玩家队列里面 优先选择 玩家处于可以战斗状态的人 选择出来后，通知他 进行战斗 (选择一条道) 
		然后再通知其他 处于 可以战斗状态的人
	]]
	print("-----------------searchEnemy")
	local enemyList_canfight = false -- 先判断是否有未被攻击的敌人，有的话匹配，没有才执行正在战斗或是递归
	local fighting_enemy = {}
	for i,v in ipairs(self._peopleList) do
		if v._status == self.STATUS.CANFIGHT or v._status == self.STATUS.FIGHT_HALF then
			enemyList_canfight = true
			break
		else
			table.insert( fighting_enemy,v )
		end
	end
	for i,enemy in ipairs( self._peopleList ) do
		-- dump(enemy:getStatus(),"-------------STATUS = ")
		if enemyList_canfight == true then
			if enemy:getStatus() == self.STATUS.CANFIGHT or enemy:getStatus() == self.STATUS.FIGHT_HALF then
				-- 自己跑到要战斗的点
				self:fightingWithEnemy(enemy)
				return
			end
		elseif enemy:getStatus() == self.STATUS.FIGHT then
			-- 搜索正在战斗的敌人
			local x = random(1,#fighting_enemy)
			self:fightingToEnemy(fighting_enemy[x])
			-- if enemy:getStatus() == self.STATUS.FIGHT then
			-- 	self:fightingToEnemy(enemy)
			-- 	-- dump(self._status,"-------------- enemyStatus = ")
			-- 	return
			-- end
			return
		end
		
	end
	-- 未找到敌人
	performWithDelay(self,function ()
		self:searchEnemy()
	end,1)
end
-- function EnemySolider:searchEnemy()

-- 	if self._status ~= self.STATUS.CANFIGHT then
		
-- 		return
-- 	end

-- 	-- 1:搜索玩家
-- 	--[[
-- 		1:在玩家队列里面 优先选择 玩家处于可以战斗状态的人 选择出来后，通知他 进行战斗 (选择一条道) 
-- 		然后再通知其他 处于 可以战斗状态的人
-- 	]]
-- 	print("-----------------searchEnemy")
-- 	for i,enemy in ipairs( self._peopleList ) do
-- 		if enemy:getStatus() == self.STATUS.CANFIGHT then
-- 			-- 计算要战斗的赛道
-- 			local track = random( self._track,enemy:getTrack() )
			
-- 			local fight_pos_y = self._gameLayer._trackPosY[track].posY -- 战斗Y坐标，战斗的道
-- 			-- 士兵与敌人最大攻击距离,战斗位置距离
-- 			local dix_max = self._config.attack_distance

-- 			if self._config.attack_distance < enemy:getAttackDistance() then
-- 				dix_max = enemy:getAttackDistance()
-- 			end
-- 			-- dump(dix_max,"-------------------------------dix_max = ")
-- 			-- 计算需要移动的位置点
-- 			-- local m_toPos,e_toPos = self:getFightPos(enemy)
-- 			local m_pos = cc.p(self:getPosition())
-- 			local e_pos = cc.p(enemy:getPosition())
-- 			-- 求目标点x坐标的一元二次方程因式a,b,c
-- 			local e_speed = enemy:getSpeed() -- 敌人速度
-- 			-- local e_speed = 100
-- 			local m_speed = self._config.speed -- 士兵速度
-- 			local a = e_speed * e_speed - m_speed * m_speed 
-- 			dump(a,"-----------a = ")
-- 			local b = m_speed * m_speed * 2 * (e_pos.x + dix_max) - e_speed * e_speed * 2 * m_pos.x
-- 			dump(b,"-----------b = ")
-- 			local c = e_speed * e_speed * m_pos.x * m_pos.x - m_speed * m_speed * (e_pos.x + dix_max) *(e_pos.x + dix_max) - m_speed * m_speed * (fight_pos_y - e_pos.y)*(fight_pos_y - e_pos.y) +e_speed * e_speed * (fight_pos_y - m_pos.y) *(fight_pos_y - m_pos.y) 
-- 			dump(c,"-----------c = ")
-- 			-- b*b - 4ac
-- 			local i = math.sqrt(b * b - 4 * a * c)
-- 			dump(i,"-----------i = ")
-- 			local x1
-- 			local x2
-- 			if a ~= 0 then
-- 				x1 = (-b + i)/2/a
-- 				x2 = (-b - i)/2/a
-- 				if x1 < x2 then
-- 					x1 = x2
-- 				end
-- 			else
-- 				x1 = - c/b
-- 			end
-- 			local fight_pos_m = cc.p(x1,fight_pos_y) -- 
-- 			local fight_pos_e = cc.p(x1-dix_max,fight_pos_y) 
			
-- 			dump(x1,"----------x1 = ")
-- 			dump(x2,"----------x2 = ")
-- 			-- 自己跑到要战斗的点
-- 			-- self._status = self.STATUS.FIGHTMOVE
-- 			-- enemy._status = enemy.STATUS.FIGHTMOVE
-- 			self:playMove()
-- 			enemy:playMove()
-- 			local call_back = function ( ... )
-- 				-- 判断是否到达攻击距离
-- 				local m_mid_pos = cc.p(self:getPosition())
-- 				local e_mid_pos = cc.p(enemy:getPosition())
-- 				local dis = cc.pGetDistance( m_mid_pos,e_mid_pos )
-- 				-- 在攻击距离，直接攻击
-- 				if self._config.attack_distance >= dis then
-- 					self:playAttack()
-- 				else
-- 					-- 不在攻击距离，继续移动到攻击距离
-- 					local time = (dis - self._config.attack_distance) / self._config.speed
-- 					local move_to = cc.MoveTo:create(time,cc.p(m_mid_pos.x - dis + self._config.attack_distance,m_mid_pos.y))
-- 					local call = cc.CallFunc:create(function ()
-- 						self:playAttack()
-- 					end)
-- 					local seq = cc.Sequence:create(move_to,call)
-- 					self:runAction(seq)
-- 				end
-- 				-- self:playAttack()
-- 			end
-- 			local call_back1 = function ( ... )
-- 				-- 判断是否到达攻击距离
-- 				local m_mid_pos = cc.p(self:getPosition())
-- 				local e_mid_pos = cc.p(enemy:getPosition())
-- 				local dis = cc.pGetDistance( m_mid_pos,e_mid_pos )
-- 				-- 在攻击距离，直接攻击
-- 				if enemy._config.attack_distance >= dis then
-- 					enemy:playAttack()
-- 				else
-- 					-- 不在攻击距离，继续移动到攻击距离
-- 					local time = (dis - enemy._config.attack_distance) / enemy._config.speed
-- 					local move_to = cc.MoveTo:create(time,cc.p(e_mid_pos.x + dis - enemy._config.attack_distance,e_mid_pos.y))
-- 					local call = cc.CallFunc:create(function ()
-- 						enemy:playAttack()
-- 					end)
-- 					local seq = cc.Sequence:create(move_to,call)
-- 					enemy:runAction(seq)
-- 				end
-- 				-- enemy:playAttack()
-- 			end
-- 			self:moveToDestPoint(fight_pos_m,call_back)
-- 			enemy:moveToDestPoint(fight_pos_e,call_back1)
-- 			-- self:moveToDestPoint( dest_point,call_back )
-- 			-- enemy:moveToDestPoint( dest_point,call_back )

-- 			enemy:setStatus( self.STATUS.FIGHTMOVE )
-- 			self:setStatus( self.STATUS.FIGHTMOVE )

-- 			return
-- 		end
-- 	end
-- 	-- function PeopleSolider:getFightPos(node)
-- 	-- 	local m_pos = cc.p(self:getPosition())
-- 	-- 	local e_pos = cc.p(node:getPosition())
-- 	-- end

-- end
-- function EnemySolider:searchEnemy()
-- 	-- 1:搜索玩家
-- 	--[[
-- 		1:在玩家队列里面 优先选择 玩家处于可以战斗状态的人 选择出来后，通知他 进行战斗 (选择一条道) 
-- 		然后再通知其他 处于 可以战斗状态的人
-- 	]]
-- end





return EnemySolider

















