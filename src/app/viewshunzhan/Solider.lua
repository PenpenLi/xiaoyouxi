

local Solider = class("Solider",BaseNode) 

Solider.STATUS = {
	CREATE = "create", -- 刚刚创建的状态
	MARCH = "march", -- 行军状态
	CANFIGHT = "can_fight", -- 可以战斗的状态 搜索敌人
	ATTACK = "attack", -- 攻击敌人状态
	DEAD = "dead", -- 死亡状态
}

function Solider:ctor( soliderId,gameLayer )
	assert( soliderId," !! soliderId is nil !! " )
	assert( gameLayer," !! gameLayer is nil !! " )
	Solider.super.ctor( self,"Solider" )
	self:addCsb( "csbhunzhan/NodeSolider.csb" )
	self._id = soliderId
	self._gameLayer = gameLayer
	self._guid = getGUID()
	self._config = hunsolider_config[self._id]
	self._status = self.STATUS.CREATE
	self._hp = self._config.hp
	self._dir = 1 -- 方向 1:向左 2:向右
	self._modeType = "" -- "people" 玩家 "enemy" 敌人

	self._destEnemy = nil -- 自己的目标敌人
	self._attackedMyEnemyList = {}  -- 攻击自己的敌人列表

	self:setScale( 0.8 )
end


-- 子类重写
function Solider:setDirection( dir )
	if self._dir ~= dir then
		self._dir = dir
		self.Icon:getVirtualRenderer():getSprite():setFlipX( self._dir == 1 )
	end
end

function Solider:onEnter()
	Solider.super.onEnter( self )
	-- 设置位置的偏移量 让其居中
	-- self.Icon:setPositionX( self._config.image_offsetx )
	-- 开帧
	self:onUpdate( function() self:updateStatus() end )
end

function Solider:playFrameAction( frameName,isRepeate,callBack )
	if self._curFrameName and self._curFrameName == frameName then
		self:printLog("帧重复了 self._curFrameName = "..self._curFrameName.." isRepeate = "..tostring(isRepeate))
		if not isRepeate then
			callBack()
		end
		return
	end
	self._curFrameName = frameName
	local index = 1
	self.Icon:stopAllActions()
	schedule( self.Icon,function()
		local frame = self._config[frameName].frames[index]
		local path = self._config[frameName].path..frame..".png"
		self.Icon:loadTexture( path,1 )
		index = index + 1
		if index > #self._config[frameName].frames then
			if not isRepeate then
				self.Icon:stopAllActions()
				self._curFrameName = nil
			else
				index = 1
			end
			if callBack then
				callBack()
			end
		end
	end,0.1 )
end

function Solider:printLog( str )
	-- print( string.format( " 自己的 type = %s hp= %s guid = %s,statue= %s 额外信息 = %s",self._modeType,self._hp,self._guid,self._status,str ) )
end

-- 播放idle动画
function Solider:playIdle( isRepeate,callBack )
	self:playFrameAction("idle_frame",isRepeate,callBack)
end
-- 播放移动动画
function Solider:playMove()
	self:playFrameAction("move_frame",true)
end
--播放攻击动画
function Solider:playAttack( callBack )
	local call_set = function()
		-- 添加箭头
		if self._destEnemy and self._config.attack_type == 2 then
			local color_layer = cc.LayerColor:create( cc.c4b( 255,0,0,255 ) )
			color_layer:setContentSize( cc.size( 20,5 ) )
			self:addChild( color_layer )
			local world_pos = self._destEnemy:getParent():convertToWorldSpace( cc.p( self._destEnemy:getPosition() ) )
			local node_pos = self:convertToNodeSpace( world_pos )
			local move_to = cc.MoveTo:create(0.1,node_pos)
			local remove = cc.RemoveSelf:create()
			local seq = cc.Sequence:create({ move_to,remove })
			color_layer:runAction( seq )
		end
		if callBack then
			callBack()
		end
	end
	self:playFrameAction("attack_frame",false,call_set )
end
-- 播放死亡动画
function Solider:playDead( callBack )
	self:playFrameAction("dead_frame",false,callBack )
end
function Solider:getHp()
	return self._hp
end
function Solider:setHpByHurt( hurtValue )
	self._hp = self._hp - hurtValue
	self:printLog( "当前正在受到攻击的log" )
	self.Hp:setPercent( self._hp / self._config.hp * 100 )
	if self._hp <= 0 then
		-- 死亡
		self:setDead()
	end
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
function Solider:getModeType()
	return self._modeType
end
function Solider:getSoliderGUID()
	return self._guid
end
function Solider:getStatus()
	return self._status
end

function Solider:setStatus( status )
	if self._status ~= status then
		self._status = status
	end
end

function Solider:getBeAttackedList()
	return self._attackedMyEnemyList
end

-- 获取设计尺寸的bouningBox
function Solider:getDesignBoundingBox()
	local pos = cc.p( self:getPosition() )
	local world_pos = self:getParent():convertToWorldSpace( pos )
	local size = self._config.size
	local box_size = {
		width = size.width,
		height = size.height,
		x = world_pos.x - size.width / 2,
		y = world_pos.y - size.height / 2
	}
	return box_size
end

-- 获取攻击尺寸的bouningBox
function Solider:getAttackBoundingBox()
	local pos = cc.p( self:getPosition() )
	local world_pos = self:getParent():convertToWorldSpace( pos )
	local size = self._config.size
	local box_size = {}
	if self._dir == 1 then
		-- 面向左边
		box_size = {
			width = self._config.attack_distance,
			height = size.height,
			x = world_pos.x - self._config.attack_distance,
			y = world_pos.y - size.height / 2
		}
	elseif self._dir == 2 then
		-- 面向右边
		box_size = {
			width = self._config.attack_distance,
			height = size.height,
			x = world_pos.x,
			y = world_pos.y - size.height / 2
		}
	end
	return box_size
end


-- 加入solider到攻击自己的敌人队列中
function Solider:addAttackMyEnemyList( solider )
	local guid = solider:getSoliderGUID()
	self._attackedMyEnemyList[guid] = solider
end

function Solider:removeAttackMyEnemyList( guid )
	assert( guid," !! guid is nil !! " )
	if self._attackedMyEnemyList[guid] then
		self._attackedMyEnemyList[guid] = nil
	end
end




function Solider:updateStatus()
	if self._status == self.STATUS.CREATE then
		-- 进入行军状态
		self:printLog( string.format( " 1 >> 士兵 类型 = %s guid = %s,进入状态 %s",self._modeType,self._guid,self._status ) )
		self:setStatus( self.STATUS.MARCH )
		self:playMove()
	elseif self._status == self.STATUS.MARCH then
		-- 行军状态
		self:printLog( string.format( " 2 >> 士兵 类型 = %s guid = %s,进入状态 %s",self._modeType,self._guid,self._status ) )
		self:moveToBattleRegion()
	elseif self._status == self.STATUS.CANFIGHT then
		-- 可以战斗的状态 进行搜索敌人
		self:printLog(" 自己正在搜索敌人 ")
		self:searchEnemyAndMove()
	elseif self._status == self.STATUS.ATTACK then
		-- 攻击状态 攻击自己的目标敌人
		self:printLog(" 自己开始攻击目标 ")
		self:startAttackEnemy()
	end
end

-- 进入到战斗区域 子类从写
function Solider:moveToBattleRegion()
	
end

-- 搜索敌人 子类从写
function Solider:searchEnemyAndMove()
	-- 检查状态
	if self._status ~= self.STATUS.CANFIGHT then
		return
	end
	-- 1:当没有敌人
	if #self._enemyList == 0 then
		self:playIdle( true )
		return
	end
	-- 2:查找目标敌人
	self:choiceDestEnemy()
	--3:移动并攻击
	if self._destEnemy then
		-- 判断自己是否可以攻击目标
		local rect1 = self:getAttackBoundingBox()
		local rect2 = self._destEnemy:getDesignBoundingBox()
		if cc.rectIntersectsRect( rect1, rect2 ) then
			-- 1:可以攻击 设置状态
			self:setStatus( self.STATUS.ATTACK )
		else
			-- 2:移向目标敌人
			self:playMove()
			local p1 = cc.p( self:getPosition() )
			local p2 = cc.p( self._destEnemy:getPosition() )
			-- 设置朝向
			if p1.x < p2.x then
				self:setDirection( 2 )
			elseif p1.x > p2.x then
				self:setDirection( 1 )
			end
			local x_speed,y_speed = self:getAngleBySpeedForXAndY( p1,p2,self._config.speed )
			local pos_x = self:getPositionX() + x_speed
			local pos_y = self:getPositionY() + y_speed
			self:setPositionX( pos_x )
			self:setPositionY( pos_y )
		end
	end
	-- 打印
	if self._destEnemy then
		local str = string.format(" 自己搜索敌人成功 敌人的信息 mode = %s guid = %s,hp = %s,state = %s ",
				self._destEnemy:getModeType(),self._destEnemy:getSoliderGUID(),self._destEnemy:getHp(),
				self._destEnemy:getStatus() )
		self:printLog( str )
	end
end

-- 选择敌人
function Solider:choiceDestEnemy()
	-- 1:从自己被攻击的敌人队列优先选择
	if table.nums(self._attackedMyEnemyList) > 0 then
		-- 需要重置攻击目标
		local min_dis = nil
		local my_pos = cc.p( self:getPosition() )
		for k,v in pairs( self._attackedMyEnemyList ) do
			local enemy_pos = cc.p( v:getPosition() )
			local dis = cc.pGetDistance( my_pos,enemy_pos )
			if min_dis == nil then
				min_dis = dis
				self._destEnemy = v
			else
				if dis < min_dis then
					min_dis = dis
					self._destEnemy = v
				end
			end
		end
		return self._destEnemy
	end
	-- 2:自己没有被攻击 没有目标敌人--> 优先选择没有被攻击的敌人为目标 且距离最近的
	local choice_list = {}
	local temp_list = {}
	for i,v in ipairs( self._enemyList ) do
		if table.nums(v:getBeAttackedList()) == 0 then
			table.insert( temp_list,v )
		end
	end
	if #temp_list > 0 then
		choice_list = temp_list
	else
		choice_list = self._enemyList
	end
	-- 查找最近的
	local min_dis = nil
	local my_pos = cc.p( self:getPosition() )
	for i,v in ipairs( choice_list ) do
		-- 必须在战斗区域的敌人 才能有效
		local enemy_pos = cc.p( v:getPosition() )
		local rect = self._gameLayer.CenterPanel:getBoundingBox()
		if cc.rectContainsPoint( rect,enemy_pos ) then
			local dis = cc.pGetDistance( my_pos,enemy_pos )
			if min_dis == nil then
				min_dis = dis
				self._destEnemy = v
			else
				if dis < min_dis then
					min_dis = dis
					self._destEnemy = v
				end
			end
		end
	end
	return self._destEnemy
end

-- 攻击自己选择的目标敌人
function Solider:startAttackEnemy()
	-- 检查状态
	if self._status ~= self.STATUS.ATTACK then
		self:printLog(" startAttackEnemy 状态出错 不是攻击状态")
		return
	end
	-- 检查 并重置状态
	if not self:isDestEnemyLife() then
		self:printLog(" startAttackEnemy 出错 敌人不存在")
		self:printLog("从新开帧2")
		self:resetCanFightStatus()
		return
	end
	-- 1:移动到跟目标位置 y轴一样
	local my_posY = self:getPositionY()
	local enemy_posY = self._destEnemy:getPositionY()
	if math.abs( my_posY - enemy_posY ) > 1 and self._config.attack_type == 1 then
		self:printLog("开始校准位置 必须是近战")
		if my_posY > enemy_posY then
			self:setPositionY( my_posY - 1 )
		else
			self:setPositionY( my_posY + 1 )
		end
	else
		-- 关闭定时器
		self:unscheduleUpdate()
		-- 2:开始攻击
		local str = string.format( "开始攻击敌人 敌人类型 = %s guid = %s,hp = %s, 状态 = %s",
			self._destEnemy:getModeType(),self._destEnemy:getSoliderGUID(),self._destEnemy:getHp(), self._destEnemy:getStatus() )
		self:printLog( str )
		self:playIdle( false,function() 
			self:attackEnemy() 
		end )
	end
end

function Solider:attackEnemy()
	-- 检查状态
	if self._status ~= self.STATUS.ATTACK then
		self:printLog(" attackEnemy 状态出错 不是攻击状态")
		return
	end
	-- 检查 并重置状态
	if not self:isDestEnemyLife() then
		self:printLog(" attackEnemy 出错 敌人不存在")
		self:printLog("从新开帧3")
		self:resetCanFightStatus()
		return
	end

	-- 判断自己能否攻击敌人
	local rect1 = self:getAttackBoundingBox()
	local rect2 = self._destEnemy:getDesignBoundingBox()
	if not cc.rectIntersectsRect( rect1, rect2 ) then
		self:printLog(" attackEnemy 出错 与敌人不相交")
		self._destEnemy = nil
		self:printLog("从新开帧4")
		self:resetCanFightStatus()
		return
	end


	-- 将自己加入到目标敌人的攻击队列中
	self._destEnemy:addAttackMyEnemyList( self )

	local call_back = function()
		self:printLog( "攻击动画结束 开始计算 os.time = "..os.time() )
		-- 检查 并重置状态
		if not self:isDestEnemyLife() then
			self:printLog("从新开帧5")
			self:resetCanFightStatus()
			return
		end
		self._destEnemy:setHpByHurt( self._config.attack_value )
		-- 播放静止帧 来充当时间间隔
		self:playIdle( false,function()
			self:attackEnemy()
		end )
	end
	self:printLog( "播放攻击动画 os.time = "..os.time() )
	self:playAttack( call_back )
end

-- 检查目标敌人是否存在
function Solider:isDestEnemyLife()
	if (not self._destEnemy) or (self._destEnemy:getHp() <= 0) then
		return false
	end
	return true
end

-- 重置自己的状态为可以战斗的状态
function Solider:resetCanFightStatus()
	-- 开帧
	self:setStatus( self.STATUS.CANFIGHT )
	self._curFrameName = nil
	self:playIdle( true )
	self:unscheduleUpdate()
	self:onUpdate( function() self:updateStatus() end )
end

-- 自己死亡
function Solider:setDead()
	self:setStatus( self.STATUS.DEAD )
	self:printLog("自己死亡")
	-- 播放死亡动画
	self._gameLayer:soliderDead( self._guid,self._modeType )
	local call_back = function()
		self:removeFromParent()
	end
	self:playDead( call_back )
end

-- 根据guid 清空自己的目标敌人
function Solider:clearDestByGuid( guid )
	assert( guid," !! guid is nil !!" )
	if not self._destEnemy then
		return
	end
	if self._destEnemy:getSoliderGUID() == guid then
		self:printLog("自己的目标死亡，清除目标类型的指针 guid = "..guid)
		self._destEnemy = nil
		self:printLog("从新开帧1")
		self:resetCanFightStatus()
	end
end

function Solider:getAngleByPos(p1,p2)
    local p = {}
    p.x = p2.x - p1.x
    p.y = p2.y - p1.y
    local r = math.atan2(p.y,p.x)*180/math.pi
    return r
end

function Solider:getAngleBySpeedForXAndY( p1,p2,speed )
    -- 同一个点
    if p1.x == p2.x and p1.y == p2.y then
        return 0,0
    end
    local p = {}
    p.x = p2.x - p1.x
    p.y = p2.y - p1.y
    local r = self:getAngleByPos( p1,p2 )
    -- print( "当前的角度:"..r )
    if r == 0 then
        -- 0度
        return speed,0
    elseif r == 90 then
        return 0,speed
    elseif r == 180 then
        return -speed,0
    elseif r == -90 then
        return 0,-speed
    end
    local x_speed = speed * math.cos(math.rad(r))
    local y_speed = speed * math.sin(math.rad(r))
    return x_speed,y_speed
end


return Solider