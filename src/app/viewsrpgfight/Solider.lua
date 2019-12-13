

local Solider = class("Solider",BaseNode) 

Solider.STATUS = {
	-- CREATE = "create", -- 刚刚创建的状态
	-- MARCH = "march", -- 行军状态
	
	
	
	-- SELECT = "select", -- 选中状态
	


	DEAD = "dead", -- 死亡状态
	CANFIGHT = "can_fight", -- 可以战斗的状态 搜索敌人
	ATTACK = "attack", -- 攻击敌人状态
	MOVE = "move", -- 移动状态
}

function Solider:ctor( soliderId,gameLayer )
	assert( soliderId," !! soliderId is nil !! " )
	assert( gameLayer," !! gameLayer is nil !! " )
	Solider.super.ctor( self,"Solider" )
	self:addCsb( "csbhunzhan/NodeSolider.csb" )
	self._id = soliderId
	self._gameLayer = gameLayer
	self._guid = getGUID()
	self._config = rpgsolider_config[self._id]
	self._status = self.STATUS.CANFIGHT
	self._hp = self._config.hp
	
	self._modeType = "" -- "people" 玩家 "enemy" 敌人

	
	local path = self._config["idle_frame"].path.."1.png"
	self.Icon:loadTexture( path,1 )


	-- 地图中坐标
	self._blockMapPos = nil
	-- 方向 1:向左 2:向右
	self._dir = 1
	-- 自己的目标敌人
	self._destEnemy = nil
	-- 攻击自己的近战敌人列表
	self._attackedMyEnemyList = {} 
end





-- 设置在地图中的坐标
function Solider:setBlockPos( col,row )
	assert( col," !! col is nil !! " )
	assert( row," !! row is nil !! ")
	self._blockMapPos = { col = col,row = row }
end
function Solider:getBlockPos()
	return self._blockMapPos
end
-- 子类重写
function Solider:setDirection( dir )
	if self._dir ~= dir then
		self._dir = dir
		self.Icon:getVirtualRenderer():getSprite():setFlippedX( self._dir == 1 )
	end
end
function Solider:getDir()
	return self._dir
end
function Solider:getBrickId()
	return self._brickId
end
function Solider:getDestEnemy()
	return self._destEnemy
end
function Solider:getAttackType()
	return self._config.attack_type
end
function Solider:getStatus()
	return self._status
end
function Solider:setStatus( status )
	if self._status ~= status then
		self._status = status
	end
end
function Solider:getSoliderGUID()
	return self._guid
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
		self.Icon:getVirtualRenderer():getSprite():setFlippedX( self._dir == 1 )
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
-- 播放idle动画
function Solider:playIdle( isRepeate,callBack )
	self:playFrameAction("idle_frame",isRepeate,callBack)
end




function Solider:onEnter()
	Solider.super.onEnter( self )
	-- 开帧
	self:onUpdate( function() self:updateStatus() end )
end


function Solider:updateStatus( dt )

	-- 处于攻击的标志 节约性能 直接return
	if self.m_attackMark then
		return
	end

	-- 1:自己当前是否死亡
	if self._status == self.STATUS.DEAD then
		self:printLog(" updateStatus 自己死亡")
		return
	end
	-- 2:当自己有敌人
	if self._destEnemy then
		-- 1:敌人是否死亡
		if self._destEnemy:isDead() then
			self:printLog(" updateStatus 目标死亡 出错")
			self._destEnemy = nil
			return
		end
		-- 2:存在
		if self._config.attack_type == 1 then
			-- 自己是近战 判断要攻击的目标 他的近战敌人是否已经满了
			if self._destEnemy:isCloseCombatFull() then
				self:printLog(" updateStatus 自己是近战 攻击目标的近战单位已满")
				self._destEnemy = nil
				return
			end
		end
		-- >> 根据距离判断能否攻击敌人
		if self:canFightDestEnemy() then
			-- 开始攻击敌人
			self:setStatus( self.STATUS.ATTACK )
			self:attackEnemy()
			return
		end

		-- >> 不能攻击 行走一个单元格
		-- 判断能否移动


		return
	end

	-- 3:没有敌人目标
end


----------------------------------死亡相关 START --------------------
-- 自己死亡
function Solider:setDead()
	self:setStatus( self.STATUS.DEAD )
	-- 关闭定时器
	self:unscheduleUpdate()
	self:printLog("自己死亡")
	-- 播放死亡动画
	self._gameLayer:soliderDead( self._guid,self._modeType )
	local call_back = function()
		self:removeFromParent()
	end
	self:playDead( call_back )
end

function Solider:setHpByHurt( hurtValue )
	if self._hp <= 0 then
		return
	end
	self._hp = self._hp - hurtValue
	self:printLog( "当前正在受到攻击的log" )
	self.Hp:setPercent( self._hp / self._config.hp * 100 )
	if self._hp <= 0 then
		-- 死亡
		self:setDead()
	end
end

-- 播放死亡动画
function Solider:playDead( callBack )
	self:playFrameAction("dead_frame",false,callBack )
end

function Solider:isDead()
	return self._status == self.STATUS.DEAD
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
	end
end


----------------------------------死亡相关 ENd --------------------







-------------------------------- 被攻击列表相关 START -------------------------
-- 当攻击自己的近战士兵死亡 从自己的敌人列表清除
function Solider:removeAttackMyEnemyList( guid )
	assert( guid," !! guid is nil !! " )
	if self._attackedMyEnemyList[guid] then
		self._attackedMyEnemyList[guid] = nil
	end
end
function Solider:getBeAttackedList()
	return self._attackedMyEnemyList
end
-- 加入solider到攻击自己的敌人队列中
function Solider:addAttackMyEnemyList( solider )
	local guid = solider:getSoliderGUID()
	self._attackedMyEnemyList[guid] = solider
end
-- 判断自己的近战攻击点位是否已经满了
function Solider:isCloseCombatFull()
	if table.nums( self._attackedMyEnemyList ) < 4 then
		return false 
	end
	local num = 0
	for k,v in pairs( self._attackedMyEnemyList ) do
		if v:getAttackType() == 1 then
			-- 近战
			num = num + 1
		end
	end
	assert( num > 4," !! error 攻击自己近战的敌人超过了4个 !! " )
	return num == 4
end
-------------------------------- 被攻击列表相关 END -------------------------






-------------------------------- 攻击相关 START -------------------------

-- 判断能否攻击自己的敌人
function Solider:canFightDestEnemy()
	assert( self._destEnemy," !! self._destEnemy is nil !! " )
	local enemy_block = self._destEnemy:getBlockPos()
	local col_dis = math.abs(self._blockMapPos.col - enemy_block.col)
	local row_dis = math.abs(self._blockMapPos.row - enemy_block.row)
	local total_dis = col_dis + row_dis
	return self._config.attack_distance >= total_dis
end

-- 攻击自己的敌人
function Solider:attackEnemy()
	-- 检查状态
	if self._status ~= self.STATUS.ATTACK then
		self:printLog(" attackEnemy 状态出错 不是攻击状态")
		return
	end

	self.m_attackMark = true
	-- 将自己加入到目标敌人的攻击队列中
	self._destEnemy:addAttackMyEnemyList( self )
	local call_back = function()
		-- 敌人受伤
		self._destEnemy:setHpByHurt( self._config.attack_value )
		-- 播放静止帧 来充当时间间隔
		self:playIdle( false,function()
			self.m_attackMark = nil
		end )
	end
	self:playAttack( call_back )
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

-------------------------------- 攻击相关 END -------------------------















-------------------------------- 移动相关 START -------------------------

-- 判断自己能否移动
function Solider:canMove()

	local enabled_brack = {}
	local top = { col = self._blockMapPos.col,row = self._blockMapPos.row + 1 }
	if top.row <= self._gameLayer:getMaxRow() then
		table.insert( enabled_brack,top )
	end
	local down = { col = self._blockMapPos.col,row = self._blockMapPos.row - 1 }
	if down.row >= 1 then
		table.insert( enabled_brack,down )
	end
	local left = { col = self._blockMapPos.col - 1 ,row = self._blockMapPos.row }
	if left.col >= 1 then
		table.insert( enabled_brack,left )
	end
	local right = { col = self._blockMapPos.col + 1 ,row = self._blockMapPos.row }
	if right.col <= self._gameLayer:getMaxCol() then
		table.insert( enabled_brack,right )
	end

	-- 筛选出可以移动的点
	local can_move_brack = {}
	for k,v in ipairs( enabled_brack ) do
		if self._gameLayer:isEmptyBrack( v.col,v.row ) then
			table.insert( can_move_brack,v )
		end
	end

	-- 当只有一个点
	if #can_move_brack == 1 then
		return true,can_move_brack[1]
	end

	if #can_move_brack > 1 then
		-- 朝目标最近的能攻击点位方向筛选(优先横着走 列的移动)

	end

	return false
end


-- 跑向敌人 只移动一个单元格
function Solider:runToEnemy()

	self:setStatus( self.STATUS.MOVE )

	local enemy_block = self._destEnemy:getBlockPos()
	

	
	local pos = self._gameLayer:getBrackPos(self._brickId.col,self._brickId.row)
	local move_to = cc.MoveTo:create(1,pos)
	local call = cc.CallFunc:create(function ()
		self._status = self.STATUS.CANFIGHT
	end)
	local seq = cc.Sequence:create(move_to,call)
	self:runAction(seq)
end

-- 获取自己周围的4个点
function Solider:getAroundBrack()
end

-------------------------------- 移动相关 END -------------------------
































function Solider:printLog( str )
	print( string.format( " 自己的 type = %s hp= %s guid = %s,statue= %s 额外信息 = %s",self._modeType,self._hp,self._guid,self._status,str ) )
end





-- 播放移动动画
function Solider:playMove()
	self:playFrameAction("move_frame",true)
end









function Solider:getHp()
	return self._hp
end
function Solider:addHp( hp )
	self._hp = self._hp + hp
	if self._hp > hunsolider_config[self._id].hp then
		self._hp = hunsolider_config[self._id].hp
	end
	self.Hp:setPercent( self._hp / self._config.hp * 100 )
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



























-- 检查目标敌人是否存在
function Solider:isDestEnemyLife()
	if (not self._destEnemy) or (self._destEnemy:getHp() <= 0) then
		return false
	end
	return true
end




-- -- 重置自己的状态为可以战斗的状态
-- function Solider:resetCanFightStatus()
-- 	-- 开帧
-- 	self:setStatus( self.STATUS.CANFIGHT )
-- 	self._curFrameName = nil
-- 	self:playIdle( true )
-- 	self:unscheduleUpdate()
-- 	self:onUpdate( function() self:updateStatus() end )
-- end






return Solider