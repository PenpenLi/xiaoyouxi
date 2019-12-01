

local Solider = class("Solider",BaseNode) 



Solider.STATUS = {
	CREATE = 0, -- 刚刚创建的状态
	MARCH = 1, -- 行军状态
	CANFIGHT = 2, -- 可以战斗的状态
	FIGHTMOVE = 3, -- 战斗移动状态
	FIGHT = 4, -- 正在战斗的状态
	FIGHT_HALF = 5, -- 战斗状态，但是没有被人攻击
}

function Solider:ctor( soliderId,gameLayer )
	assert( soliderId," !! soliderId is nil !! " )
	assert( gameLayer," !! gameLayer is nil !! " )
	Solider.super.ctor( self,"Solider" )
	self:addCsb( "csbfensuizhan/NodeSolider.csb" )
	self._id = soliderId
	self._gameLayer = gameLayer
	self._track = random( 1,10 )
	self._guid = getGUID()
	self._config = solider_config[self._id]
	self._status = self.STATUS.CREATE
	self._hp = self._config.hp
	self._enemy = nil -- 敌人

	self._aim = nil -- 目标敌人
	self._isAim = nil -- 是谁的目标
	self._beAttack = false --是否处于被攻击
	self._modeType = "" -- 该人物的类型 people:玩家 enemy:电脑
end



function Solider:setDirection( strType )
	if strType == "left" then
		self.Icon:getVirtualRenderer():getSprite():setFlippedX( true )
	elseif strType == "right" then
		self.Icon:getVirtualRenderer():getSprite():setFlippedX( false )
	end
end

function Solider:onEnter()
	Solider.super.onEnter( self )

	self.Icon:loadTexture( "frame/role"..self._id.."/idle/1.png",1 )
	-- -- 注册消息监听
 --    self:addMsgListener( InnerProtocol.INNER_EVENT_FENSUI_FIGHT_DEAD,function (event)
	-- 	self:enemyDeadNews(event.data[1].guid)
	-- end )
end
-- 发现目标死亡
function Solider:enemyDeadNews(guid)
	if self._hp <= 0 then
		return
	end
	if self._enemy then
		if self._enemy._guid == guid then
			self:stopAllActions()
			self._enemy = nil
			self:setStatus( self.STATUS.CANFIGHT)
			self:playIdle()
			performWithDelay(self,function ( ... )

				self:searchEnemy()
			end,0.1)
			
		end
	end
	
end
-- 发送死亡消息给所有人
function Solider:sendDeadNews()
	local args = {guid = self._guid}
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_FENSUI_FIGHT_DEAD,args )
end

function Solider:playFrameAction( frameName )
	if self._curFrameName == frameName then
		return
	end
	if frameName == "dead_frame" then
		self:sendDeadNews() -- 死亡，发送消息给所有人
		self:destroyOwn()
	end
	self._curFrameName = frameName
	local index = self._config[frameName].fstart
	self.Icon:stopAllActions()
	schedule( self.Icon,function()
		-- if self._hp <= 0 then
		-- 	self:removeFromParent()
		-- 	return
		-- end
		local path = self._config[frameName].path..index..".png"
		self.Icon:loadTexture( path,1 )
		index = index + 1
		if index > self._config[frameName].fend then
			index = self._config[frameName].fstart
			if frameName == "attack_frame" then -- 每次攻击结束
				self:resultOfAttack()
			end
			if frameName == "dead_frame" then
				-- self:sendDeadNews() -- 死亡，发送消息给所有人
				-- self:destroyOwn()
				-- self:sendDeadNews() -- 死亡，发送消息给所有人
				self:removeFromParent()
			end
		end
	end,0.1 )
end
-- 攻击结束，敌人血量减少
function Solider:resultOfAttack()
	if self._enemy._hp == nil then
		self._enemy = nil
		self:setStatus( self.STATUS.CANFIGHT)
		self:playIdle()
		self:searchEnemy()
		return
	end
	
	local hurt_num = self._config.attack_value
	self._enemy._hp = self._enemy._hp - hurt_num
	self:setHpBar()
	if self._enemy._hp <= 0 then

		self._enemy:playDead()
		self._enemy = nil
		self:setStatus( self.STATUS.CANFIGHT)
		self:playIdle()
		self:searchEnemy()
		return
	end

end
-- 死亡，销毁
function Solider:destroyOwn()
	-- print("-----------dead")
	-- dump(self._gameLayer._peopleList,"-------------self._peopleList = ")
	-- dump(self._gameLayer._enemyList,"-------------self._enemyList = ")
	for i,v in ipairs(self._gameLayer._enemyList) do
		if v:getGUID() == self._guid then
			table.remove(self._gameLayer._enemyList,i)
			-- self:removeFromParent()
			return
		end
	end
	for i,v in ipairs(self._gameLayer._peopleList) do
		if v:getGUID() == self._guid then
			table.remove(self._gameLayer._peopleList,i)
			-- self:removeFromParent()
			return
		end
	end
	-- dump(self._peopleList,"-------------self._peopleList = ")
end
-- 血条
function Solider:setHpBar()
	local rate = math.floor( self._hp / self._config.hp * 100 )
	self.Hp:setPercent( rate )
	local rate1 = math.floor( self._enemy._hp / self._enemy._config.hp * 100 )
	self._enemy.Hp:setPercent( rate1 )
end
-- 播放idle动画
function Solider:playIdle()
	self:playFrameAction("idle_frame")
end
-- 播放移动动画
function Solider:playMove()
	self:playFrameAction("move_frame")
end
--播放攻击动画
function Solider:playAttack()
	self:playFrameAction("attack_frame")
end
-- 播放死亡动画
function Solider:playDead()
	self:playFrameAction("dead_frame")
end


function Solider:getTrack()
	return self._track
end
function Solider:getId()
	return self._id
end
function Solider:getAttackDistance()
	return self._config.attack_distance
end
function Solider:getSpeed()
	return self._config.speed
end
function Solider:getGUID()
	return self._guid
end

function Solider:updateStatus()
	-- if self._status == self.STATUS.CREATE then
	-- 	-- 进入行军状态
	-- 	self._status = self.STATUS.MARCH
	-- 	self:playMove()
	-- elseif self._status == self.STATUS.MARCH then
	-- 	-- 行军状态
	-- 	self:moveToBattleRegion()
	-- elseif self._status == self.STATUS.CANFIGHT then
	-- 	-- 可以战斗的状态 进行搜索敌人
	-- 	self:searchEnemy()
	-- elseif self._status == self.STATUS.FIGHTMOVE then
	-- 	-- 战斗行军状态
	-- end
end

-- 子类重写
function Solider:moveToBattleRegion()

end


function Solider:searchEnemy()

end

function Solider:getStatus()
	return self._status
end

function Solider:setStatus( status )
	self._status = status
end

-- 设置目标
function Solider:setAim( node )
	self._aim = node
end
function Solider:getAim()
	-- body
end
-- 设置是谁的目标
function Solider:setIsAim( node )
	self._isAim = node
end
function Solider:getIsAim()
	-- body
end

-- 移动到目标位置
function Solider:moveToDestPoint( destPoint,callBack  )
	local now_pos = cc.p( self:getPosition() )
	local end_pos = clone( destPoint )
	local dis = cc.pGetDistance( now_pos,end_pos )
	local time = dis / self._config.speed

	local move_to = cc.MoveTo:create( time,end_pos )
	local call_back = cc.CallFunc:create( function()
		if callBack then
			callBack()
		end
	end )
	local seq = cc.Sequence:create( { move_to,call_back } )
	self:runAction( seq )
end

-- 匹配未被攻击的敌人后，与自动开始战斗,搜索到敌人，传入敌人node
function Solider:fightingWithEnemy( node )
	self._enemy = node
	node._enemy = self
	self:stopAllActions()
	node:stopAllActions()
	node:setStatus( self.STATUS.FIGHTMOVE )
	self:setStatus( self.STATUS.FIGHTMOVE )
	self:playMove()
	node:playMove()
	local m_pos = cc.p(self:getPosition())
	local e_pos = cc.p(node:getPosition())
	-- 这里需要设置翻转，根据两人相对位置
	if m_pos.x < e_pos.x then
		self:setDirection("right")
		node:setDirection("left")
	else
		self:setDirection("left")
		node:setDirection("right")
	end

	-- local e_dis = node._config.attack_distance -- 敌人攻击距离
	-- 最大攻击距离
	local dix_max = self._config.attack_distance
	if self._config.attack_distance < node:getAttackDistance() then
		dix_max = node:getAttackDistance()
	end
	local e_speed = node._config.speed
	-- 选择一条合适的道
	local track = self:chooseTrack(node)
	-- dump(track,"------------track = ")
	local fight_pos_y = self._gameLayer._trackPosY[track].posY -- 战斗Y坐标，战斗的道
	-- 选择合理的战斗点，还需要根据本条道已有的战斗情况区分
	-- 战斗中心点，按照直线相遇点设置----可能会与攻击距离产生问题，特殊判定
	local x_dis = math.abs(m_pos.x - e_pos.x) -- x轴上的距离
	local fight_pos_x = (self._config.speed * e_pos.x + m_pos.x * e_speed) / (self._config.speed + e_speed) -- 战斗中心点X坐标
	if self._gameLayer._trackPosY[track].bool then
		fight_pos_x = self._gameLayer._trackPosY[track].posX
	else
		self._gameLayer._trackPosY[track].posX = fight_pos_x
	end
	-- local fight_pos_x = cc.pGetDistance( m_mid_pos,e_mid_pos )
	-- 移动终点位置距离中心点距离，处理特殊情况使用
	
	local m_disToMiddle = self._config.speed / (self._config.speed + e_speed) * dix_max
	local e_disToMiddle = e_speed / (self._config.speed + e_speed) * dix_max
	
	-- 区分与敌人的方向
	if m_pos.x < e_pos.x then
		-- 士兵在左，敌人在右
		local m_end_pos = cc.p( fight_pos_x - m_disToMiddle,fight_pos_y)
		local e_end_pos = cc.p( fight_pos_x + e_disToMiddle,fight_pos_y)
		-- 超出战斗区域，调整为边界战斗/第一次战斗移动靠着边界移动
		if m_end_pos.x < m_pos.x then
			e_end_pos.x = e_end_pos.x + m_pos.x - m_end_pos.x
			m_end_pos.x = m_pos.x
		end
		if e_end_pos.x > e_pos.x then
			m_end_pos.x = m_end_pos.x - e_end_pos.x + e_pos.x
			e_end_pos.x = e_pos.x
		end
		-- 士兵攻击距离超过战斗区域
		if self._config.attack_distance > self._gameLayer.CenterPanel:getContentSize().width or node._config.attack_distance > self._gameLayer.CenterPanel:getContentSize().width then
			m_end_pos.x = m_pos.x
			e_end_pos.x = e_pos.x
		end
		-- dump(m_end_pos,"--------m_end_pos = ")
		-- dump(e_end_pos,"--------e_end_pos = ")
		-- dump(cc.pGetDistance(m_end_pos,m_pos),"-------------distance = ")
		-- dump(cc.pGetDistance(e_end_pos,e_pos),"-------------distance = ")
		-- 移动后回调
		local m_callBack = function ()
			-- dump(cc.pGetDistance(cc.p(self:getPosition()),cc.p(node:getPosition())),"-------------distance = ")
			-- 判断是否到达攻击距离
			local m_mid_pos = cc.p(self:getPosition())
			-- local e_mid_pos = cc.p(node:getPosition())
			local dis = cc.pGetDistance( m_mid_pos,e_end_pos )
			-- dump(dis,"-----------dis = ")
			-- 在攻击距离，直接攻击
			if self._config.attack_distance >= dis then
				-- print("------------111111 = ",self._id)
				self:setStatus( self.STATUS.FIGHT )
				self:playAttack()
			else
				-- print("------------222222",self._id)
				-- 不在攻击距离，继续移动到攻击距离
				local time = (dis - self._config.attack_distance) / self._config.speed
				local move_to = cc.MoveTo:create(time,cc.p(m_mid_pos.x + dis - self._config.attack_distance,m_mid_pos.y))
				local call = cc.CallFunc:create(function ()
					self:setStatus( self.STATUS.FIGHT )
					self:playAttack()
					-- dump(cc.p(self:getPosition()),"--------m_end_pos = ")
					-- dump(cc.p(node:getPosition()),"--------e_end_pos = ")
					-- dump(cc.pGetDistance(cc.p(self:getPosition()),cc.p(node:getPosition())),"-------------distance = ")
				end)
				local seq = cc.Sequence:create(move_to,call)
				self:runAction(seq)
			end

		end
		local e_callBack = function ()
			-- 判断是否到达攻击距离
			-- local m_mid_pos = cc.p(self:getPosition())
			local e_mid_pos = cc.p(node:getPosition())
			local dis = cc.pGetDistance( m_end_pos,e_mid_pos )
			-- 在攻击距离，直接攻击
			if node._config.attack_distance >= dis then
				node:setStatus( self.STATUS.FIGHT )
				node:playAttack()
			else
				-- 不在攻击距离，继续移动到攻击距离
				local time = (dis - node._config.attack_distance) / node._config.speed
				local move_to = cc.MoveTo:create(time,cc.p(e_mid_pos.x - dis + node._config.attack_distance,e_mid_pos.y))
				local call = cc.CallFunc:create(function ()
					node:setStatus( self.STATUS.FIGHT )
					node:playAttack()
				end)
				local seq = cc.Sequence:create(move_to,call)
				node:runAction(seq)
			end
		end
		-- 移动到攻击位置
		self:moveToDestPoint(m_end_pos,m_callBack)
		node:moveToDestPoint(e_end_pos,e_callBack)

		-- node:setStatus( self.STATUS.FIGHTMOVE )
		-- self:setStatus( self.STATUS.FIGHTMOVE )
	else
		-- 士兵在右，敌人在左
		local m_end_pos = cc.p( fight_pos_x + m_disToMiddle,fight_pos_y)
		local e_end_pos = cc.p( fight_pos_x - e_disToMiddle,fight_pos_y)
		-- 超出战斗区域，调整为边界战斗/第一次战斗移动靠着边界移动
		if m_end_pos.x > m_pos.x then
			e_end_pos.x = e_end_pos.x + m_pos.x - m_end_pos.x
			m_end_pos.x = m_pos.x
		end
		if e_end_pos.x < e_pos.x then
			m_end_pos.x = m_end_pos.x - e_end_pos.x + e_pos.x
			e_end_pos.x = e_pos.x
		end
		-- 士兵攻击距离超过战斗区域
		if self._config.attack_distance > self._gameLayer.CenterPanel:getContentSize().width or node._config.attack_distance > self._gameLayer.CenterPanel:getContentSize().width then
			m_end_pos.x = m_pos.x
			e_end_pos.x = e_pos.x
		end
		-- 移动后回调
		local m_callBack = function ()
			-- 判断是否到达攻击距离
			local m_mid_pos = cc.p(self:getPosition())
			-- local e_mid_pos = cc.p(node:getPosition())
			local dis = cc.pGetDistance( m_mid_pos,e_end_pos )
			-- 在攻击距离，直接攻击
			if self._config.attack_distance >= dis then
				self:setStatus( self.STATUS.FIGHT )
				self:playAttack()
			else
				-- 不在攻击距离，继续移动到攻击距离
				local time = (dis - self._config.attack_distance) / self._config.speed
				local move_to = cc.MoveTo:create(time,cc.p(m_mid_pos.x - dis + self._config.attack_distance,m_mid_pos.y))
				local call = cc.CallFunc:create(function ()
					self:setStatus( self.STATUS.FIGHT )
					self:playAttack()
				end)
				local seq = cc.Sequence:create(move_to,call)
				self:runAction(seq)
			end
		end
		local e_callBack = function ()
			-- 判断是否到达攻击距离
			-- local m_mid_pos = cc.p(self:getPosition())
			local e_mid_pos = cc.p(node:getPosition())
			local dis = cc.pGetDistance( m_end_pos,e_mid_pos )
			-- 在攻击距离，直接攻击
			if node._config.attack_distance >= dis then
				node:setStatus( self.STATUS.FIGHT )
				node:playAttack()
			else
				-- 不在攻击距离，继续移动到攻击距离
				local time = (dis - node._config.attack_distance) / node._config.speed
				local move_to = cc.MoveTo:create(time,cc.p(e_mid_pos.x + dis - node._config.attack_distance,e_mid_pos.y))
				local call = cc.CallFunc:create(function ()
					node:setStatus( self.STATUS.FIGHT )
					node:playAttack()
				end)
				local seq = cc.Sequence:create(move_to,call)
				node:runAction(seq)
			end
		end
		-- 移动到攻击位置
		self:moveToDestPoint(m_end_pos,m_callBack)
		node:moveToDestPoint(e_end_pos,e_callBack)

		-- node:setStatus( self.STATUS.FIGHTMOVE )
		-- self:setStatus( self.STATUS.FIGHTMOVE )
	end
end
-- 无未被攻击敌人，匹配到被攻击敌人，自动前往开始战斗
-- 如果已有的正在移动，不好算位置，这里没有匹配敌人先进行等待，发现可攻击敌人或是战斗点，再前往
function Solider:fightingToEnemy( node )
	self._enemy = node
	self:stopAllActions()
	self:playMove()
	self:setStatus( self.STATUS.FIGHTMOVE )
	local m_pos = cc.p(self:getPosition())
	local e_pos = cc.p(node:getPosition())
	-- 这里需要设置翻转，根据两人相对位置
	if m_pos.x < e_pos.x then
		self:setDirection("right")
		-- node:setDirection("left")
	else
		self:setDirection("left")
		-- node:setDirection("right")
	end
	local m_dis = self:getAttackDistance()
	-- 士兵目标坐标
	local m_end_pos
	if m_pos.x < e_pos.x then
		m_end_pos = cc.p(e_pos.x - m_dis,e_pos.y)
		if m_end_pos.x < m_pos.x then
			m_end_pos.x = m_pos.x
		end
	else
		m_end_pos = cc.p(e_pos.x + m_dis,e_pos.y)
		if m_end_pos.x > m_pos.x then
			m_end_pos.x = m_pos.x
		end
	end
	-- 士兵移动到目标位置
	local dis = cc.pGetDistance( m_pos,m_end_pos )
	local time = dis / self._config.speed
	local move_to = cc.MoveTo:create(time,m_end_pos)
	local call = cc.CallFunc:create(function ()
		-- 敌人已经不再这里，重新搜索
		if node == nil or node._hp == nil then
			self:setStatus( self.STATUS.CANFIGHT)
			self:playIdle()
			performWithDelay(self,function ( ... )
				self:searchEnemy()
			end,0.1)
			return
		end
		if cc.p(node:getPosition()).x ~= e_pos.x or cc.p(node:getPosition()).y ~= e_pos.y then
			self:setStatus( self.STATUS.CANFIGHT)
			self:playIdle()
			performWithDelay(self,function ( ... )
				self:searchEnemy()
			end,0.1)
			
			return
		end
		self:setStatus( self.STATUS.FIGHT_HALF )
		self:playAttack()
	end)
	local seq = cc.Sequence:create(move_to,call)
	self:runAction(seq)
end
-- 内部方法，外部不可调用
-- 根据双方属性，匹配一条道
function Solider:chooseTrack( node )
	--测试
	local track = random(1,10)
	-- dump(track,"----------chooseTrack = ")
	return track


	-- -- 选择道，需要根据速度，同时需要尽量选择人少的道进行战斗
	-- local e_track = node:getTrack()
	-- if e_track == self._track then
	-- 	return self._track
	-- end
	-- -- 移动速度比例
	-- local t_speed = self._config.speed/node._config.speed
	-- if t_speed < 0.3 then
	-- 	return self._track
	-- elseif t_speed >= 0.3 and t_speed < 0.7 then
	-- end
end


return Solider