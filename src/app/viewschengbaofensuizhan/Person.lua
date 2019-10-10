

local Person = class("Person",BaseNode)

Person.ACTION_TYPE = {
	IDLE = 0,
	RUN = 1,
	ATTACK = 2
}


function Person:ctor( id,gameLayer )
	assert( id," !! id is nil !! " )
	assert( gameLayer," !! gameLayer is nil !! " )
	Person.super.ctor( self,"Person" )
	self._id = id
	self._gameLayer = gameLayer
	self._config = nil
	self._attackImgIndex = { 1,2,3,4,5,10,11,12,13,14 }
	self:initConfig()
	self:createIcon()

	self._hp = self._config.hp
	self._status = self.ACTION_TYPE.IDLE
	self._attackDest = nil -- 攻击目标
end


function Person:initConfig()

end


function Person:createIcon()
	self._icon = ccui.ImageView:create(self._config.path.."01.png",1)
	self:addChild( self._icon )
	-- self._icon:setAnchorPoint( cc.p( 1,0 ) )
	self._scheduleTime = 0.18
end


function Person:onEnter()
	Person.super.onEnter( self )
	self:schedule( function()
		self:aiLogic()
	end,0.02 )
end

-- 子类负责实现
function Person:getEnemyList()

end

-- 士兵的逻辑
function Person:aiLogic()
	-- 1:搜索敌人(搜索距离最近的敌人)
	local enemy_list = self:getEnemyList()
	if #enemy_list == 0 then
		self:unSchedule()
		self:pause()
		return
	end

	-- 2:如果已经有攻击目标
	if self._attackDest then
		return
	end

	-- 3:查找自己攻击范围内的敌人
	local enemy_node = self:searchAttackToEnemy()
	if enemy_node then
		-- 攻击该敌人
		self:attackEnemy( enemy_node )
		return
	end
	-- 4:搜索并跑向目标
	local enemy_node = self:searchRunToEnemy()
	if enemy_node then
		self:runToEnemy( enemy_node )
	end
end


function Person:playRunAction()
	if self._status == self.ACTION_TYPE.RUN then
		return
	end
	self._status = self.ACTION_TYPE.RUN
	local index = 6
	self._icon:stopAllActions()
	schedule( self._icon,function()
		local path = self._config.path..string.format("%02d.png",index)
		self._icon:loadTexture( path,1 )
		index = index + 1
		if index > 9 then
			index = 6
		end
	end,self._scheduleTime )
end

function Person:playAttackAction( callBack )
	assert( callBack," !! callBack is nil !! " )
	if self._status == self.ACTION_TYPE.ATTACK then
		return
	end
	self._status = self.ACTION_TYPE.ATTACK
	local index = 1
	self._icon:stopAllActions()
	schedule( self._icon,function()
		local path = self._config.path..string.format("%02d.png",self._attackImgIndex[index])
		self._icon:loadTexture( path,1 )
		index = index + 1
		if index > #self._attackImgIndex then
			callBack()
			index = 1
		end
	end,self._scheduleTime )
end


-- 搜索可以攻击的敌人
function Person:searchAttackToEnemy()
	local enemy_list = self:getEnemyList()
	local m_pos = self:getParent():convertToWorldSpace( cc.p( self:getPosition() ) )
	local min_dis = nil
	local enemy_node = nil
	for i,v in ipairs( enemy_list ) do
		local dest_node = v.node
		if dest_node:getHp() > 0 then
			local enemy_pos = dest_node:getParent():convertToWorldSpace( cc.p( dest_node:getPosition() ) )
			local dis = cc.pGetDistance( m_pos,enemy_pos )
			if dis <= self._config.attack_dis then
				return dest_node
			end
		end
	end
	return nil
end


-- 搜索并跑向目标
function Person:searchRunToEnemy()
	local enemy_list = self:getEnemyList()
	local m_pos = self:getParent():convertToWorldSpace( cc.p( self:getPosition() ) )
	local min_dis = nil
	local enemy_node = nil
	for i,v in ipairs( enemy_list ) do
		local dest_node = v.node
		if dest_node:getHp() > 0 then
			local enemy_pos = dest_node:getParent():convertToWorldSpace( cc.p( dest_node:getPosition() ) )
			local dis = cc.pGetDistance( m_pos,enemy_pos )
			if min_dis == nil then
				min_dis = dis
				enemy_node = dest_node
			else
				if dis < min_dis then
					min_dis = dis
					enemy_node = dest_node
				end
			end
		end
	end
	return enemy_node
end


-- 跑向敌人
function Person:runToEnemy( enemyNode )
	-- 播放跑的动画
	self:playRunAction()

	local m_pos = self:getParent():convertToWorldSpace( cc.p( self:getPosition() ) )
	local enemy_pos = enemyNode:getParent():convertToWorldSpace( cc.p( enemyNode:getPosition() ) )

	local move_x = nil
	if m_pos.x > enemy_pos.x - self._config.attack_dis and m_pos.x < enemy_pos.x then
		move_x = 0
	elseif m_pos.x < enemy_pos.x - self._config.attack_dis then
		enemy_pos.x = enemy_pos.x - self._config.attack_dis
	end
	if m_pos.x < enemy_pos.x + self._config.attack_dis and m_pos.x > enemy_pos.x then
		move_x = 0
	elseif m_pos.x > enemy_pos.x - self._config.attack_dis then
		enemy_pos.x = enemy_pos.x + self._config.attack_dis
	end
	local x = enemy_pos.x - m_pos.x
	local y = enemy_pos.y - m_pos.y
	local k = math.atan2( y,x )
	local r = 90 - k * 180 / math.pi
	local radian = 2 * math.pi/360 * r

	if move_x == nil then
		move_x = math.sin( radian ) * self._config.speed
	end
	local move_y = math.cos( radian ) * self._config.speed
	dump( move_x,"--------------------move_x = ")
	dump( move_y,"--------------------move_y = ")
	--local move_by_pos = cc.p( move_x,move_y )
	m_pos.x = m_pos.x + move_x
	m_pos.y = m_pos.y + move_y
	self:setPosition( cc.p( m_pos.x,m_pos.y ) )


	-- -- 设置X轴
	-- if enemy_pos.x >= m_pos.x then
	-- 	self:setPositionX( self:getPositionX() + self._config.speed )
	-- else
	-- 	self:setPositionX( self:getPositionX() - self._config.speed )
	-- end
	-- -- 设置Y轴
	-- local move_y = self._config.speed / (math.abs(enemy_pos.x - m_pos.x)) * math.abs((enemy_pos.y - m_pos.y))
	-- if enemy_pos.y >= m_pos.y then
	-- 	self:setPositionY( self:getPositionY() + move_y )
	-- else
	-- 	self:setPositionY( self:getPositionY() - move_y )
	-- end
end

-- 攻击敌人
function Person:attackEnemy( enemyNode )
	local call_back = function()
		-- 2:敌人血量减少
		enemyNode:beAttacked( self._config.attack )
	end
	-- 1:播放攻击动画
	self:playAttackAction( call_back )
end

-- 被受攻击
function Person:beAttacked( harmValue )
	assert( harmValue," !! harmValue is nil !! " )
	self._hp = self._hp - harmValue

	-- 播放受伤动画
	self:beAttackedAction()

	if self._hp <= 0 then
		self:dead()
	end
end

function Person:beAttackedAction()
	if self._playBeAttackedActionMark then
		return
	end
	self._playBeAttackedActionMark = true
	local tinto1 = cc.TintTo:create(0.2, 255, 0, 0)
	local tinto2 = cc.TintTo:create(0.1, 255, 255, 255)
	local call_end = cc.CallFunc:create( function()
		self._playBeAttackedActionMark = nil
	end )
	self:runAction( cc.Sequence:create({ tinto1,tinto2,call_end }) )
end

-- 死亡
function Person:dead()
	print("---------------->死亡")
end


function Person:getHp()
	return self._hp
end




return Person