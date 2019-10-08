
local Person = import(".Person")
local Soldier = class("Soldier",Person)


function Soldier:initConfig()
	self._config = chengbao_config.soldier[self._id]
end


-- 士兵的逻辑
function Soldier:aiLogic()
	-- 1:搜索敌人(搜索距离最近的敌人)
	local enemy_list = self._gameLayer:getEnemyList()
	if #enemy_list == 0 then
		-- self:unSchedule()
		-- self:pause()
		return
	end
	-- 2:查找自己攻击范围内的敌人
	local enemy_node = self:searchAttackToEnemy()
	if enemy_node then
		-- 攻击该敌人
		self:attackEnemy( enemy_node )
		return
	end
	-- 3:搜索并跑向目标
	local enemy_node,min_dis = self:searchRunToEnemy()
	if enemy_node then
		self:runToEnemy( enemy_node )
	end
end


-- 搜索可以攻击的敌人
function Soldier:searchAttackToEnemy()
	local enemy_list = self._gameLayer:getEnemyList()
	local m_pos = self:getParent():convertToWorldSpace( cc.p( self:getPosition() ) )
	local min_dis = nil
	local enemy_node = nil
	for i,v in ipairs( enemy_list ) do
		if v:getHp() > 0 then
			local enemy_pos = v:getParent():convertToWorldSpace( cc.p( v:getPosition() ) )
			local dis = cc.pGetDistance( m_pos,enemy_pos )
			if dis < self._config.attack_dis then
				return v
			end
		end
	end
	return nil
end

-- 搜索并跑向目标
function Soldier:searchRunToEnemy()
	local enemy_list = self._gameLayer:getEnemyList()
	local m_pos = self:getParent():convertToWorldSpace( cc.p( self:getPosition() ) )
	local min_dis = nil
	local enemy_node = nil
	for i,v in ipairs( enemy_list ) do
		if v:getHp() > 0 then
			local enemy_pos = v:getParent():convertToWorldSpace( cc.p( v:getPosition() ) )
			if m_pos.x + self._config.attack_dis <= enemy_pos.x then
				local dis = cc.pGetDistance( m_pos,enemy_pos )
				if min_dis == nil then
					min_dis = dis
					enemy_node = v
				else
					if dis < min_dis then
						min_dis = dis
						enemy_node = v
					end
				end
			end
		end
	end
	return enemy_node,min_dis
end

-- 跑向敌人
function Soldier:runToEnemy( enemyNode )
	-- 播放跑的动画
	self:playRunAction()
	-- 设置X轴
	self:setPositionX( self:getPositionX() + self._config.speed )
	-- 设置Y轴
end

-- 攻击敌人
function Soldier:attackEnemy( enemyNode )
end


return Soldier